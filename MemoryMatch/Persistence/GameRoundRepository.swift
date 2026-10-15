//
//  GameRoundRepository.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import CoreData
import Foundation

public protocol GameRoundRepositoryProtocol {
    func save(round: GameRoundResult) throws
    func fetchAll(mode: GameMode?, difficulty: Difficulty?) throws -> [GameRoundResult]
    func delete(id: UUID) throws
    func clearAll() throws
    func computeLeaderboard(mode: GameMode?, difficulty: Difficulty?) throws -> [PlayerAggregateStats]
}

public final class GameRoundRepository: GameRoundRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext = PersistenceController.shared.viewContext) {
        self.context = context
    }
    
    public func save(round: GameRoundResult) throws {
        var saveError: Error?
        
        context.performAndWait {
            // Deduplicate by round UUID
            let checkRequest = NSFetchRequest<GameRoundEntity>(entityName: "GameRoundEntity")
            checkRequest.predicate = NSPredicate(format: "id == %@", round.id as CVarArg)
            checkRequest.fetchLimit = 1
            
            do {
                if let existing = try context.fetch(checkRequest).first {
                    // Already saved; idempotent update
                    existing.playerOneScore = Int16(round.playerOneScore)
                    existing.playerTwoScore = Int16(round.playerTwoScore)
                    existing.winnerId = round.winnerId
                    try context.save()
                    return
                }
                
                let entity = GameRoundEntity(context: context)
                entity.id = round.id
                entity.date = round.date
                entity.gameMode = round.mode.rawValue
                entity.pairCount = Int16(round.difficulty.pairCount)
                entity.playerOneScore = Int16(round.playerOneScore)
                entity.playerTwoScore = Int16(round.playerTwoScore)
                entity.playerOneId = round.playerOneSnapshot.id
                entity.playerTwoId = round.playerTwoSnapshot.id
                entity.playerOneNameSnapshot = round.playerOneSnapshot.name
                entity.playerTwoNameSnapshot = round.playerTwoSnapshot.name
                entity.winnerId = round.winnerId
                
                // Link relationships if profile entities still exist
                if let p1Id = round.playerOneSnapshot.id {
                    let p1Req = NSFetchRequest<PlayerProfileEntity>(entityName: "PlayerProfileEntity")
                    p1Req.predicate = NSPredicate(format: "id == %@", p1Id as CVarArg)
                    p1Req.fetchLimit = 1
                    entity.playerOne = try context.fetch(p1Req).first
                }
                
                if let p2Id = round.playerTwoSnapshot.id {
                    let p2Req = NSFetchRequest<PlayerProfileEntity>(entityName: "PlayerProfileEntity")
                    p2Req.predicate = NSPredicate(format: "id == %@", p2Id as CVarArg)
                    p2Req.fetchLimit = 1
                    entity.playerTwo = try context.fetch(p2Req).first
                }
                
                try context.save()
            } catch {
                context.rollback()
                saveError = error
            }
        }
        
        if let error = saveError {
            throw error
        }
    }
    
    public func fetchAll(mode: GameMode? = nil, difficulty: Difficulty? = nil) throws -> [GameRoundResult] {
        var results: [GameRoundResult] = []
        var fetchError: Error?
        
        context.performAndWait {
            let request = NSFetchRequest<GameRoundEntity>(entityName: "GameRoundEntity")
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            
            var subpredicates: [NSPredicate] = []
            if let mode = mode {
                subpredicates.append(NSPredicate(format: "gameMode == %@", mode.rawValue))
            }
            if let difficulty = difficulty {
                subpredicates.append(NSPredicate(format: "pairCount == %d", difficulty.pairCount))
            }
            
            if !subpredicates.isEmpty {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates)
            }
            
            do {
                let entities = try context.fetch(request)
                results = entities.compactMap { entity in
                    guard let id = entity.id,
                          let date = entity.date,
                          let modeStr = entity.gameMode,
                          let mode = GameMode(rawValue: modeStr),
                          let difficulty = Difficulty(rawValue: Int(entity.pairCount)) else {
                        return nil
                    }
                    
                    let p1Name = entity.playerOneNameSnapshot ?? entity.playerOne?.name ?? "Player 1"
                    let p2Name = entity.playerTwoNameSnapshot ?? entity.playerTwo?.name ?? "Player 2"
                    
                    return GameRoundResult(
                        id: id,
                        date: date,
                        mode: mode,
                        difficulty: difficulty,
                        playerOneScore: Int(entity.playerOneScore),
                        playerTwoScore: Int(entity.playerTwoScore),
                        playerOneSnapshot: PlayerSnapshot(id: entity.playerOneId, name: p1Name),
                        playerTwoSnapshot: PlayerSnapshot(id: entity.playerTwoId, name: p2Name),
                        winnerId: entity.winnerId
                    )
                }
            } catch {
                fetchError = error
            }
        }
        
        if let error = fetchError {
            throw error
        }
        return results
    }
    
    public func delete(id: UUID) throws {
        var deleteError: Error?
        
        context.performAndWait {
            let request = NSFetchRequest<GameRoundEntity>(entityName: "GameRoundEntity")
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.fetchLimit = 1
            
            do {
                if let entity = try context.fetch(request).first {
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
    
    public func clearAll() throws {
        var clearError: Error?
        
        context.performAndWait {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GameRoundEntity")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            deleteRequest.resultType = .resultTypeObjectIDs
            
            do {
                let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
                if let objectIDs = result?.result as? [NSManagedObjectID] {
                    let changes = [NSDeletedObjectsKey: objectIDs]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
                }
                try context.save()
            } catch {
                // Fallback for in-memory stores that don't support batch delete
                do {
                    let entities = try context.fetch(NSFetchRequest<GameRoundEntity>(entityName: "GameRoundEntity"))
                    for entity in entities {
                        context.delete(entity)
                    }
                    try context.save()
                } catch {
                    context.rollback()
                    clearError = error
                }
            }
        }
        
        if let error = clearError {
            throw error
        }
    }
    
    public func computeLeaderboard(mode: GameMode? = nil, difficulty: Difficulty? = nil) throws -> [PlayerAggregateStats] {
        let rounds = try fetchAll(mode: mode, difficulty: difficulty)
        
        // Group players by stable UUID (or fallback to snapshot name)
        var playerMap: [UUID: PlayerAggregateStats] = [:]
        
        for round in rounds {
            // Player 1
            let p1Id = round.playerOneSnapshot.id ?? UUID()
            var p1Stats = playerMap[p1Id] ?? PlayerAggregateStats(
                id: p1Id,
                name: round.playerOneSnapshot.name,
                initials: initials(from: round.playerOneSnapshot.name)
            )
            p1Stats.gamesPlayed += 1
            p1Stats.pairsMatched += round.playerOneScore
            if round.winnerId != nil && round.winnerId == round.playerOneSnapshot.id {
                p1Stats.wins += 1
            }
            playerMap[p1Id] = p1Stats
            
            // Player 2
            let p2Id = round.playerTwoSnapshot.id ?? UUID()
            var p2Stats = playerMap[p2Id] ?? PlayerAggregateStats(
                id: p2Id,
                name: round.playerTwoSnapshot.name,
                initials: initials(from: round.playerTwoSnapshot.name)
            )
            p2Stats.gamesPlayed += 1
            p2Stats.pairsMatched += round.playerTwoScore
            if round.winnerId != nil && round.winnerId == round.playerTwoSnapshot.id {
                p2Stats.wins += 1
            }
            playerMap[p2Id] = p2Stats
        }
        
        // Deterministic sorting:
        // 1. Wins descending
        // 2. Pairs matched descending
        // 3. Name alphabetical ascending (stable tie-breaker)
        let sorted = playerMap.values.sorted { a, b in
            if a.wins != b.wins {
                return a.wins > b.wins
            }
            if a.pairsMatched != b.pairsMatched {
                return a.pairsMatched > b.pairsMatched
            }
            if a.gamesPlayed != b.gamesPlayed {
                return a.gamesPlayed < b.gamesPlayed
            }
            return a.name.localizedStandardCompare(b.name) == .orderedAscending
        }
        
        return sorted
    }
    
    private func initials(from name: String) -> String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "?" }
        let components = trimmed.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        if components.count >= 2 {
            let first = components[0].prefix(1)
            let second = components[1].prefix(1)
            return "\(first)\(second)".uppercased()
        } else {
            return String(trimmed.prefix(1)).uppercased()
        }
    }
}
