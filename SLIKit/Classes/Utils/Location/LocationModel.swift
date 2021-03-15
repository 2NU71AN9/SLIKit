//
//  LocationModel.swift
//  PGJManager-iOS
//
//  Created by Kevin on 2019/1/11.
//  Copyright © 2019 fg. All rights reserved.
//

import UIKit
import HandyJSON
import CoreLocation

public struct Location {
    var location: CLLocation
    var placemark: CLPlacemark?
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
