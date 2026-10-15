//
//  PlayerProfileRepository.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import CoreData
import Foundation

public protocol PlayerProfileRepositoryProtocol {
    func fetchAll() throws -> [PlayerProfile]
    func fetch(by id: UUID) throws -> PlayerProfile?
    func create(name: String) throws -> PlayerProfile
    func update(id: UUID, newName: String) throws -> PlayerProfile
    func delete(id: UUID) throws
    func seedDefaultsIfNeeded() throws
}

public final class PlayerProfileRepository: PlayerProfileRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext = PersistenceController.shared.viewContext) {
        self.context = context
    }
    
    public func fetchAll() throws -> [PlayerProfile] {
        var profiles: [PlayerProfile] = []
        var fetchError: Error?
        
        context.performAndWait {
            let request = NSFetchRequest<PlayerProfileEntity>(entityName: "PlayerProfileEntity")
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
            
            do {
                let entities = try context.fetch(request)
                profiles = entities.compactMap { entity in
                    guard let id = entity.id, let name = entity.name else { return nil }
                    return PlayerProfile(
                        id: id,
                        name: name,
                        createdAt: entity.createdAt ?? Date(),
                        updatedAt: entity.updatedAt ?? Date()
                    )
                }
            } catch {
                fetchError = error
            }
        }
        
        if let error = fetchError {
            throw error
        }
        return profiles
    }
    
    public func fetch(by id: UUID) throws -> PlayerProfile? {
        var profile: PlayerProfile?
        var fetchError: Error?
        
        context.performAndWait {
            let request = NSFetchRequest<PlayerProfileEntity>(entityName: "PlayerProfileEntity")
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.fetchLimit = 1
            
            do {
                if let entity = try context.fetch(request).first,
                   let entityId = entity.id,
                   let name = entity.name {
                    profile = PlayerProfile(
                        id: entityId,
                        name: name,
                        createdAt: entity.createdAt ?? Date(),
                        updatedAt: entity.updatedAt ?? Date()
                    )
                }
            } catch {
                fetchError = error
            }
        }
        
        if let error = fetchError {
            throw error
        }
        return profile
    }
    
    public func create(name: String) throws -> PlayerProfile {
        let validated = try PlayerProfile.validateName(name).get()
        var createdProfile: PlayerProfile?
        var saveError: Error?
        
        context.performAndWait {
            let entity = PlayerProfileEntity(context: context)
            let newId = UUID()
            let now = Date()
            
            entity.id = newId
            entity.name = validated
            entity.createdAt = now
            entity.updatedAt = now
            
            do {
                try context.save()
                createdProfile = PlayerProfile(id: newId, name: validated, createdAt: now, updatedAt: now)
            } catch {
                context.rollback()
                saveError = error
            }
        }
        
        if let error = saveError {
            throw error
        }
        guard let profile = createdProfile else {
            throw NSError(domain: "MemoryMatch", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create player profile"])
        }
        return profile
    }
    
    public func update(id: UUID, newName: String) throws -> PlayerProfile {
        let validated = try PlayerProfile.validateName(newName).get()
        var updatedProfile: PlayerProfile?
        var updateError: Error?
        
        context.performAndWait {
            let request = NSFetchRequest<PlayerProfileEntity>(entityName: "PlayerProfileEntity")
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.fetchLimit = 1
            
            do {
                guard let entity = try context.fetch(request).first else {
                    updateError = NSError(domain: "MemoryMatch", code: -2, userInfo: [NSLocalizedDescriptionKey: "Player not found"])
                    return
                }
                
                let now = Date()
                entity.name = validated
                entity.updatedAt = now
                
                try context.save()
                updatedProfile = PlayerProfile(
                    id: id,
                    name: validated,
                    createdAt: entity.createdAt ?? Date(),
                    updatedAt: now
                )
            } catch {
                context.rollback()
                updateError = error
            }
        }
        
        if let error = updateError {
            throw error
        }
        guard let profile = updatedProfile else {
            throw NSError(domain: "MemoryMatch", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to update player"])
        }
        return profile
    }
    
    public func delete(id: UUID) throws {
        var deleteError: Error?
        
        context.performAndWait {
            let request = NSFetchRequest<PlayerProfileEntity>(entityName: "PlayerProfileEntity")
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.fetchLimit = 1
            
            do {
                if let entity = try context.fetch(request).first {
                    // Core Data nullify rule unlinks relationships without deleting GameRoundEntity
                    context.delete(entity)
                    try context.save()
                }
            } catch {
                context.rollback()
                deleteError = error
            }
        }
        
        if let error = deleteError {
            throw error
        }
    }
    
    public func seedDefaultsIfNeeded() throws {
        var seedError: Error?
        
        context.performAndWait {
            let countRequest = NSFetchRequest<NSNumber>(entityName: "PlayerProfileEntity")
            countRequest.resultType = .countResultType
            
            do {
                let count = try context.count(for: NSFetchRequest<PlayerProfileEntity>(entityName: "PlayerProfileEntity"))
                if count == 0 {
                    // Seed Maya (Player 1)
                    let p1 = PlayerProfileEntity(context: context)
                    p1.id = PlayerProfile.defaultPlayerOne.id
                    p1.name = PlayerProfile.defaultPlayerOne.name
                    p1.createdAt = Date()
                    p1.updatedAt = Date()
                    
                    // Seed Leo (Player 2)
                    let p2 = PlayerProfileEntity(context: context)
                    p2.id = PlayerProfile.defaultPlayerTwo.id
                    p2.name = PlayerProfile.defaultPlayerTwo.name
                    p2.createdAt = Date().addingTimeInterval(1)
                    p2.updatedAt = Date().addingTimeInterval(1)
                    
                    try context.save()
                }
            } catch {
                context.rollback()
                seedError = error
            }
        }
        
        if let error = seedError {
            throw error
        }
    }
}
