//
//  User.swift
//  NoteWork
//
//  Copyright © 2017 Team Notework. All rights reserved.
//

import Foundation

class User {
    
    var name: String     = ""
    var email: String    = ""
    var username: String = ""
    var password: String = ""

    init(name: String, email: String, username: String, password: String) {
        self.name = name
        self.email = email
        self.username = username
        self.password = password
    }
}
