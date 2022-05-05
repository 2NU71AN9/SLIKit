//
//  AppDelegate.swift
//  SLIKit
//
//  Created by 孙梁 on 2021/3/12.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SLIBeaconManager.shared.delegate = self
        startRanging()
        return true
    }
    
    func startRanging() {
        SLIBeaconManager.shared.startRangingWith(uuid: "FFD1F09E-5FF0-4B18-9660-395650C7D641") { res in
            switch res {
            case .rangingBeacons(let beacons):
                print("监听到 beacon: \(beacons)")
                let id = String(format: "1%@%d%d", beacons.first?.uuid.uuidString ?? "uuid", beacons.first?.major ?? 0, beacons.first?.minor ?? 0)
                SLIBeaconManager.sendNotificationWith(id: id, title: "监测到Beacon", body: String(format: "%@", beacons.first ?? ""))
            case .didEnterRegion(let region):
                print("进入范围: \(region)")
                let id = String(format: "1-%@", region.uuid.uuidString)
                SLIBeaconManager.sendNotificationWith(id: id, title: "进入Region范围", body: String(format: "%@", region))
            case .didExitRegion(let region):
                print("离开范围: \(region)")
                let id = String(format: "0-%@", region.uuid.uuidString)
                SLIBeaconManager.sendNotificationWith(id: id, title: "离开Region范围", body: String(format: "%@", region))
            case .failure(let msg):
                print(msg ?? "")
            }
        }
    }
}

