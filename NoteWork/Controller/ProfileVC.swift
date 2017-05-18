//
//  ProfileVC.swift
//  NoteWork
//
//  Copyright © 2017 Team Notework. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    var history : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.userFullName.isHidden == true {
            findSuperUser()
            
            self.userFullName.isHidden = false
            self.userEmail.isHidden = false
            self.userImage.isHidden = false
        }
        
        self.userFullName.text = AppMaster.sudo?.name;
        self.userEmail.text = AppMaster.sudo?.email;
        self.userImage.image = AppMaster.sudo?.image;
        
        // rounded user Image
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
        
        getHistory()
    }
    
    func getHistory() {
        for note in AppMaster.notes {
            history.append("Sent post for \(note.courseCode ?? "AA000")");
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func findSuperUser() {
        for user in AppMaster.users {
            if AppMaster.sudo?.email == user.email {
                AppMaster.sudo = user;
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewIdentifier", for: indexPath) as! ProfileTableViewCell
        let hist = history.reversed()[indexPath.row]
        
        DispatchQueue.main.async {
            cell.label.text = "\(hist ?? "null")"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
