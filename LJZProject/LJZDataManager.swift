//
//  LJZDataManager.swift
//  LJZProject
//
//  Created by zhanghangzhen on 2016/12/7.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import Foundation
import SystemConfiguration


let ReachabilityDidChangeNotificationName = "ReachabilityDidChangeNotification"
enum ReachabilityStatus {
    case notReachable
    case reachableViaWiFi
    case reachableViaWWAN
}

class Reachability : NSObject {
    
    private var networkReachability: SCNetworkReachability?
    private var notifying: Bool = false
    
    /// 为了获取网络连接状态，我们定义一个flags属性来获取 SCNetworkReachability对象：
    private var flags: SCNetworkReachabilityFlags {
        var flags = SCNetworkReachabilityFlags(rawValue: 0)
        if let reachability = networkReachability, withUnsafeMutablePointer(to: &flags, { SCNetworkReachabilityGetFlags(reachability, UnsafeMutablePointer($0)) }) == true {
            return flags
        }
        else {
            return []
        }
    }
    
    /// 我创建了一个根据flags传递的值返回网络状态的函数（在方法的注释中解释了flags值所代表的链接状态）
    var currentReachabilityStatus: ReachabilityStatus {
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        } 
        else {
            return .notReachable
        }
    }
    
    /// 我们创造一个函数决定当前的网络连接状态，最终通过一个bool变量检查是否连接：
    var isReachable: Bool {
        switch currentReachabilityStatus {
        case .notReachable:
            return false
        case .reachableViaWiFi, .reachableViaWWAN:
            return true
        }
    }
    
    init?(hostName: String) {
        networkReachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, (hostName as NSString).utf8String!)
        super.init()
        if networkReachability == nil {
            return nil
        }
    }
    init?(hostAddress: sockaddr_in) {
        var address = hostAddress
        
        guard let defaultRouteReachability = withUnsafePointer(to: &address, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, $0)
            }
        }) else {
            return nil
        }
        networkReachability = defaultRouteReachability
        super.init()
        if networkReachability == nil {
            return nil
        }
    }
    
    /// 我们创建两个类方法 : Reachability的实例来控制网络连接
    ///
    /// - Returns: Reachability
    static func networkReachabilityForInternetConnection() -> Reachability? {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        return Reachability(hostAddress: zeroAddress)
    }
    
    /// 用来检测当我们是否连接的是本地wifi
    ///
    /// - Returns: LJZDataManager
    static func networkReachabilityForLocalWiFi() -> Reachability? {
        var localWifiAddress = sockaddr_in()
        localWifiAddress.sin_len = UInt8(MemoryLayout.size(ofValue: localWifiAddress))
        localWifiAddress.sin_family = sa_family_t(AF_INET)
        // IN_LINKLOCALNETNUM is defined inas 169.254.0.0 (0xA9FE0000).
        localWifiAddress.sin_addr.s_addr = 0xA9FE0000
        
        return Reachability(hostAddress: localWifiAddress)
    }

    
    /// 开启通知
    ///开启通知之前，先检查通知是否为开启状态。然后获取SCNetworkReachabilityContext容器，并为context 对象的info属性赋值为self。之后设置回调函数，传递context(当回调函数调用时,info参数包含的对self的引用指针将会作为第三个参数传递给block数据).如果设置回调函数成功，我们就能在run loop中管理network reachability的引用
    /// - Returns: notifying
    func startNotifier() -> Bool {
        
        guard notifying == false else {
            return false
        }
        
        var context = SCNetworkReachabilityContext()
        context.info = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        
        guard let reachability = networkReachability, SCNetworkReachabilitySetCallback(reachability, { (target: SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) in
            if let currentInfo = info {
                let infoObject = Unmanaged<AnyObject>.fromOpaque(currentInfo).takeUnretainedValue()
                if infoObject is Reachability {
                    let networkReachability = infoObject as! Reachability
                    NotificationCenter.default.post(name: Notification.Name(rawValue: ReachabilityDidChangeNotificationName), object: networkReachability)
                }
            }
        }, &context) == true else { return false }
        
        guard SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue) == true else { return false }
        
        notifying = true
        return notifying
    }
    
    /// 停止通知，我们只需要把network reachability的引用管理从run loop中移除就可以了：
    func stopNotifier() {
        if let reachability = networkReachability, notifying == true {
            SCNetworkReachabilityUnscheduleFromRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode as! CFString)
            notifying = false
        }
    }
    ///销毁
    deinit {
        stopNotifier()
    }
    
    
    
}















