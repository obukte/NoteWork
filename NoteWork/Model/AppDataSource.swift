//
//  AppDataSource.swift
//  NoteWork
//
//  Copyright © 2017 Team Notework. All rights reserved.
//

import Firebase

class AppDataSource {
    
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
                
                FIRStorage.storage().reference(forURL: (dictionary["profileImageUrl"] as? String)!).data(withMaxSize: 25 * 1024 * 1024, completion: { (data, error) -> Void in
                    user.image = UIImage(data: data!)!
                })
                
                AppMaster.users.append(user)
            }
        })
    }
    
    func fetchNotes() {
        FIRDatabase.database().reference(fromURL: "https://notework-b922a.firebaseio.com/").child("notes").observe(.childAdded, with: { (snapshot) -> Void in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let note = Note()
                
                note.id = dictionary["id"] as? String
                note.sender = dictionary["sender"] as? String
                note.courseCode = dictionary["courseCode"] as? String
                
                FIRStorage.storage().reference(forURL: (dictionary["noteImageUrl"] as? String)!).data(withMaxSize: 25 * 1024 * 1024, completion: { (data, error) -> Void in
                    note.image = UIImage(data: data!)!
                })
                
                if self.doesItemExist(note: note) == false {
                    AppMaster.notes.append(note)
                }
            }
        })
    }
    
    func doesItemExist(note: Note) -> Bool {
        for subNote in AppMaster.notes {
            if subNote.id == note.id {
                return true;
            }
        }
        
        return false;
    }
}
