//
//  AppMaster.swift
//  NoteWork
//
//  Copyright © 2017 Team Notework. All rights reserved.
//

struct AppMaster {
    static var sudo: User?
    static var currentCourse: Course?
    static var users: [User] = []
    static var notes: [Note] = []
    static let courses: [Course] = [Course(code: "CS101" , desc: "Computer Programming"),
                                    Course(code: "CS102" , desc: "Object-Oriented Programming"),
                                    Course(code: "CS201" , desc: "Data Structures and Algorithms"),
                                    Course(code: "CS202" , desc: "Database Management Systems"),
                                    Course(code: "CS320" , desc: "Software Engineering"),
                                    Course(code: "CS321" , desc: "Programming Languages"),
                                    Course(code: "CS333" , desc: "Analysis of Algorithms"),
                                    Course(code: "CS350" , desc: "Operating Systems")]
}

