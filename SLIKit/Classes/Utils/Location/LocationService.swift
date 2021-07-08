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
    /// 重新定位的最小变化距离(m)
    @discardableResult
    func minMeter(_ meter: Double) -> SLEx {
        base.minMeter = meter
        return self
    }
    /// 定位精确度
    @discardableResult
    func accuracy(_ accuracy: CLLocationAccuracy) -> SLEx {
        base.accuracy = accuracy
        return self
    }
    @discardableResult
    func complete(_ complete: ((Location?) -> Void)?) -> SLEx {
        base.complete = complete
        return self
    }
    
    /// 开始定位
    /// - Parameter continued: 持续定位, 如果持续定位,后面不需要定位时需要手动关闭
    @discardableResult
    func start(_ continued: Bool = false) -> SLEx {
        base.start(continued, complete: base.complete)
        return self
    }
    
    @discardableResult
    func stop() -> SLEx {
        base.stop()
        return self
    }
}

public final class SLLocationService: NSObject {
    
    @objc public static let shared = SLLocationService()
    
    public let locationSubject = BehaviorRelay<Location?>(value: nil)
    public var complete: ((Location?) -> Void)?
    public var curLocation: Location?
    /// 定位精确度
    public var accuracy: CLLocationAccuracy = kCLLocationAccuracyBest
    /// 重新定位的最小变化距离(m)
    public var minMeter: Double = 10 {
        didSet {
            locationManager.distanceFilter = minMeter
        }
    }
    /// 持续定位
    private var continued = false
    private let geocoder = CLGeocoder()
    private lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        // 定位精确度
        manager.desiredAccuracy = accuracy
        // 此设置会智能调节：例如当你过马路或者停止的时候，它会智能的更改配置帮用户节省电量
        manager.activityType = .fitness
        // 重新定位的最小变化距离(m)。不影响电量，位移信息不是一条直线而是有很多锯齿，高精度的 distanceFilter 可以减少锯齿，给你一个更精确地轨迹，但是，太高的精度值会让你的轨迹像素化(看到很多马赛克)，所以10m是一个相对比较合适的值
        manager.distanceFilter = minMeter
//        manager.requestAlwaysAuthorization()
//        manager.pausesLocationUpdatesAutomatically = false
//        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
}

public extension SLLocationService {
    
    /// 开始定位
    /// - Parameter continued: 持续定位, 如果持续定位,后面不需要定位时需要手动关闭
    /// - Parameter complete: 定位完成回调
    func start(_ continued: Bool = false, complete: ((Location?) -> Void)?) {
        self.continued = continued
        self.complete = complete
        if continued {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
        } else {
            locationManager.requestLocation()
        }
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
}

extension SLLocationService: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationSubject.accept(nil)
        complete?(nil)
    }
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        var lt = Location(location: newLocation, placemark: curLocation?.placemark)

        // 尽量减少对服务器的请求和反向查询
        if let oldLocation = curLocation {
            let distance = newLocation.distance(from: oldLocation.location)
            if distance < minMeter {
                locationSubject.accept(lt)
                complete?(lt)
                return
            }
        }
        curLocation = lt
        geocoder.reverseGeocodeLocation(newLocation) { [weak self] (placemarks, error) in
            DispatchQueue.global().sync { [weak self] in
                guard let `self` = self else { return }
                if error != nil {
                    self.locationSubject.accept(nil)
                    self.complete?(nil)
                } else {
                    if !self.continued { self.stop() }
                    if let placemarks = placemarks {
                        if let firstPlacemark = placemarks.first {
                            lt.placemark = firstPlacemark
                            self.curLocation = lt
                            self.locationSubject.accept(lt)
                            self.complete?(lt)
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

public extension Location {
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
