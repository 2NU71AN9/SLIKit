//
//  Ex_CLLocationCoordinate2D.swift
//  Kenide
//
//  Created by 孙梁 on 2022/3/12.
//

import UIKit
import MapKit

public extension CLLocationCoordinate2D {
    func getPositionFrom(_ from: CLLocationCoordinate2D) -> String {
        let lat1 = from.latitude * Double.pi / 180
        let lon1 = from.longitude * Double.pi / 180
        
        let lat2 = latitude * Double.pi / 180
        let lon2 = longitude * Double.pi / 180
        
        let dLon = lon2 - lon1
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        let aDeg = radiansBearing * 180 / Double.pi
        var str = ""
        if aDeg >= 75 && aDeg <= 105 {
                str = "正东"
        } else if aDeg > 15 && aDeg < 75 {
                str = "东北"
        } else if aDeg >= -15 && aDeg <= 15 {
                str = "正北"
        } else if aDeg > -75 && aDeg < -15 {
            str = "西北"
        } else if aDeg >= -105 && aDeg <= -75 {
            str = "正西"
        } else if aDeg > -165 && aDeg < -105 {
            str = "西南"
        } else if (aDeg >= 165 && aDeg <= 180) || (aDeg >= -180 && aDeg <= -165) {
            str = "正南"
        } else if aDeg > 105 && aDeg < 165 {
            str = "东南"
        }
        return str
    }
}
