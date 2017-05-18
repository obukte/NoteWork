//
//  SearchCourseVC.swift
//  NoteWork
//
//  Copyright © 2017 Team Notework. All rights reserved.
//

import UIKit

class SearchCourseVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    var courses: [Course] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func search(_ sender: Any) {
        let prev = courses.count
        
        for course in AppMaster.courses {
            if course.code == textField.text {
                courses.append(course)
            }
        }
        
        let next = courses.count
        
        if prev == next {
            let alert = UIAlertController(title: "Error", message: "There is no such course.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsTableViewIdentifier", for: indexPath) as! SearchCourseTableViewCell
        let course = courses.reversed()[indexPath.row]
        
        DispatchQueue.main.async {
            cell.courseIdentifier.text = "\(course.code ?? "AA000"): \(course.desc ?? "Default Course")"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToFeedSeg" {
            let selectedCell = sender as! SearchCourseTableViewCell
            let indexPath = self.tableView.indexPath(for: selectedCell)
            let controller = segue.destination as! FeedVC
            
            controller.chosenCourse = courses[courses.count - 1 - indexPath!.row]
        }
    }
}

