//
//  SignUpVC.swift
//  NoteWork
//
//  Copyright © 2017 Team Notework. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var repeatPassworddTxtField: UITextField!

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: LogInButtonView!
    
    var selectedImageFromPicker: UIImage?
    var scrollViewHeight : CGFloat = 0 // reset scroll view
    var keyboard = CGRect() // keyboard frame size
    
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
        selectedImageFromPicker = info[UIImagePickerControllerEditedImage] as? UIImage
        
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
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
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
        signUpButton.isHidden = true;
        cancelButton.isHidden = true;
        
        guard let email = emailTxtField.text, let password = passwordTxtField.text, let name = nameTxtField.text, let username = usernameTxtField.text else {
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.signUpButton.isHidden = false;
                self.cancelButton.isHidden = false;
                
                self.present(alert,animated: true, completion: nil)
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            // upload profile photo to storage
            let storageRef = FIRStorage.storage().reference().child("\(user?.uid ?? "null")-pp.png")
            
            if let uploadData = UIImagePNGRepresentation(self.userImg.image!){
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        return
                    }
                    
                    // metadata get url as string and put it in firebase
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": name, "username": username , "email": email, "pasword": password, "profileImageUrl": profileImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                    }
                })
            }
        })
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference(fromURL: "https://notework-b922a.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        
        let alert = UIAlertController(title: "Your account has been created successfully!", message: "Please check your email adress for verification of your account then sign in.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                return
            }
            
            FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: { (errr) in
                if errr != nil {
                    return
                }
            })
        })
    }
}
