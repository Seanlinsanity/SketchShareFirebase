//
//  EditUserController.swift
//  SketchShareFirebase
//
//  Created by SEAN on 2018/8/15.
//  Copyright © 2018 com.sketchshare. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class EditUserController: UIViewController {
    
    var user: UserObject?{
        didSet{
            nameTextField.text = user?.userBrief.nick_name.val as? String
            emailTextField.text = user?.userBrief.email.val as? String
            
            userVariable = BehaviorRelay(value : user ?? UserObject())
            userVariableObserver = userVariable?.asObservable()

        }
    }
    
    var userVariable: BehaviorRelay<UserObject>?
    var userVariableObserver: Observable<UserObject>?
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 50
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Name"
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter name..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Email"
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter email..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(handleEditCompletion))
        
        setupUI()
        
    }
    
    private func setupUI(){
        view.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 96).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(emailLabel)
        emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        emailLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: emailLabel.topAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: emailLabel.rightAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: emailLabel.heightAnchor).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    @objc private func handleEditCompletion(){
        user?.userBrief.nick_name.val = nameTextField.text
        user?.userBrief.email.val = emailTextField.text
        user?.userBrief.updateModel().then({ (success) in
            if success {
//                guard let user = self.user else { return }
//                self.userVariable?.accept(user)
                self.dismiss(animated: true, completion: nil)
            }
        }).catch({ (error) in
            print("update user error: ", error)
        })
        
    }
    
}
