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
}