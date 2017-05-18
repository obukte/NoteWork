//
//  NoteDescriptionVC.swift
//  NoteWork
//
//  Copyright © 2017 Team Notework. All rights reserved.
//

import UIKit

class NoteDescriptionVC: UIViewController {
    
    var note: Note?
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(note?.sender ?? "null")"
        image.image = note?.image;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func save(_ sender: Any) {
        let imageData = UIImageJPEGRepresentation(image.image!, 0.6)
        let compressedJPGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved!", message: "Your image has been saved to Photo Library.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        _ = navigationController?.popViewController(animated: true)
    }
}
