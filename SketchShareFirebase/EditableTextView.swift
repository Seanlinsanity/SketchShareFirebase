//
//  EditableTextView.swift
//  SketchShareFirebase
//
//  Created by SEAN on 2018/8/8.
//  Copyright © 2018 com.sketchshare. All rights reserved.
//

import UIKit
import RxSwift

class EditableTextView: UIView {
    

//    private let textVariable = Variable("user")
//    var textObservable: Observable<String> {
//        return textVariable.asObservable()
//    }
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.backgroundColor = .lightGray
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let editCompletionButton: UIButton = {
        let editBtn = UIButton(type: .system)
        editBtn.translatesAutoresizingMaskIntoConstraints = false
        editBtn.setTitle("編輯", for: .normal)
        editBtn.setTitleColor(.black, for: .normal)
        editBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        editBtn.addTarget(self, action: #selector(handleEditCompletion), for: .touchUpInside)
        return editBtn
    }()
    
    @objc private func handleEditCompletion(){
        
        if editCompletionButton.titleLabel?.text == "編輯" {
            editCompletionButton.setTitle("完成", for: .normal)
            textView.isEditable = true
            textView.becomeFirstResponder()
        }else{
            editCompletionButton.setTitle("編輯", for: .normal)
            textView.isEditable = false
            textView.endEditing(true)
//            guard let text = textView.text else { return }
//            textVariable.value = text
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        textView.text = textVariable.value
        addSubview(textView)
        textView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        
        addSubview(editCompletionButton)
        editCompletionButton.leftAnchor.constraint(equalTo: textView.rightAnchor, constant: 8).isActive = true
        editCompletionButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        editCompletionButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        editCompletionButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
