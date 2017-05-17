//
//  AppDataSource.swift
//  NoteWork
//
//  Copyright © 2017 Team Notework. All rights reserved.
//

import Firebase

@objc protocol AppDataDelegate {
    @objc optional func fun1()
    @objc optional func fun2()
}

class AppDataSource {
    
    var delegate: AppDataDelegate?
    
    func fetchData() {
        fetchUsers()
        fetchNotes()
    }
    
    func fetchUsers() {
        FIRDatabase.database().reference(fromURL: "https://notework-b922a.firebaseio.com/").child("users").observe(.childAdded, with: { (snapshot) -> Void in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.username = dictionary["username"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                
                AppMaster.users.append(user)
            }
        })
    }
    
    func fetchNotes() {
        FIRDatabase.database().reference(fromURL: "https://notework-b922a.firebaseio.com/").child("notes").observe(.childAdded, with: { (snapshot) -> Void in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let note = Note()
                
                note.courseCode = dictionary["courseCode"] as? String
                note.courseName = dictionary["courseName"] as? String
                note.noteWritten = dictionary["noteWritten"] as? String
                note.noteImageUrl = dictionary["noteImageUrl"] as? String
                
                AppMaster.notes.append(note)
            }
        })
    }
}
