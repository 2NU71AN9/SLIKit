//
//  LocationService.swift
//  SLIKit
//
//  Created by 孙梁 on 2018/5/24.
//  Copyright © 2018年 fg. All rights reserved.
//

import UIKit
import CoreLocation
import RxCocoa

public extension SL {
    static var location: SLEx<SLLocationService> {
        SLLocationService.shared.sl
    }
}

public extension SLEx where Base: SLLocationService {
    @discardableResult
    func start(_ continued: Bool = false) -> SLEx {
        base.start(continued)
        return self
    }
    
    @discardableResult
    func stop() -> SLEx {
        base.stop()
        return self
    }
    
    @discardableResult
    func requestOnce(_ complete: ((Location?) -> Void)?) -> SLEx {
        base.requestOnce(complete)
        return self
    }
}

public final class SLLocationService: NSObject {

    public let ltSubject = BehaviorRelay<Location?>(value: nil)
    public var complete: ((Location?) -> Void)?
    public var cur_lt: CLLocation?
    /// 持续定位
    public var continued = false

    @objc public static let shared = SLLocationService()
    private let geocoder = CLGeocoder()
    private lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        // 精确的读取位置信息，消耗电量较多
        manager.desiredAccuracy = kCLLocationAccuracyBest
        // 此设置会智能调节：例如当你过马路或者停止的时候，它会智能的更改配置帮用户节省电量
        manager.activityType = .fitness
        // 重新定位的最小变化距离(m)。不影响电量，位移信息不是一条直线而是有很多锯齿，高精度的 distanceFilter 可以减少锯齿，给你一个更精确地轨迹，但是，太高的精度值会让你的轨迹像素化(看到很多马赛克)，所以10m是一个相对比较合适的值
        manager.distanceFilter = 10.0
//        manager.requestAlwaysAuthorization()
//        manager.pausesLocationUpdatesAutomatically = false
//        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
}

public extension SLLocationService {
    func start(_ continued: Bool = false) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    func stop() {
        locationManager.stopUpdatingLocation()
    }

    func requestOnce(_ complete: ((Location?) -> Void)?) {
        locationManager.requestLocation()
        self.complete = complete
    }
}

extension SLLocationService: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        var lt = Location(location: newLocation, placemark: nil)

        // 尽量减少对服务器的请求和反向查询
        if let oldLocation = cur_lt {
            let distance = newLocation.distance(from: oldLocation)
            if distance < 1000 { return }
        }
        cur_lt = newLocation
        geocoder.reverseGeocodeLocation(newLocation) { [weak self] (placemarks, error) in
            DispatchQueue.global().sync { [weak self] in
                if error != nil {
                    print("self reverse geocode fail: \(String(describing: error?.localizedDescription))")
                    self?.ltSubject.accept(nil)
                    self?.complete?(nil)
                } else {
                    if !(self?.continued)! { self?.stop() }
                    if let placemarks = placemarks {
                        if let firstPlacemark = placemarks.first {
                            lt.placemark = firstPlacemark
                            // 地理位置更改后调用
                            self?.ltSubject.accept(lt)
                            self?.complete?(lt)
                        }
                    }
                }
            }
        }
    }
}


public struct Location {
    public var location: CLLocation
    public var placemark: CLPlacemark?
}

extension Location {
    /// 地址
    var addressDesc: String? {
        placemark?.locality ?? placemark?.name ?? placemark?.country
    }
    /// 经度
    var longitude: Double {
        location.coordinate.longitude
    }
    /// 纬度
    var latitude: Double {
        location.coordinate.latitude
    }
    
//    var gaoDeLocation: CLLocation? {
//        let coor = AMapCoordinateConvert(location.coordinate, .GPS)
//        return CLLocation(latitude: coor.latitude, longitude: coor.longitude)
//    }
}
