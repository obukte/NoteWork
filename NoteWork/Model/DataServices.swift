//
//  DataServices.swift
//  NoteWork
//
//  Copyright © 2017 Team Notework. All rights reserved.
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
