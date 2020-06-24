//
//  AppDelegate.swift
//  SwiftUIBilibili
//
//  Created by Boo on 6/16/20.
//  Copyright © 2020 boo. All rights reserved.
//

import UIKit
import LeanCloud

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 初始化LeanCloud
        
        // 开启调试日志, 在 Application 初始化代码执行之前执行
        LCApplication.logLevel = .all  // .off 关闭
        
        do {
            try LCApplication.default.set(
                id: "fnjUKhQvsD8oFXSvwk76BeBM-gzGzoHsz",
                key: "4ekLWz6lhMfHdJ3AIm8OVYJz",
                serverURL: "https://fnjukhqv.lc-cn-n1-shared.com"
            )
            
        } catch {
            print(error)
        }
        
//        LCRest.getConversationHistoryById(id: "5eef00a10d3a42c5fda6b448", callback: { l in
//            print(l,"llllll")
//        })
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

