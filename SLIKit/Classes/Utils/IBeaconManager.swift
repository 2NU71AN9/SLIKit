//
//  IBeaconManager.swift
//  iBeaconTest
//
//  Created by 孙梁 on 2022/4/26.
//

import UIKit
import CoreLocation

/**
 所需权限:
    Privacy - Location Always and When In Use Usage Description
    Privacy - Location Always Usage Description
    Privacy - Location When In Use Usage Description
    Privacy - Bluetooth Always Usage Description
 
 Background Modes:
    Location updates
    Uses Bluetooth LE accessories
    Background fetch
 */

public enum BeaconCallbackType {
    case rangingBeacons(beacons: [CLBeacon])
    case didEnterRegion(region: CLBeaconRegion)
    case didExitRegion(region: CLBeaconRegion)
    case failure(msg: String?)
}


public class SLIBeaconManager: NSObject {
    
    public typealias callback = ((BeaconCallbackType) -> Void)
    
    public static let shared = SLIBeaconManager()

    public weak var delegate: CLLocationManagerDelegate? {
        didSet {
            locationManager.delegate = delegate
        }
    }
    
    fileprivate var beaconCallback: callback?

    private var rangingRegions: [CLBeaconRegion] = []
    private var willRangingRegion: CLBeaconRegion?
    
    // 监听IBeacon的locationManager
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = delegate
        return manager
    }()
}

extension SLIBeaconManager {
    /// 开始监听
    public func startRangingWith(uuid: String, major: UInt16? = nil, minor: UInt16? = nil, then: callback?) {
        guard let uid = UUID(uuidString: uuid) else {
            then?(.failure(msg: "UUID不正确"))
            return
        }
        var region: CLBeaconRegion?
        if let major = major, let minor = minor {
            region = CLBeaconRegion(uuid: uid, major: major, minor: minor, identifier: uuid)
        } else if let major = major {
            region = CLBeaconRegion(uuid: uid, major: major, identifier: uuid)
        } else {
            region = CLBeaconRegion(uuid: uid, identifier: uuid)
        }
        startRangingRegion(region!, then: then)
    }
    
    /// 开始监听
    public func startRangingRegion(_ region: CLBeaconRegion, then: callback?) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        beaconCallback = then
        region.notifyOnEntry = true  // 进入iBeaconRegion区域时，触发代理方法
        region.notifyOnExit = true   // 离开iBeaconRegion区域时，触发代理方法
        region.notifyEntryStateOnDisplay = true
        //检测设备是否支持IBeacon监控功能
        let availbleMonitor = CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self)
        //获取当前APP定位状态
        let status = CLLocationManager.authorizationStatus()
        if availbleMonitor {
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                //开始监听
                locationManager.startMonitoring(for: region)
                locationManager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: region.uuid))
                rangingRegions.append(region)
            } else if status == .notDetermined {
                willRangingRegion = region
                locationManager.requestAlwaysAuthorization()
            } else {
                then?(.failure(msg: "用户拒绝授权"))
            }
        } else {
            then?(.failure(msg: "设备不支持"))
        }
    }
    
    /// 结束监听
    public func stopRanging() {
        for region in rangingRegions {
            locationManager.stopMonitoring(for: region)
            locationManager.stopRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: region.uuid))
        }
        rangingRegions = []
    }
    
    /// 定位权限变化后会调用
    fileprivate func authorizationChanged(status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse,
            let region = willRangingRegion {
            startRangingRegion(region, then: beaconCallback)
            willRangingRegion = nil
        }
    }
    
    /// 发送本地通知
    /// - Parameters:
    ///   - id: id相同而内容不同时会更新已经显示的通知
    ///   - title: 标题
    ///   - subTitle: 副标题
    ///   - body: 内容
    public static func sendNotificationWith(id: String, title: String?, subTitle: String? = nil, body: String?) {
        let content = UNMutableNotificationContent()
        content.title = title ?? ""
        content.subtitle = subTitle ?? ""
        content.body = body ?? ""
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                print("通知已经发送: ", id)
            }
        }
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        SLIBeaconManager.shared.authorizationChanged(status: status)
    }

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        SLIBeaconManager.shared.authorizationChanged(status: CLLocationManager.authorizationStatus())
    }

    ///  监控成功
    public func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("监控成功")
    }
    ///  监控失败
    public func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        SLIBeaconManager.shared.beaconCallback?(.failure(msg: "Monitoring监控失败"))
    }

    /// 进入iBeaconRegion区域
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let region = region as? CLBeaconRegion {
            SLIBeaconManager.shared.beaconCallback?(.didEnterRegion(region: region))
        }
    }
    /// 离开iBeaconRegion区域
    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let region = region as? CLBeaconRegion {
            SLIBeaconManager.shared.beaconCallback?(.didExitRegion(region: region))
        }
    }

    /// 监测到iBeacon设备
    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        guard !beacons.isEmpty else { return }
        SLIBeaconManager.shared.beaconCallback?(.rangingBeacons(beacons: beacons))
    }

    // Ranging有错误产生
    public func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        SLIBeaconManager.shared.beaconCallback?(.failure(msg: "Ranging错误"))
    }
}
