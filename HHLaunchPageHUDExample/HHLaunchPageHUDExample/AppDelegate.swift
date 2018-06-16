//
//  AppDelegate.swift
//  HHLaunchPageHUDExample
//
//  Created by 薛乐 on 2018/1/7.
//  Copyright © 2018年 ethan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let adImageJPGUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1529143981755&di=1bf129963fde0d1ea114a81019b1d62c&imgtype=0&src=http%3A%2F%2Fimg5.cache.netease.com%2Fent%2F2016%2F1%2F17%2F201601170918125d493.png";
        let adimageGIFUrl = "http://img.ui.cn/data/file/3/4/6/210643.gif";
        let adImageJPGPath:String = Bundle.main.path(forResource: "adImage2", ofType: "jpg")!
        let adImageGifPath:String = Bundle.main.path(forResource: "adImage3", ofType: "gif")!
        
        HHLaunchAdPageHUD.init(frame: CGRect.init(x: 0, y: 0, width: HHScreenWidth, height: HHScreenHeight-100), aDduration: 4, aDImageUrl: adImageGifPath, hideSkipButton: false) {
            print("[AppDelegate]:点了广告图片")
            UIApplication.shared.openURL(URL.init(string: "https://www.baidu.com")!)
        }
        return true
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

