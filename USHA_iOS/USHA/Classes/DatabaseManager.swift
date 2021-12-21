//
//  DatabaseManager.swift
//  Nuggets
//
//  Created by Sarita Katakwar on 21/05/18.
//  Copyright © 2018 Digicita. All rights reserved.
//

import Foundation
import CoreData


final class DatabaseManager {
    //use abstraction
    // now open taht file
    
    private init(){}
    static let sharedInstance = DatabaseManager()
    
    var context: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    
    var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ProductModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError?
            {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
          -       */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext ()
    {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("SAVED User Data")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func clearDatabase( entity:String )
    {
        let context = self.context
        let coord = self.persistentContainer.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity )
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.execute(deleteRequest, with: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    func fetch<T: NSManagedObject>(objectType:T.Type, predicate: NSPredicate?, sortDescriptor : NSSortDescriptor? = nil)->[T] {
        let entityName = String.init(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: entityName)
        if let predicate  = predicate {
            fetchRequest.predicate = predicate
        }
        if let sortDesc = sortDescriptor {
            fetchRequest.sortDescriptors = [sortDesc]
        }
        do {
            let fetchObjects = try context.fetch(fetchRequest) as? [T]
            return fetchObjects ?? [T]()
        } catch(let err){
            print("FETCH ERROR: \(err.localizedDescription)")
            return [T]()
        }
    }
    
    //MARK:- Fetch Data From Core Data
    //MARK:-
    func fetchData(_ modelName: String, predicate:String? = nil, sort:[(sortKey:String?,isAscending:Bool)]? = nil, inManagedContext: NSManagedObjectContext? = DatabaseManager.sharedInstance.context) -> [Any]? {
        
        let cdhObj = inManagedContext!
        
        let fReq: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        
        //set predicate
        if let prdStr = predicate {
            fReq.predicate = NSPredicate(format:prdStr)
        }
        
        //set sort descripter
        if let sortDict = sort {
            var sorterArr = [NSSortDescriptor]()
            for shortValue in sortDict {
                //Check whether sorting is to be applied
                if let sortKey = shortValue.sortKey {
                    let sorter: NSSortDescriptor = NSSortDescriptor(key: sortKey , ascending: shortValue.isAscending)
                    sorterArr.append(sorter)
                }
            }
            if sorterArr.count > 0{
                fReq.sortDescriptors = sorterArr
            }
        }
        fReq.returnsObjectsAsFaults = false
        
        
        //final fetch data
        do {
            let result = try cdhObj.fetch(fReq)
            return result
        }
        catch let error {
            print("Problem in fetching data from core data is: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    func deleteData(_ modelName: String, predicate: String?)-> Bool {
        if let result = self.fetchData(modelName, predicate: predicate) {
            for resultItem in result {
                let finalItem: AnyObject = resultItem as AnyObject
                self.context.delete(finalItem as! NSManagedObject)
            }
            self.saveContext()
            return true
        }
        return false
    }
    

    
}
