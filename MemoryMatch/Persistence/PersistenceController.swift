//
//  PersistenceController.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import CoreData
import Foundation

public final class PersistenceController {
    public static let shared = PersistenceController()
    
    public static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        
        // Seed default players for SwiftUI previews
        let maya = PlayerProfileEntity(context: context)
        maya.id = PlayerProfile.defaultPlayerOne.id
        maya.name = PlayerProfile.defaultPlayerOne.name
        maya.createdAt = Date()
        maya.updatedAt = Date()
        
        let leo = PlayerProfileEntity(context: context)
        leo.id = PlayerProfile.defaultPlayerTwo.id
        leo.name = PlayerProfile.defaultPlayerTwo.name
        leo.createdAt = Date()
        leo.updatedAt = Date()
        
        try? context.save()
        return controller
    }()
    
    public let container: NSPersistentContainer
    
    public var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    public init(inMemory: Bool = false) {
        // Find or create managed object model
        let model: NSManagedObjectModel
        if let modelURL = Bundle.main.url(forResource: "MemoryMatch", withExtension: "momd"),
           let managedModel = NSManagedObjectModel(contentsOf: modelURL) {
            model = managedModel
        } else {
            // Programmatic model fallback for unit tests and direct execution
            model = PersistenceController.createManagedObjectModel()
        }
        
        container = NSPersistentContainer(name: "MemoryMatch", managedObjectModel: model)
        
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
        } else {
            // tvOS recommended storage: Application Support directory within app sandbox
            if let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
                try? FileManager.default.createDirectory(at: appSupportURL, withIntermediateDirectories: true)
                let storeURL = appSupportURL.appendingPathComponent("MemoryMatch.sqlite")
                let description = NSPersistentStoreDescription(url: storeURL)
                container.persistentStoreDescriptions = [description]
            }
        }
        
        container.loadPersistentStores { [container] description, error in
            if let error = error {
                #if DEBUG
                print("Core Data store failed to load: \(error.localizedDescription). Falling back to in-memory store.")
                #endif
                // Resilient fallback for tvOS if storage fails or is purged
                let inMemoryDescription = NSPersistentStoreDescription()
                inMemoryDescription.url = URL(fileURLWithPath: "/dev/null")
                container.persistentStoreDescriptions = [inMemoryDescription]
                container.loadPersistentStores { _, _ in }
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    public static func createInMemoryController() -> PersistenceController {
        PersistenceController(inMemory: true)
    }
    
    public func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    // MARK: - Programmatic Model Definition
    public static func createManagedObjectModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        
        // PlayerProfileEntity
        let playerEntity = NSEntityDescription()
        playerEntity.name = "PlayerProfileEntity"
        playerEntity.managedObjectClassName = NSStringFromClass(PlayerProfileEntity.self)
        
        let pId = NSAttributeDescription()
        pId.name = "id"
        pId.attributeType = .UUIDAttributeType
        pId.isOptional = false
        
        let pName = NSAttributeDescription()
        pName.name = "name"
        pName.attributeType = .stringAttributeType
        pName.isOptional = false
        
        let pCreatedAt = NSAttributeDescription()
        pCreatedAt.name = "createdAt"
        pCreatedAt.attributeType = .dateAttributeType
        pCreatedAt.isOptional = false
        
        let pUpdatedAt = NSAttributeDescription()
        pUpdatedAt.name = "updatedAt"
        pUpdatedAt.attributeType = .dateAttributeType
        pUpdatedAt.isOptional = false
        
        // GameRoundEntity
        let roundEntity = NSEntityDescription()
        roundEntity.name = "GameRoundEntity"
        roundEntity.managedObjectClassName = NSStringFromClass(GameRoundEntity.self)
        
        let rId = NSAttributeDescription()
        rId.name = "id"
        rId.attributeType = .UUIDAttributeType
        rId.isOptional = false
        
        let rDate = NSAttributeDescription()
        rDate.name = "date"
        rDate.attributeType = .dateAttributeType
        rDate.isOptional = false
        
        let rGameMode = NSAttributeDescription()
        rGameMode.name = "gameMode"
        rGameMode.attributeType = .stringAttributeType
        rGameMode.isOptional = false
        
        let rPairCount = NSAttributeDescription()
        rPairCount.name = "pairCount"
        rPairCount.attributeType = .integer16AttributeType
        rPairCount.isOptional = false
        rPairCount.defaultValue = 6
        
        let rPlayerOneScore = NSAttributeDescription()
        rPlayerOneScore.name = "playerOneScore"
        rPlayerOneScore.attributeType = .integer16AttributeType
        rPlayerOneScore.isOptional = false
        rPlayerOneScore.defaultValue = 0
        
        let rPlayerTwoScore = NSAttributeDescription()
        rPlayerTwoScore.name = "playerTwoScore"
        rPlayerTwoScore.attributeType = .integer16AttributeType
        rPlayerTwoScore.isOptional = false
        rPlayerTwoScore.defaultValue = 0
        
        let rPlayerOneId = NSAttributeDescription()
        rPlayerOneId.name = "playerOneId"
        rPlayerOneId.attributeType = .UUIDAttributeType
        rPlayerOneId.isOptional = true
        
        let rPlayerTwoId = NSAttributeDescription()
        rPlayerTwoId.name = "playerTwoId"
        rPlayerTwoId.attributeType = .UUIDAttributeType
        rPlayerTwoId.isOptional = true
        
        let rPlayerOneSnapshot = NSAttributeDescription()
        rPlayerOneSnapshot.name = "playerOneNameSnapshot"
        rPlayerOneSnapshot.attributeType = .stringAttributeType
        rPlayerOneSnapshot.isOptional = false
        rPlayerOneSnapshot.defaultValue = "Player 1"
        
        let rPlayerTwoSnapshot = NSAttributeDescription()
        rPlayerTwoSnapshot.name = "playerTwoNameSnapshot"
        rPlayerTwoSnapshot.attributeType = .stringAttributeType
        rPlayerTwoSnapshot.isOptional = false
        rPlayerTwoSnapshot.defaultValue = "Player 2"
        
        let rWinnerId = NSAttributeDescription()
        rWinnerId.name = "winnerId"
        rWinnerId.attributeType = .UUIDAttributeType
        rWinnerId.isOptional = true
        
        // Relationships
        let relPlayerOne = NSRelationshipDescription()
        relPlayerOne.name = "playerOne"
        relPlayerOne.destinationEntity = playerEntity
        relPlayerOne.minCount = 0
        relPlayerOne.maxCount = 1
        relPlayerOne.deleteRule = .nullifyDeleteRule
        
        let relPlayerTwo = NSRelationshipDescription()
        relPlayerTwo.name = "playerTwo"
        relPlayerTwo.destinationEntity = playerEntity
        relPlayerTwo.minCount = 0
        relPlayerTwo.maxCount = 1
        relPlayerTwo.deleteRule = .nullifyDeleteRule
        
        let relRoundsAsPlayerOne = NSRelationshipDescription()
        relRoundsAsPlayerOne.name = "roundsAsPlayerOne"
        relRoundsAsPlayerOne.destinationEntity = roundEntity
        relRoundsAsPlayerOne.minCount = 0
        relRoundsAsPlayerOne.maxCount = 0 // to-many
        relRoundsAsPlayerOne.deleteRule = .nullifyDeleteRule
        
        let relRoundsAsPlayerTwo = NSRelationshipDescription()
        relRoundsAsPlayerTwo.name = "roundsAsPlayerTwo"
        relRoundsAsPlayerTwo.destinationEntity = roundEntity
        relRoundsAsPlayerTwo.minCount = 0
        relRoundsAsPlayerTwo.maxCount = 0 // to-many
        relRoundsAsPlayerTwo.deleteRule = .nullifyDeleteRule
        
        relPlayerOne.inverseRelationship = relRoundsAsPlayerOne
        relRoundsAsPlayerOne.inverseRelationship = relPlayerOne
        
        relPlayerTwo.inverseRelationship = relRoundsAsPlayerTwo
        relRoundsAsPlayerTwo.inverseRelationship = relPlayerTwo
        
        playerEntity.properties = [pId, pName, pCreatedAt, pUpdatedAt, relRoundsAsPlayerOne, relRoundsAsPlayerTwo]
        roundEntity.properties = [
            rId, rDate, rGameMode, rPairCount, rPlayerOneScore, rPlayerTwoScore,
            rPlayerOneId, rPlayerTwoId, rPlayerOneSnapshot, rPlayerTwoSnapshot, rWinnerId,
            relPlayerOne, relPlayerTwo
        ]
        
        model.entities = [playerEntity, roundEntity]
        return model
    }
}

// MARK: - Core Data NSManagedObject Subclasses
@objc(PlayerProfileEntity)
public class PlayerProfileEntity: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var roundsAsPlayerOne: Set<GameRoundEntity>?
    @NSManaged public var roundsAsPlayerTwo: Set<GameRoundEntity>?
}

@objc(GameRoundEntity)
public class GameRoundEntity: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var gameMode: String?
    @NSManaged public var pairCount: Int16
    @NSManaged public var playerOneScore: Int16
    @NSManaged public var playerTwoScore: Int16
    @NSManaged public var playerOneId: UUID?
    @NSManaged public var playerTwoId: UUID?
    @NSManaged public var playerOneNameSnapshot: String?
    @NSManaged public var playerTwoNameSnapshot: String?
    @NSManaged public var winnerId: UUID?
    @NSManaged public var playerOne: PlayerProfileEntity?
    @NSManaged public var playerTwo: PlayerProfileEntity?
}
