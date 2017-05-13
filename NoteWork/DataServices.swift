//
//  DataServices.swift
//  NoteWork
//
//  Created by OMER BUKTE on 5/8/17.
//  Copyright © 2017 Omer Bukte. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import KeychainSwift

let DB_BASE = FIRDatabase.database().reference()

class DataService{
    private var _keychain = KeychainSwift()
    private var _refDatabase = DB_BASE
    
    var keyChain: KeychainSwift {
        get {
            return _keychain
        }
        set {
            _keychain = newValue
        }
        
    }
    
}
