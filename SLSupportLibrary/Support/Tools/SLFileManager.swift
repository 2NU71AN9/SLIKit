//
//  SLFileManager.swift
//  SLSupportLibrary
//
//  Created by RY on 2018/8/9.
//  Copyright © 2018年 SL. All rights reserved.
//

import UIKit

public class SLFileManager {

    // 获取缓存大小
    public static func access2Cache() -> String {
        return String(format: "%.2fM", SLFileManager.forderSizeAtPath(NSHomeDirectory()))
    }
    
    /// 删除缓存
    ///
    /// - Parameter competion: 完成闭包
    public static func cleanCache(competion:() -> Void) {
        SLFileManager.deleteFolder(path: NSHomeDirectory() + "/Documents")
        SLFileManager.deleteFolder(path: NSHomeDirectory() + "/Library")
        SLFileManager.deleteFolder(path: NSHomeDirectory() + "/tmp")
        competion()
    }
    
    
    /// 获取路径下的所有文件大小
    ///
    /// - Parameter folderPath: 路径
    /// - Returns: 文件大小
    public static func forderSizeAtPath(_ folderPath:String) -> Double {
        let manage = FileManager.default
        if !manage.fileExists(atPath: folderPath) {
            return 0
        }
        let childFilePath = manage.subpaths(atPath: folderPath)
        var fileSize:Double = 0
        for path in childFilePath! {
            let fileAbsoluePath = folderPath+"/"+path
            fileSize += returnFileSize(path: fileAbsoluePath)
        }
        return fileSize
    }
    
    /// 获取单个文件大小
    ///
    /// - Parameter path: 路径
    /// - Returns: 文件大小
    public static func returnFileSize(path:String) -> Double {
        let manager = FileManager.default
        var fileSize:Double = 0
        do {
            let attr = try manager.attributesOfItem(atPath: path)
            fileSize = Double(attr[FileAttributeKey.size] as! UInt64)
            let dict = attr as NSDictionary
            fileSize = Double(dict.fileSize())
        } catch {
            dump(error)
        }
        return fileSize/1024/1024
    }
    
    /// 删除路径下的所有文件
    ///
    /// - Parameter path: 路径
    public static func deleteFolder(path: String) {
        let manage = FileManager.default
        if !manage.fileExists(atPath: path) {
        }
        let childFilePath = manage.subpaths(atPath: path)
        for path_1 in childFilePath! {
            let fileAbsoluePath = path+"/"+path_1
            deleteFile(path: fileAbsoluePath)
        }
    }
    
    /// 删除单个文件
    ///
    /// - Parameter path: 路径
    public static func deleteFile(path: String) {
        let manage = FileManager.default
        do {
            try manage.removeItem(atPath: path)
        } catch {
        }
    }
}
