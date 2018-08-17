//
//  UserController.swift
//  SketchShareFirebase
//
//  Created by SEAN on 2018/8/15.
//  Copyright © 2018 com.sketchshare. All rights reserved.
//

import UIKit
import RxSwift

class UserController: UIViewController {
    
    let userInfoView = UserInfoView()
    let testUser = UserObject()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "編輯", style: .plain, target: self, action: #selector(handleEdit))
        
        testUser.userBrief.nick_name.val = "Sean"
        testUser.userBrief.email.val = "sean@gmail.com"
        
        setupUserInfoView()
        
    }
    
    private func setupUserInfoView(){
        userInfoView.user = testUser
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(userInfoView)
        userInfoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        userInfoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 96).isActive = true
        userInfoView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 16).isActive = true
        userInfoView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    @objc private func handleEdit(){

        let editUserController = EditUserController()
        editUserController.user = testUser
        
        editUserController.userVariableObserver?.subscribe(onNext: { [weak self] (user) in
            self?.userInfoView.user = user
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        present(UINavigationController(rootViewController: editUserController), animated: true, completion: nil)
        
    }
    
    
    
}
