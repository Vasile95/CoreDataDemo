//
//  HumanStorage.swift
//  CoreDataDemoApp
//
//  Created by Vasile Vornic on 11/10/21.
//

import Foundation
import CoreData
import UIKit

protocol HumanStorage {
    @discardableResult
    func createHuman(name: String, age: Int, uuid: UUID?) -> Human
    func getHumans() -> [Human]
    func getHumanById(_ id: String) -> Human?
    func updateHuman(human: Human)
    func deleteHuman(id: String)
    func deleteAllHumans()
}

extension HumanStorage {
    @discardableResult
    func createHuman(name: String, age: Int, uuid: UUID?=UUID()) -> Human {
        createHuman(name: name, age: age, uuid: uuid)
    }
}

class HumanStorageImp: HumanStorage {

    private let context: NSManagedObjectContext
    private let coordinator: NSPersistentStoreCoordinator

    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            preconditionFailure()
        }
        context = appDelegate.persistentContainer.viewContext
        coordinator = appDelegate.persistentContainer.persistentStoreCoordinator
    }

    @discardableResult
    func createHuman(name: String, age: Int, uuid: UUID?=UUID()) -> Human {
        let humanEntity = HumanEntity(context: context)
        humanEntity.name = name
        humanEntity.age = Int32(age)
        humanEntity.userId = uuid

        try? context.save()
        return Human(name: name,
                     age: age,
                     id: humanEntity.objectID.uriRepresentation().absoluteString,
                     userId: uuid,
                     cars: [])
    }

    func getHumanById(_ id: String) -> Human? {
        guard let objectId = managedObjectID(fromStringId: id),
              let entity =  try? context.existingObject(with: objectId),
              let humanEntity = entity as? HumanEntity else {
            return nil
        }
        return Human(name: humanEntity.name,
                     age: Int(humanEntity.age),
                     id: id,
                     userId: humanEntity.userId,
                     cars: [])
    }

    private func managedObjectID(fromStringId id: String) -> NSManagedObjectID? {
        guard let objectIDURL = URL(string: id) else {
            return nil
        }
        return coordinator.managedObjectID(forURIRepresentation: objectIDURL)
    }

    func getHumans() -> [Human] {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = HumanEntity.fetchRequest() // NSFetchRequest(entityName: "HumanEntity")

        guard let humanEntities = try? context.fetch(fetchRequest) as? [HumanEntity] else {
            return []
        }

        return humanEntities.map { (humanEntity) -> Human in
            Human(name: humanEntity.name,
                  age: Int(humanEntity.age),
                  id: humanEntity.objectID.uriRepresentation().absoluteString,
                  userId: humanEntity.userId,
                  cars: [])
        }
    }

    func updateHuman(human: Human) {
        guard let objectId = managedObjectID(fromStringId: human.id),
              let entity =  try? context.existingObject(with: objectId),
              let humanEntity = entity as? HumanEntity else {
            return
        }
        humanEntity.name = human.name
        humanEntity.age = Int32(human.age)
        try? context.save()
    }

    func deleteHuman(id: String) {
        guard let objectId = managedObjectID(fromStringId: id),
              let entity =  try? context.existingObject(with: objectId) as? HumanEntity else {
            return
        }
        context.delete(entity)
        try? context.save()
    }

    func deleteAllHumans() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = HumanEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
           try coordinator.execute(deleteRequest, with: context)
        } catch let error as NSError {
            print(error)
        }
    }
}

