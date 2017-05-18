//
//  Course.swift
//  NoteWork
//
//  Copyright © 2017 Team Notework. All rights reserved.
//

import UIKit

class Course: NSObject {
    
    var code: String?
    var desc: String?
    
    init (code: String, desc: String) {
        self.code = code;
        self.desc = desc;
    }
}

