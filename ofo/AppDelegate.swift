//
//  AppDelegate.swift
//  ofo
//
//  Created by swift on 2017/5/11.
//  Copyright © 2017年 swift. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AMapServices.shared().apiKey = "9afaf13cfb82c7945ad8982d823d01c5"
        AMapServices.shared().enableHTTPS = true
        return true
    }



}

