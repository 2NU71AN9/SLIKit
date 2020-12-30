//
//  SLTools.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration.CaptiveNetwork

public class SLTools {
    
    /// 拨打电话
    ///
    /// - Parameter number: 电话号码
    public static func callWithNumber(_ number: String?) {
        guard let number = number,
            let url = URL(string: "tel:\(number)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    /// 获取本机IP
    public static func getIPAddress() -> String? {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
    }
    
    
    /// 前往App Store进行评价
    public static func evaluationInAppStore(appid: String) {
        let urlString = "https://itunes.apple.com/cn/app/id" + appid + "?mt=12"
        let url = URL(string: urlString)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    /// 获取连接wifi的ip地址, 需要定位权限和添加Access WiFi information
    public static func getWiFiIP() -> String? {
        var address: String?
        // get list of all interfaces on the local machine
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        guard getifaddrs(&ifaddr) == 0,
              let firstAddr = ifaddr else { return nil }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
    
    /// 获取连接wifi的名字和mac地址, 需要定位权限和添加Access WiFi information
    public static func getWifiNameWithMac() -> (String?, String?) {
        let interfaces:NSArray = CNCopySupportedInterfaces()!
        var ssid: String?
        var mac: String?
        for sub in interfaces {
            if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(sub as! CFString)) {
                ssid = dict["SSID"] as? String
                mac = dict["BSSID"] as? String
            }
        }
        return (ssid, mac)
    }
}
