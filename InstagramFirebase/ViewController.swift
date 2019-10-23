//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Aaron Xue on 2019/10/13.
//  Copyright © 2019 Aaron Xue. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

final class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    lazy var plusPhotoButton: UIButton = {
        let button = UIButton(type: .custom)
        let plusphoto = UIImage(named: "plus--v2")
        button.setImage(plusphoto?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()

    @objc func handlePlusPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let originalImage = info["UIImagePickControllerOriginalImage"] as? UIImage
        
    }
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()

    @objc func handleTextInputChange(){
        let isFormVaild = emailTextField.text?.count ?? 0 > 0 &&
                          usernameTextField.text?.count ?? 0 > 0 &&
                          passwordTextField.text?.count ?? 0 > 0
        
        if isFormVaild {
            singUpButton.isEnabled = true
            singUpButton.backgroundColor = UIColor.rgb(red: 51, green: 153, blue: 244)
        }else{
            singUpButton.isEnabled = false
            singUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()

    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()

    lazy var singUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sing Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if let err = error{
                self.signupResult = "Make sure the format is correct"
                print("Failed to create user: \(err)")
                return
            }
            print("Successfully created user: ", user?.user.uid ?? "")
            guard let uid = user?.user.uid else { return }
            
            let usernameValues = ["username": username]
            let values = [uid: usernameValues]
            
            Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err{
                    print("Failed to save user info into DB \(err)")
                    self.signupResult = "Make sure the format is correct"
                    return
                }
                print("Successfully saved user info")
                self.signupResult = "Hello \(username)"
            })
        })
    }
    
    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        return label
    }()
    
    var signupResult = "" {
        didSet {
            resultLabel.text = "\(signupResult)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(plusPhotoButton)

        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputField()
        
    }
    
    
    fileprivate func setupInputField(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField,usernameTextField,passwordTextField,singUpButton,resultLabel])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor,
                         bottom: nil, right: view.rightAnchor,
                         paddingTop: 20, paddingLeft: 40,
                         paddingBottom: 0, paddingRight: -40, width: 0, height: 200 )
    }

}


extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,
                paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat , paddingRight: CGFloat,width: CGFloat, height: CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self .topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left{
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom{
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let right = right{
            self.rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        
        if width != 0{
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0{
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
