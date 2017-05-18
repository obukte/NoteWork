//
//  FeedVC.swift
//  NoteWork
//
//  Copyright © 2017 Team Notework. All rights reserved.
//

import UIKit

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var currentImage: UIImage?
    var source = AppDataSource()
    var chosenCourse: Course?
    var subNotes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(chosenCourse?.code ?? "Feed")"
        
        AppMaster.currentCourse = chosenCourse
        extractSubNotes()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func extractSubNotes() {
        subNotes = [];
        
        for note in AppMaster.notes {
            if note.courseCode == chosenCourse?.code {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewIdentifier", for: indexPath) as! FeedTableViewCell
        let note = subNotes.reversed()[indexPath.row]
        
        DispatchQueue.main.async {
            if AppMaster.sudo?.name == note.sender {
                cell.userIdentifier.textColor = UIColor.red
                cell.userIdentifier.text = "\(note.sender ?? "Default User") (me)"
            } else {
                cell.userIdentifier.text = "\(note.sender ?? "Default User")"
            }
            
            cell.noteImage.image = note.image
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FeedDescSeg" {
            let selectedCell = sender as! FeedTableViewCell
            let indexPath = self.tableView.indexPath(for: selectedCell)
            let controller = segue.destination as! NoteDescriptionVC
            
            controller.note = subNotes[subNotes.count - 1 - indexPath!.row]
        }
    }
}
