//
//  SettingsVC.swift
//  NoteWork
//
//  Copyright © 2017 Team Notework. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    
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
        
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(imgTap)
        
        //rounded userImage
        userImage.layer.cornerRadius = userImage.frame.size.width/2
        userImage.clipsToBounds = true
        
        self.view.updateConstraints()
    }

    func loadImg(_ recognizer: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        userImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //IMPLEMENT SAVE BUTTON TAPPED
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
    //IMPLEMENT LOG OUT BUTTON TAPPED
    @IBAction func logOutButtonTapped(_ sender: Any) {
        
    }
}
