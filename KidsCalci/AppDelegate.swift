//
//  AppDelegate.swift
//  KidsCalci
//
//  Created by Millipixels_021 on 01/08/18.
//  Copyright © 2018 Millipixels_021. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Firebase



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
     var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        UIApplication.shared.statusBarStyle = .lightContent
        IQKeyboardManager.shared.enable = true
        print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]

        KidsCalciUserDefaults.setDeviceType()
        KidsCalciUserDefaults.setDeviceDetail()
//      setAppNavigationBar()
        setStatusBar()
        configureRootViewController()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
          
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "KidsCalci")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
   
    
}


extension AppDelegate{

    func configureRootViewController() {
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
       
            guard let mainView = UIStoryboard(name: Screens.SideMenu.rawValue, bundle: nil).instantiateInitialViewController() as? CustomSideMenuViewController
                else{
                    return
            }
            UIApplication.shared.statusBarStyle = .lightContent
            newWindow.rootViewController = mainView
        
        newWindow.makeKeyAndVisible()
        newWindow.alpha = 0.0
        //UINavigationBar.appearance().transparentNavigationBar()
        
        /*let gradientLayer = CAGradientLayer()
        gradientLayer.frame = (UIApplication.shared.statusBarView?.bounds)!
        let color1 = UIColor.black.cgColor as CGColor
        let color2 = UIColor.black.cgColor as CGColor
        gradientLayer.colors = [ color1, color2]
        gradientLayer.opacity = 0.4
        //gradientLayer.locations = [0.20, 0.90]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
        UIApplication.shared.statusBarView?.layer.insertSublayer(gradientLayer, at: 0)
        */
        
        UIView.animate(withDuration: 0.33, animations: {
            newWindow.alpha = 1.0
            
        }, completion: { _ in
            self.window = newWindow
        })
    }
    
    
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

