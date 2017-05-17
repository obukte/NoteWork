//
//  User.swift
//  NoteWork
//
//  Copyright © 2017 Team Notework. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var email: String?
    var username: String?
    var profileImageUrl: String?
    
    override init () {
        
    }
    
    func pes() {
        print("\(email ?? "null"), \(name ?? "null"), \(profileImageUrl ?? "null"), \(username ?? "null")");
    }
}
