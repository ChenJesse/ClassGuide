//
//  CourseSearchableDelegate.swift
//  ClassGuide
//
//  Created by Jesse Chen on 4/3/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import Foundation

protocol CourseSearchDelegate: UISearchBarDelegate {
    var controller: UITableViewController! { get }
    var searchQuery: String { get set }
    var searchBar: UISearchBar! { get set }
    var desiredCourses: [Course] { get set }
    func processCourses()
}

extension CourseSearchDelegate {
    func setupSearchBar() {
        searchBar = UISearchBar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 30))
        searchBar.searchBarStyle = .Minimal
        searchBar.tintColor = UIColor.cornellRed
        let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.cornellRed
        searchBar.delegate = self as CourseSearchDelegate
        controller.tableView.tableHeaderView = searchBar
    }
    
    func handleSearchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("text changed")
        searchQuery = searchText
        processCourses()
        controller.tableView.reloadData()
    }
    
    func handleSearchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func handleSearchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchQuery = ""
        processCourses()
        controller.tableView.reloadData()
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func filterCourses() {
        if searchQuery != "" {
            desiredCourses = desiredCourses.filter({ (c) -> Bool in
                let options: NSStringCompareOptions = [.CaseInsensitiveSearch, .DiacriticInsensitiveSearch]
                let courseNumberFound: () -> Bool = {
                    return "\(c.courseNumber)".rangeOfString(self.searchQuery, options: options) != nil
                }
                let titleFound: () -> Bool = {
                    return c.titleLong.rangeOfString(self.searchQuery, options: options) != nil
                }
                let instructorFound: () -> Bool = {
                    return c.instructors.rangeOfString(self.searchQuery, options: options) != nil
                }
                let descriptionFound: () -> Bool = {
                    return c.description.rangeOfString(self.searchQuery, options: options) != nil
                }
                return (courseNumberFound() || titleFound() || instructorFound() || descriptionFound())
            })
        }
    }
}