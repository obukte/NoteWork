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
    var subNotes: [Note] = []
    
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
        
        extractSubNotes()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func findSuperUser() {
        for user in AppMaster.users {
            if AppMaster.sudo?.email == user.email {
                AppMaster.sudo = user
            }
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        extractSubNotes()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func extractSubNotes() {
        subNotes = [];
        
        for note in AppMaster.notes {
            if note.sender == AppMaster.sudo?.name {
                subNotes.append(note)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewIdentifier", for: indexPath) as! ProfileTableViewCell
        let note = subNotes.reversed()[indexPath.row]
        
        DispatchQueue.main.async {
            cell.courseIdentifier.text = "Post for \(note.courseCode ?? "AA000")"
            cell.noteImage.image = note.image
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileFeedDescSeg" {
            let selectedCell = sender as! ProfileTableViewCell
            let indexPath = self.tableView.indexPath(for: selectedCell)
            let controller = segue.destination as! NoteDescriptionVC
            
            controller.note = subNotes[subNotes.count - 1 - indexPath!.row]
        }
    }
}
