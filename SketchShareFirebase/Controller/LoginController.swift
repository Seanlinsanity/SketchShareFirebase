//
//  ViewController.swift
//  SketchShareFirebase
//
//  Created by SEAN on 2018/7/11.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import FirebaseFramework
import FBSDKLoginKit
import GoogleSignIn
import Promises
import RxSwift

class LoginController: UIViewController, GIDSignInUIDelegate {
    
    var user: UserObject?
    
    let customFBLoginButton: UIButton = {
        let loginButton = UIButton(type: .system)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Facebook帳戶登入", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor(red: 66/255, green: 103/255, blue: 178/255, alpha: 1)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        return loginButton
    }()
    
    let customGoogleLoginButton: UIButton = {
        let loginButton = UIButton(type: .system)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Google帳戶登入", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor.red
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.addTarget(self, action: #selector(handleCustomGoogleSignIn), for: .touchUpInside)
        return loginButton
    }()
    
    let editableTextView: EditableTextView = {
        let tv = EditableTextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupFacebookLoginButton()
        setupGoogleLoginButton()
        
    }

    
    private func setupGoogleLoginButton(){
        view.addSubview(customGoogleLoginButton)
        customGoogleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customGoogleLoginButton.bottomAnchor.constraint(equalTo: customFBLoginButton.topAnchor, constant: -16).isActive = true
        customGoogleLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        customGoogleLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    private func setupFacebookLoginButton(){
        view.addSubview(customFBLoginButton)
        customFBLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customFBLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 16).isActive = true
        customFBLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        customFBLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc private func handleCustomGoogleSignIn(){
        GIDSignIn.sharedInstance().signIn()
    }

    @objc private func handleCustomFBLogin(){
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil{
                print("Custom FB Login failed: ", error ?? "error")
            }
            self.setupUserObject()
        }
    
    }
    
    private func setupUserObject(){
        user = UserObject()
        firebaseManager.loginManager.signInFirebaseWithFB().then{ (_) -> Promise<[String: Any]> in
            return firebaseManager.loginManager.getFacebookUserInfo()
            }.then({ (result) -> Promise<String> in
                self.user?.userBrief.email.val = result["email"] ?? ""
                self.user?.userBrief.nick_name.val = result["name"] ?? ""
                return self.user!.userBrief.addModel()
            }).then({ (uid) in
                self.user?.bindID(id: uid)
                self.presentUserController()
            }).catch({ (error) in
                print(error)
            })
    }
    
    func presentUserController(){
        let userController = UserController()
        userController.testUser = user
        self.navigationController?.pushViewController(userController, animated: true)
    }


}

