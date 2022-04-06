//
//  Ex_CLPlacemark.swift
//  Kenide
//
//  Created by 孙梁 on 2022/3/17.
//

import CoreLocation

public extension CLPlacemark {
    var city_area_road: String? {
        String(format: "%@%@%@", locality ?? "", subLocality ?? "", name ?? "")
    }
}
