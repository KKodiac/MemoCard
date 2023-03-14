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
    
    lazy var persistentContainer: NSPersistentContainer = {
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.seanhong2000.KKodiac.Memo")!
        let storeURL = containerURL.appendingPathComponent("CorePersistence.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)
        
        let container = NSPersistentContainer(name: "CorePersistence")
        container.persistentStoreDescriptions = [description]
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
    
    func insertData(_ card: CardModel) {
        let context = persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: "Card", in: context) {
            let object = NSManagedObject(entity: entity, insertInto: context)
            object.setValue(card.name, forKey: "name")
            object.setValue(card.title, forKey: "title")
            object.setValue(card.subtitle, forKey: "subtitle")
            object.setValue(card.company, forKey: "company")
            object.setValue(card.phone, forKey: "phone")
            object.setValue(card.email, forKey: "email")
            object.setValue(card.address, forKey: "address")
            object.setValue(card.imageURL, forKey: "imageURL")
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error saving new card. \(error.localizedDescription)")
        }
    }
    
    func fetchCards() -> [CardModel] {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        
        do {
            let object = try context.fetch(request)
            let cards = object.map{ CardModel(card: $0) }
            return cards
        } catch let error as NSError {
            print("Error fetching cards. \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchCard(_ index: Int) -> CardModel {
        let cards = self.fetchCards()
        let card = cards[index]
        return card
    }
}
