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

protocol LoginDelegate {
    func loginWithUser()
}

class LoginController: UIViewController, GIDSignInUIDelegate {
    
    var delegate: LoginDelegate?
    
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
        userStore.currentUser = UserObject()
        firebaseManager.loginManager.signInFirebaseWithFB().then{ (uid) -> Promise<Bool> in
            userStore.currentUser.bindID(id: uid)
            return userStore.currentUser.brief.getModel()
        }.then({ [weak self] (success) in
            if success {
                self?.handleDismiss()
            }else{
                self?.fetchUserInfoFromFacebook()

            }
        }).catch({ (error) in
            print(error)
        })
    }

    private func fetchUserInfoFromFacebook(){
        firebaseManager.loginManager.getFacebookUserInfo().then({ (result) -> Promise<Bool> in
            userStore.currentUser.userBrief.email.val = result["email"] ?? ""
            userStore.currentUser.userBrief.nick_name.val = result["name"] ?? ""
            return userStore.currentUser.userBrief.updateModel()
        }).then({ (success) in
            if success {
                self.handleDismiss()
            }
        }).catch({ (error) in
            print(error)
        })
    }
    
    func signInFirebaseWithGoogle(user: GIDGoogleUser){
        userStore.currentUser = UserObject()
        firebaseManager.loginManager.signInFirebaseWithGoogle(user: user).then {(userResult) -> Promise<Bool> in
            userStore.currentUser.bindID(id: userResult.uid)
            return userStore.currentUser.brief.getModel()
        }.then {[weak self] (success) in
            if success {
                self?.handleDismiss()
            }else{
                self?.loginWithGoogleUser(googleUser: user)
            }
        }.catch { (error) in
            print(error)
        }
    }
    
    private func loginWithGoogleUser(googleUser: GIDGoogleUser?){
        userStore.currentUser.userBrief.email.val = googleUser?.profile.email ?? ""
        userStore.currentUser.userBrief.nick_name.val = googleUser?.profile.name ?? ""
        addUserInDatabase()
    }
    
    private func addUserInDatabase(){

        userStore.currentUser.userBrief.updateModel().then {(success)  in
            if success {
               self.handleDismiss()
            }
        }.catch({ (error) in
            print(error)
        })
    }
    
    func handleDismiss(){
        delegate?.loginWithUser()
        dismiss(animated: true, completion: nil)
    }


}

