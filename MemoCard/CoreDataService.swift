//
//  CoreDataService.swift
//  MemoCard
//
//  Created by Sean Hong on 2023/03/01.
//

import CoreData

class CoreDataService {
    static let shared = CoreDataService()

    private init() {}

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CorePersistence")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application, although it may be useful during development.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = managedObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func insertData(card: CardModel) {
        let context = persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "Card", in: context) {
            let object = NSManagedObject(entity: entity, insertInto: context)
            object.setValue(card.name, forKey: "name")
        }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error saving new card. \(error.localizedDescription)")
        }
    }
    
    func fetchData() -> [Card] {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        
        do {
            let object = try context.fetch(request)
            return object
        } catch let error as NSError {
            print("Error fetching cards. \(error.localizedDescription)")
            return []
        }
    }
}
