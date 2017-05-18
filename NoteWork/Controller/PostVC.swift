//
//  PostVC.swift
//  NoteWork
//
//  Copyright © 2017 Team Notework. All rights reserved.
//

import UIKit
import Firebase

class PostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var chosenImage: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // image picker starter
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(PostVC.loadImg(_:)))
        imageTap.numberOfTapsRequired = 1
        
        chosenImage.isUserInteractionEnabled = true
        chosenImage.addGestureRecognizer(imageTap)
    }
    
    func loadImg(_ recognizer: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        chosenImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func send(_ sender: Any) {
        sendButton.isHidden = true;
        
        let date = Date()
        let note = Note()
        
        note.id = "\(date)"
        note.sender = AppMaster.sudo?.name
        note.courseCode = AppMaster.currentCourse?.code
        note.image = chosenImage.image
        
        AppMaster.notes.append(note)
        
        // upload profile photo to storage
        let storageRef = FIRStorage.storage().reference().child("\(date).png")
        
        if let uploadData = UIImagePNGRepresentation(note.image!){
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                
                // metadata get url as string and put it in firebase
                if let noteImageUrl = metadata?.downloadURL()?.absoluteString {
                    let values = ["id": note.id, "sender": note.sender, "courseCode": note.courseCode, "noteImageUrl": noteImageUrl]
                    
                    let reference = FIRDatabase.database().reference(fromURL: "https://notework-b922a.firebaseio.com/")
                    let usersReference = reference.child("notes").child("\(date)")
                    
                    usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if err != nil {
                            return
                        }
                    })
                }
            })
        }
        
        sendButton.isHidden = false;
        _ = navigationController?.popToRootViewController(animated: true)
    }
}

