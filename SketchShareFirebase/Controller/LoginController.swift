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
    func loginWithUser(user: UserObject)
}

class LoginController: UIViewController, GIDSignInUIDelegate {
    
    var userObject: UserObject?
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
        userObject = UserObject()
        firebaseManager.loginManager.signInFirebaseWithFB().then{ [weak self](uid) -> Promise<[String: Any]> in
            self?.userObject?.bindID(id: uid)
            //TODO: 改成brief.getModel, success??
            return firebaseManager.getValue(url: "users/brief/\(uid)")
        }.then({ [weak self] (userInfo) in
            if userInfo.count != 0 {
                self?.fetchUserInfoFromDatabase(userInfo: userInfo)
            }else{
                self?.fetchUserInfoFromFacebook()

            }
        }).catch({ (error) in
            print(error)
        })
    }
    
    private func fetchUserInfoFromDatabase(userInfo: [String: Any]?){
        guard let email = userInfo?["email"], let nickName = userInfo?["nick_name"] else { return }
        userObject?.userBrief.email.val = email
        userObject?.userBrief.nick_name.val = nickName
        handleDismiss()
    }
    
    private func fetchUserInfoFromFacebook(){
        firebaseManager.loginManager.getFacebookUserInfo().then({ [weak self](result) -> Promise<Bool> in
            self?.userObject?.userBrief.email.val = result["email"] ?? ""
            self?.userObject?.userBrief.nick_name.val = result["name"] ?? ""
            return self!.userObject!.userBrief.updateModel()
        }).then({ (success) in
            if success {
                self.handleDismiss()
            }
        }).catch({ (error) in
            print(error)
        })
    }
    
    func signInFirebaseWithGoogle(user: GIDGoogleUser){
        userObject = UserObject()
        firebaseManager.loginManager.signInFirebaseWithGoogle(user: user).then {[weak self] (userResult) -> Promise<[String: Any]> in
            self?.userObject?.bindID(id: userResult.uid)
            return firebaseManager.getValue(url: "users/brief/\(userResult.uid)")
        }.then {[weak self] (userInfo) in
            if userInfo.count != 0 {
                self?.loginWithGoogleUser(userInfo: userInfo, googleUser: nil)
            }else{
                self?.loginWithGoogleUser(userInfo: nil, googleUser: user)
            }
        }.catch { (error) in
            print(error)
        }
    }
    
    private func loginWithGoogleUser(userInfo: [String: Any]?, googleUser: GIDGoogleUser?){
        if userInfo == nil {
            userObject?.userBrief.email.val = googleUser?.profile.email ?? ""
            userObject?.userBrief.nick_name.val = googleUser?.profile.name ?? ""
            addUserInDatabase(user: userObject!)
        }else{
            guard let email = userInfo?["email"], let nickName = userInfo?["nick_name"] else { return }
            userObject?.userBrief.email.val = email
            userObject?.userBrief.nick_name.val = nickName
        }
        
        handleDismiss()
    }
    
    private func addUserInDatabase(user: UserObject){
        user.userBrief.updateModel().then {[weak self] (success)  in
            if success {
                self?.userObject = user
            }
        }.catch({ (error) in
            print(error)
        })
    }
    
    func handleDismiss(){
        guard let userObject = userObject else { return }
        delegate?.loginWithUser(user: userObject)
        dismiss(animated: true, completion: nil)
    }


}

