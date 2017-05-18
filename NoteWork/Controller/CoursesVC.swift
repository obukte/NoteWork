//
//  BrowseVC.swift
//  NoteWork
//
//  Copyright © 2017 Team Notework. All rights reserved.
//

import UIKit

class CoursesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppMaster.courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoursesTableViewIdentifier", for: indexPath) as! CoursesTableViewCell
        let course = AppMaster.courses[indexPath.row]
        
        cell.courseLabel.text = "\(course.code ?? "AA000"): \(course.desc ?? "Default Course")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedCell = sender as! CoursesTableViewCell
        let indexPath = self.tableView.indexPath(for: selectedCell)
        let controller = segue.destination as! FeedVC
        
        controller.chosenCourse = AppMaster.courses[indexPath!.row]
    }
}
