//
//  UserController.swift
//  SketchShareFirebase
//
//  Created by SEAN on 2018/8/15.
//  Copyright © 2018 com.sketchshare. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseFramework
import GoogleSignIn
import Promises

class UserController: UIViewController, LoginDelegate {
    
    var userObject = UserObject()
    let disposeBag = DisposeBag()
    lazy var loginController = LoginController()

    let userInfoView: UserInfoView = {
        let userInfoView = UserInfoView()
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        return userInfoView
    }()
    
    let logoutButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("登出", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        btn.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "編輯", style: .plain, target: self, action: #selector(handleEdit))
        
        view.addSubview(logoutButton)
        logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -64).isActive = true
        logoutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        logoutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        checkUserId()
        setupUserInfoView()
        
    }
    
    private func checkUserId(){
        firebaseManager.loginManager.checkUserId().then { [weak self] (uid) in
            print(uid)
            self?.userObject.bindID(id: uid)
            self?.fetchUserBriefDatabase(uid: uid)
        }.catch { [weak self] (_) in
            self?.presentLoginController()
        }
    }
    
    private func fetchUserBriefDatabase(uid: String){
        firebaseManager.getUserBriefValue(uid: uid).then { [weak self] (userInfo) in
            guard let userInfo = userInfo else { return }
            guard let email = userInfo["email"], let nickName = userInfo["nick_name"] else { return }
            self?.userObject.userBrief.email.val = email
            self?.userObject.userBrief.nick_name.val = nickName
            self?.userInfoView.user = self?.userObject
        }.catch { (error) in
                print(error)
        }
    }
    
    private func setupUserInfoView(){
        
        view.addSubview(userInfoView)
        userInfoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        userInfoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 96).isActive = true
        userInfoView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 16).isActive = true
        userInfoView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func loginWithUser(user: UserObject) {
        userObject = user
        userInfoView.user = userObject
    }
    
    @objc private func handleEdit(){
        
        let editUserController = EditUserController()
        editUserController.user = userObject
        
        var shouldUpdate = false
        editUserController.userVariableObserver?.subscribe(onNext: { [weak self] (user) in
            
            if !shouldUpdate {
                shouldUpdate = !shouldUpdate
            }else{
                self?.userInfoView.updateUserInfo()
            }
            
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        present(UINavigationController(rootViewController: editUserController), animated: true, completion: nil)
    }
    
    @objc private func handleLogout(){
        firebaseManager.loginManager.signOut().then { (success) in
            if success {
                self.presentLoginController()
            }
        }.catch { (error) in
            print("Failed to logout: ", error)
        }
    }
    
    private func presentLoginController(){
        loginController.delegate = self
        present(loginController, animated: true, completion: nil)
    }
    
    
}
