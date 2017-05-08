//
//  SignUpVC.swift
//  NoteWork
//
//  Created by OMER BUKTE on 5/8/17.
//  Copyright © 2017 Omer Bukte. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var usernameTxtField: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var repeatPassworddTxtField: UITextField!
    @IBOutlet weak var nameTxtField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // reset scroll view
    var scrollViewHeight : CGFloat = 0
    
    //keyboard frame size
    var keyboard = CGRect()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // scrollview frame size
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        
        // check notifications if keyboard is shown or not
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.showKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.hideKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // declare hide kyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.hideKeyboardTap(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //image picker starter
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.loadImg(_:)))
        imgTap.numberOfTapsRequired = 1
        userImg.isUserInteractionEnabled = true
        userImg.addGestureRecognizer(imgTap)
        
        //rounded userImage
        userImg.layer.cornerRadius = userImg.frame.size.width/2
        userImg.clipsToBounds = true
    }
    
    func loadImg(_ recognizer: UITapGestureRecognizer) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        userImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    // hide keyboard if tapped
    func hideKeyboardTap(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
        
    }
    
    func showKeyboard(_ notification:NSNotification){
        
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue)
        
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        })
    }
    
    func hideKeyboard(_ notification: NSNotification){
        
        // move down UI
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.scrollView.frame.size.height = self.view.frame.height
        })
    }
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        
        if passwordTxtField.text != repeatPassworddTxtField.text {
            let alert = UIAlertController(title: "Error", message: "Passwords should match!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert,animated: true, completion: nil)
            return
        }
        
        if (usernameTxtField.text?.isEmpty == true){
            let alert = UIAlertController(title: "Error", message: "Please fill the username field!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert,animated: true, completion: nil)
            return
        }
        if (nameTxtField.text?.isEmpty == true){
            let alert = UIAlertController(title: "Error", message: "Please fill the name field!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert,animated: true, completion: nil)
            return
        }
        
        if (passwordTxtField.text?.isEmpty == true){
            let alert = UIAlertController(title: "Error", message: "Please fill the password field!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert,animated: true, completion: nil)
            return
        }
        
        handleRegister()
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleRegister() {
        
        guard let email = emailTxtField.text, let password = passwordTxtField.text, let name = nameTxtField.text, let username = usernameTxtField.text else {
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Either this email is already been taken or you did not entered a valid email.Please Check", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert,animated: true, completion: nil)
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let ref = FIRDatabase.database().reference(fromURL: "https://notework-b922a.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "username": username , "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    return
                }
                
                FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: { (errr) in
                    
                    if errr != nil {
                        return
                    }
                    
                    let alert = UIAlertController(title: "Your account has been created successfully!", message: "Please check your email adress for verification of your account then sign in.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert,animated: true, completion: nil)
                    
                })
            })
            
        })
    }

}
