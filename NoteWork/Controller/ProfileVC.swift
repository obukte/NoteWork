//
//  ProfileVC.swift
//  NoteWork
//
//  Copyright © 2017 Team Notework. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // rounded user Image
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
        
        fetchData()
    }
    
    private func fetchData() {
        let reference = FIRDatabase.database().reference(fromURL: "https://notework-b922a.firebaseio.com/")
        _ = reference.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() {
                return
            }
            
            let dictionary = snapshot.value as? NSDictionary;
            
            self.userFullName.isHidden = false;
            self.userEmail.isHidden = false;
            
            self.userFullName.text = (dictionary?["name"] as? String)!
            self.userEmail.text = (dictionary?["email"] as? String)!
            
            let profileImageUrl = (dictionary?["profileImageUrl"] as? String)!;
            
            FIRStorage.storage().reference(forURL: profileImageUrl).data(withMaxSize: 25 * 1024 * 1024, completion: { (data, error) -> Void in
                self.userImage.isHidden = false;
                self.userImage.image = UIImage(data: data!)!
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
