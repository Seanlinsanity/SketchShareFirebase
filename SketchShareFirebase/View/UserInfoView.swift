//
//  UserInfoView.swift
//  SketchShareFirebase
//
//  Created by SEAN on 2018/8/15.
//  Copyright © 2018 com.sketchshare. All rights reserved.
//

import UIKit

class UserInfoView: UIView {
    
    var user: UserObject?{
        didSet{
            userNameLabel.text = user?.userBrief.nick_name.val as? String
            userEmailLabel.text = user?.userBrief.email.val as? String
        }
        
    }
    
    func updateUserInfo(){
        userNameLabel.text = user?.userBrief.nick_name.val as? String
        userEmailLabel.text = user?.userBrief.email.val as? String
    }
    
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Sean Lin"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userEmailLabel : UILabel = {
        let label = UILabel()
        label.text = "seanlin@gmail.com"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 40
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(userNameLabel)
        userNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        userNameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        
        addSubview(userEmailLabel)
        userEmailLabel.leftAnchor.constraint(equalTo: userNameLabel.leftAnchor).isActive = true
        userEmailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor).isActive = true
        userEmailLabel.rightAnchor.constraint(equalTo: userNameLabel.rightAnchor).isActive = true
        userEmailLabel.heightAnchor.constraint(equalTo: userNameLabel.heightAnchor).isActive = true
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
