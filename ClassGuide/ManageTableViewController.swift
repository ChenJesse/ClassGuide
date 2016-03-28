//
//  ManageTableViewController.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/25/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit

class ManageTableViewController: UITableViewController {
    
    var relevantCourses: [Course] = []
    var takenCourses: NSMutableSet!
    var plannedCourses: NSMutableSet!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        relevantCourses.appendContentsOf(takenCourses.allObjects as! [Course])
        relevantCourses.appendContentsOf(plannedCourses.allObjects as! [Course])
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2 //one for taken classes, another for planend classes
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func processCourses() {
        
    }
}
