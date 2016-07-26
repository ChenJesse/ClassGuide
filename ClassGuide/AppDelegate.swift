//
//  AppDelegate.swift
//  ClassGuide
//
//  Created by Jesse Chen on 3/22/16.
//  Copyright © 2016 Jesse Chen. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SWRevealViewControllerDelegate {

    var window: UIWindow?
    let navigationController = UINavigationController()
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let revealVC = SWRevealViewController()
    let sidebarVC = SidebarTableViewController()
    let homeVC = HomeTableViewController()
    let manageVC = ManageTableViewController()
    let requirementsVC = RequirementsTableViewController()
    let settingsVC = SettingsTableViewController()
    let infoVC = SymbolViewController()
    
    let majorReqs = CSRequirements()
    let AIVector = AI()
    let renaissanceVector = Renaissance()
    let CSEVector = CSE()
    let graphicsVector = Graphics()
    let NSVector = NS()
    let PLVector = PL()
    let SEVector = SE()
    let SDVector = SD()
    let theoryVector = Theory()
    
    var settings: [String: Bool] = [:]
    var CSToggled: Bool!
    var AIToggled: Bool!
    var renaissanceToggled: Bool!
    var CSEToggled: Bool!
    var graphicsToggled: Bool!
    var NSToggled: Bool!
    var PLToggled: Bool!
    var SEToggled: Bool!
    var SDToggled: Bool!
    var theoryToggled: Bool!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        navigationController.navigationBarHidden = false
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barStyle = .Black
        appDelegate = self
        managedContext = appDelegate.managedObjectContext
        settingsSetup()
        viewControllerSetup()
        revealVCSetup()
        
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        homeVC.saveCoreData()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        homeVC.saveCoreData()
    }
    
    //Manages the references between the ViewControllers
    func viewControllerSetup() {
        homeVC.managedContext = managedContext
        homeVC.defaults = defaults
        
        manageVC.managedContext = managedContext
        
        sidebarVC.revealVC = revealVC
        sidebarVC.homeVC = homeVC
        sidebarVC.manageVC = manageVC
        sidebarVC.requirementsVC = requirementsVC
        sidebarVC.settingsVC = settingsVC
        sidebarVC.infoVC = infoVC
        sidebarVC.navController = navigationController
        
        let reqsAndTogglesAndKeys: [(Requirement, Bool, SettingsKey)] = [
            (majorReqs, CSToggled, .CS),
            (AIVector, AIToggled, .AI),
            (renaissanceVector, renaissanceToggled, .Renaissance),
            (CSEVector, CSEToggled, .CSE),
            (graphicsVector, graphicsToggled, .Graphics),
            (NSVector, NSToggled, .NS),
            (PLVector, PLToggled, .PL),
            (SEVector, SEToggled, .SE),
            (SDVector, SDToggled, .SD),
            (theoryVector, theoryToggled, .Theory)]
        
        requirementsVC.sidebarVC = sidebarVC
        requirementsVC.settingsVC = settingsVC
        requirementsVC.reqsAndTogglesAndKeys = reqsAndTogglesAndKeys
        requirementsVC.defaults = defaults
        
        settingsVC.sidebarVC = sidebarVC
        settingsVC.requirementsVC = requirementsVC
        settingsVC.reqsAndTogglesAndKeys = reqsAndTogglesAndKeys
        settingsVC.settings = settings
        settingsVC.defaults = defaults
    }
    
    func revealVCSetup() {
        navigationController.setViewControllers([homeVC], animated: false)
        revealVC.setFrontViewController(navigationController, animated: false)
        revealVC.setRearViewController(sidebarVC, animated: true)
        window?.rootViewController = revealVC
    }
    
    func settingsSetup() {
        CSToggled = defaults.objectForKey(SettingsKey.CS.rawValue) as? Bool ?? true
        AIToggled = defaults.objectForKey(SettingsKey.AI.rawValue) as? Bool ?? true
        renaissanceToggled = defaults.objectForKey(SettingsKey.Renaissance.rawValue) as? Bool ?? true
        CSEToggled = defaults.objectForKey(SettingsKey.CSE.rawValue) as? Bool ?? true
        graphicsToggled = defaults.objectForKey(SettingsKey.Graphics.rawValue) as? Bool ?? true
        NSToggled = defaults.objectForKey(SettingsKey.NS.rawValue) as? Bool ?? true
        PLToggled = defaults.objectForKey(SettingsKey.PL.rawValue) as? Bool ?? true
        SEToggled = defaults.objectForKey(SettingsKey.SE.rawValue) as? Bool ?? true
        SDToggled = defaults.objectForKey(SettingsKey.SD.rawValue) as? Bool ?? true
        theoryToggled = defaults.objectForKey(SettingsKey.Theory.rawValue) as? Bool ?? true
        settings[SettingsKey.CS.rawValue] = CSToggled
        settings[SettingsKey.AI.rawValue] = AIToggled
        settings[SettingsKey.Renaissance.rawValue] = renaissanceToggled
        settings[SettingsKey.CSE.rawValue] = CSEToggled
        settings[SettingsKey.Graphics.rawValue] = graphicsToggled
        settings[SettingsKey.NS.rawValue] = NSToggled
        settings[SettingsKey.PL.rawValue] = PLToggled
        settings[SettingsKey.SE.rawValue] = SEToggled
        settings[SettingsKey.SD.rawValue] = SDToggled
        settings[SettingsKey.Theory.rawValue] = theoryToggled
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.jessechen.CoreDataSample" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}