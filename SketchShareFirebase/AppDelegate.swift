//
//  AppDelegate.swift
//  SketchShareFirebase
//
//  Created by SEAN on 2018/7/11.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import FirebaseFramework
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        firebaseManager.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().delegate = self
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        let loginController = LoginController()
        window?.rootViewController = UINavigationController(rootViewController: loginController)
//       self.testUserCreation()
        return true
    }
    
    
    /// 測試上傳User brief model
//    func testUserCreation(){
//        let testUser = UserObject()
//        testUser.userBrief.nick_name.val = "jerry"
//        testUser.userBrief.email.val = "test@gmail.com"
//        
//        testUser.brief.addModel().then{_ in
//            print("Updated!")
//            userStore.currentUser = testUser
//        }
//    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Failed to log into Google", err)
            return
        }
        firebaseManager.loginManager.signInFirebaseWithGoogle(user: user).then { [weak self] (userResult) in
            guard let navigationController = self?.window?.rootViewController as? UINavigationController else { return }
            guard let rootVC = navigationController.viewControllers.first as? LoginController else { return }
            
            let userObject = UserObject()
            userObject.userBrief.email.val = userResult.email ?? ""
            userObject.userBrief.nick_name.val = userResult.displayName ?? ""
            userObject.userBrief.addModel().then { (uid)  in
                userObject.bindID(id: uid)
            }
            rootVC.user = userObject
            rootVC.presentUserController()
            
        }.catch { (error) in
            print(error)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled
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

