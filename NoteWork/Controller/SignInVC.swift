//
//  ViewController.swift
//  NoteWork
//
//  Copyright © 2017 Team Notework. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignInVC: UIViewController {

    @IBOutlet weak var emailToUpContraint: NSLayoutConstraint!
    @IBOutlet weak var passwordToEmailConstraint: NSLayoutConstraint!
    @IBOutlet weak var signInBtnToPasswordConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var orLblToSignInConstrain: NSLayoutConstraint!
    @IBOutlet weak var usernameTextField: TextFieldView!
    @IBOutlet weak var passwordTextField: TextFieldView!
    
    @IBOutlet weak var signUpLabel: UILabel!
    
    private var source = AppDataSource()
    private var keyboard = CGRect() // keyboard frame size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        source.fetchData()
        
        // check notifications if keyboard is shown or not
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.showKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.hideKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // declare hide kyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.hideKeyboardTap(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
    }
    
    // hide keyboard if tapped
    func hideKeyboardTap(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func showKeyboard(_ notification:NSNotification){
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue)
        // move UP UI
        UIView.animate(withDuration: 0.4,animations: { () -> Void in
            self.emailToUpContraint.constant = 10
            self.passwordToEmailConstraint.constant = 5
            
        })
    }
    
    func hideKeyboard(_ notification: NSNotification){
        // move down UI
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.emailToUpContraint.constant = 40
            self.passwordToEmailConstraint.constant = 10
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        if (usernameTextField.text?.isEmpty == true){
            let alert = UIAlertController(title: "Error", message: "Please enter the username!", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert,animated: true, completion: nil)
            
            return
        }
        
        if (passwordTextField.text?.isEmpty == true){
            let alert = UIAlertController(title: "Error", message: "Please enter the password!", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert,animated: true, completion: nil)
            
            return
        }
        
        handleLogin()
        
    }
    
    func handleLogin() {
        guard let email = usernameTextField.text , let password = passwordTextField.text else {
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Check your email or password!", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            AppMaster.sudo = User(email: email)
            self.performSegue(withIdentifier: "GoToTabBar", sender: nil)
        })
    }
}

