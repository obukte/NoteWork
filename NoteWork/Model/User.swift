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
    var image: UIImage?
    
    override init() {
        
    }
    
    init (email: String) {
        self.email = email;
    }
}
