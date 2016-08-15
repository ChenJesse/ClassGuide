//
//  SymbolViewController.swift
//  ClassGuide
//
//  Created by Jesse Chen on 5/14/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit

class SymbolViewController: UIViewController {
    
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Symbol Guide"

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(10, 0, 20, 0)
        layout.headerReferenceSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 160)
        collectionView = UICollectionView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 64), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(UINib(nibName: "SymbolCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SymbolCell")
        collectionView.registerNib(UINib(nibName: "AboutHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView")
        collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20)
        self.automaticallyAdjustsScrollViewInsets = false
        collectionView.reloadData()
        self.view.addSubview(collectionView)
        addRevealVCButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        addPanGesture()
        normalizeNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SymbolViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return symbolNum
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SymbolCell", forIndexPath: indexPath) as! SymbolCollectionViewCell
        
        var symbolName: String!
        var description: String!
        switch indexPath.row {
        case 0:
            symbolName = "mandatoryIcon"
            description = "Requirement is mandatory"
        case 1:
            symbolName = "optionalIcon"
            description = "Requirement is optional"
        case 2:
            symbolName = "noHandIcon"
            description = "Requirement's fulfillment can't be toggled with a tap"
        case 3:
            symbolName = "handIcon"
            description = "Requirement's fulfillment can be toggled with a tap"
        case 4:
            symbolName = "checkIcon"
            description = "Course is marked as Taken"
        case 5:
            symbolName = "planIcon"
            description = "Course is marked as Plan to Take"
        case 6:
            symbolName = "questionmarkIcon"
            description = "Course is marked as None"
        case 7:
            symbolName = "fallIcon"
            description = "A fall semester"
        case 8:
            symbolName = "springIcon"
            description = "A spring semester"
        case 9:
            symbolName = "settingsIcon"
            description = "Settings, where you can toggle your vectors"
        case 10:
            symbolName = "majorsIcon"
            description = "Requirements, where you can see your progress towards completing the major and vectors"
        default:
            symbolName = "arrowIcon"
            description = "Means that there will be a dropdown if you tap the cell"
        }
        
        cell.descriptionLabel.text = description
        cell.symbolImageView.image = UIImage(named: symbolName)

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((UIScreen.mainScreen().bounds.width / 2 - 30), 160)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", forIndexPath: indexPath) as! AboutHeaderView
            return header
        }
        return UICollectionReusableView()
    }
}
