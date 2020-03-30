//
//  FileManager+Extension.swift
//  WarmDairy
//
//  Created by qinguanghui on 2020/3/13.
//  Copyright © 2020 qinguanghui. All rights reserved.
//

import UIKit

// MARK:- Path
public extension FileManager {
    
    /// home path
    static var homePath: String {
        
        return NSHomeDirectory()
    }
    
    /// document path
    static var documentPath: String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths.first ?? ""
    }
    
    /// library path
    static var libraryPath: String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        return paths.first ?? ""
    }
    
    /// cache path
    static var cachePath: String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        return paths.first ?? ""
    }
    
    /// tmp path
    static var tmpPath = NSTemporaryDirectory()
}

// MARK:- Size
public extension FileManager {
    
    /// 获取文件夹大小
    ///
    /// - Parameter path: 文件夹路径
    /// - Returns: 大小，单位megabyte
    static func sizeOfFolder(path: String) -> UInt64 {
        
        let fullPath = (path as NSString).expandingTildeInPath
        
        var fileAttributes: NSDictionary!
        do {
            fileAttributes = try FileManager.default.attributesOfItem(atPath: fullPath) as NSDictionary
        } catch {
            return 0
        }
        
        if fileAttributes.fileType() == "NSFileTypeRegular" {
            return fileAttributes.fileSize()
        }
        
        let url = NSURL(fileURLWithPath: fullPath)
        guard let directoryEnumerator = FileManager.default.enumerator(at: url as URL, includingPropertiesForKeys: [URLResourceKey.fileSizeKey], options: [.skipsHiddenFiles], errorHandler: nil) else { return 0 }
        
        var total: UInt64 = 0
        
        for (index, object) in directoryEnumerator.enumerated() {
            guard let fileURL = object as? NSURL else { return 0 }
            var fileSizeResource: AnyObject?
            do {
                try fileURL.getResourceValue(&fileSizeResource, forKey: URLResourceKey.fileSizeKey)
            } catch {
                continue
            }
            
            guard let fileSize = fileSizeResource as? NSNumber else { continue }
            total += fileSize.uint64Value
            if index % 1000 == 0 {
                print(".", terminator: "")
            }
        }
        
        if total < 1048576 {
            total = 1
        } else {
            total = UInt64(total / 1048576)
        }
        
        return total
    }
    
}

// MARK:- File operations
public extension FileManager {
    
    /// 文件是否存在
    ///
    /// - Parameters:
    ///   - path: 文件路径
    /// - Returns: 是否存在，true存在，false不存在
    static func fileExists(atPath path: String) -> Bool {
        
        return FileManager.default.fileExists(atPath: path)
    }
    
    ///  创建目录
    ///
    /// - Parameter path: 目录的路径
    /// - Returns: 创建结果 true成功， false失败
    static func createDirectory(atPath path: String) -> Bool {
        
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            return false
        }
    }
    
    ///  删除目录及子文件
    ///
    /// - Parameter path: 目录的路径
    /// - Returns: 删除结果 true成功， false失败
    static func deleteDirectory(atPath path: String) -> Bool {
        
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    ///  删除目录下的子文件
    ///
    /// - Parameter path: 目录的路径
    /// - Returns: 删除结果 true成功， false失败
    static func deleteFiles(atDirectory directionaryPath: String) -> Bool {
        
        do {
            try FileManager.default.removeItem(atPath: directionaryPath)
            return FileManager.createDirectory(atPath: directionaryPath)
        } catch {
            return false
        }
    }
    
    ///  创建一个空文件
    ///
    /// - Parameter path: 目录的路径
    /// - Returns: 创建结果 true成功， false失败
    static func createFile(atPath path: String) -> Bool {
        
        return FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
    }
    
    ///  删除文件
    ///
    /// - Parameter path: 目录的路径
    /// - Returns: 删除结果 true成功， false失败
    static func deleteFile(atPath path: String) -> Bool {
        
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    /// 把String保存到文件
    ///
    /// - Parameters:
    ///   - info: 要保存的string
    ///   - filePath: 文件路径
    /// - Returns: 保存结果，true保存成功，false保存失败
    static func save(info: String, toFilePath filePath: String) -> Bool {
        
        do {
            try info.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
            return true
        } catch {
            return false
        }
    }
    
    /// 把图片保存到文件
    ///
    /// - Parameters:
    ///   - image: 要保存的图片
    ///   - filePath: 文件路径
    /// - Returns: 保存结果，true保存成功，false保存失败
    static func save(image: UIImage, toFilePath filePath: String) -> Bool {
        CLog("测试 ===> 保存图片")
//        if !fileExists(atPath: filePath) {
//            print("测试 ====> 文件不存在")
//            if !createFile(atPath: filePath) {
//                print("测试 ====> 创建文件失败")
//                return false
//            }
//        }
        do {
            let data = image.pngData()!
            try data.write(to: URL(fileURLWithPath: filePath))
            return true
        } catch let error {
            CLog("测试 ===> 保存失败的值为: \(error)")
            return false
        }
    }
    
    /// 把数组保存到文件
    ///
    /// - Parameters:
    ///   - objects: 要保存的数组
    ///   - filePath: 文件路径
    /// - Returns: 保存结果，true保存成功，false保存失败
    static func save(objects: NSArray, toFilePath filePath: String) -> Bool {
        
        return objects.write(toFile: filePath, atomically: true)
    }
    
    /// 把字典保存到文件
    ///
    /// - Parameters:
    ///   - dictionary: 要保存的字典
    ///   - filePath: 文件路径
    /// - Returns: 保存结果，true保存成功，false保存失败
    static func save(dictionary: NSDictionary, toFilePath filePath: String) -> Bool {
        
        return dictionary.write(toFile: filePath, atomically: true)
    }
    
    /// 读文件内容
    ///
    /// - Parameters:
    ///   - filePath: 文件路径
    /// - Returns: 文件内容
    static func contentsOfFile(atPath path: String) -> Data? {
        
        return FileManager.default.contents(atPath: path)
    }
    
}

