//
//  AppDelegate.swift
//  LJZProject
//
//  Created by zhanghangzhen on 2016/12/1.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

import UIKit
import IQKeyboardManager
import SVProgressHUD



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        AMapServices.shared().apiKey = MAP_KEY
        //设置全局的键盘处理,不显示工具条
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        SVProgressHUD.setMinimumDismissTimeInterval(2.0)
        SVProgressHUD.setBackgroundColor(UIColor.darkGray)
        window?.rootViewController = LJZMainViewController()
        window?.makeKeyAndVisible()        
        return true
    }

    
    private func initRootVC()->RAMAnimatedTabBarController{
    
        let MainVC = RAMAnimatedTabBarController()
        
        let vcs = [["首页",LJZHomeViewController()],["搜索",LJZSearchViewController()],["设置",LJZSetViewController()]]
        let nav = LJZNavViewController()
        nav.navigationBar.isTranslucent = false
        let anis = [RAMBounceAnimation(),RAMRotationAnimation(),RAMRotationAnimation(),RAMBounceAnimation()]
        let imgs = [UIImage.init(named: "icon3_"),UIImage.init(named: "icon2_"),UIImage.init(named: "icon1_")]
        for i in 0...2 {
            let baritem=RAMAnimatedTabBarItem(title: vcs[i][0] as? String,
                                              image: imgs[i],
                                              selectedImage: imgs[i])
            let ani=anis[i]
            ani.textSelectedColor = UIColor().colorWithHexString(color: "#82050b")
            ani.iconSelectedColor = UIColor().colorWithHexString(color: "#82050b")
            baritem.animation = ani
            let vc=(vcs[i][1] as? LJZBaseViewController)!;
            let nav = LJZNavViewController(rootViewController: vc)
            vc.tabBarItem = baritem
           MainVC.viewControllers?.append(nav)
        }
        return MainVC
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

