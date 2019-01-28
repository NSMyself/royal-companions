//
//  FeedStore+PersistenceProvider.swift
//  Babylon iOS Interview Demo
//
//  Created by João Pereira on 26/01/2019.
//  Copyright © 2019 NSMyself. All rights reserved.
//

import ReactiveSwift

public typealias PersistenceError = FeedStore.Persistence.Error

public extension FeedStore {
    
    public final class Persistence {
        
        public enum Error: String {
            case documentDirectoryNotFound =  "Document directory not found"
            case noObjectsToStore = "No objects to store"
            case writeFailure = "Could not write to disk"
            case readFailure = "Could not read data from disk"
            case encodeFailure = "Could not encode objects"
            case decodeFailure = "Could not decode objects"
            case nullDataToEncode = "Trying to write null data to disk"
        }
    }
}

extension FeedStore.Persistence {
        
    func fetchPosts() -> SignalProducer<[Post], FeedStore.Error> {
        
        return SignalProducer<[Post], FeedStore.Error> { [weak self] observer, lifetime in
            
            guard let data = self?.loadFromDisk() else {
                observer.send(error: FeedStoreError.persistence(.readFailure))
            }
            
            guard let posts = self?.decode(data: data) else {
                observer.send(error: FeedStoreError.persistence(.readFailure))
            }
            
            guard let posts:[Post] = self?.decode(data: self?.loadFromDisk()) else {
                observer.send(error: FeedStore.Error.databaseError)
                return
            }
            
            observer.send(value: posts)
        }
    }
    
    func fetchUsers() -> SignalProducer<[User], FeedStore.Error> {
        
        
        
        
        
        
        return SignalProducer<[User], FeedStore.Error> { [weak self] observer, lifetime in
            
            guard let posts:[User] = self?.decode(data: self?.loadFromDisk()) else {
                observer.send(error: FeedStore.Error.databaseError)
                return
            }
            
            observer.send(value: posts)
        }
    }
    
    func fetchComments() -> SignalProducer<[Comment], FeedStore.Error> {
        
        return SignalProducer<[Comment], FeedStore.Error> { [weak self] observer, lifetime in
            
            guard let posts:[Comment] = self?.decode(data: self?.loadFromDisk()) else {
                observer.send(error: FeedStore.Error.databaseError)
                return
            }
            
            observer.send(value: posts)
        }
    }
}

extension FeedStore.Persistence {

    func store(posts objects: [Post]) {
        guard validate(objects) else { return }
        objects |> encode >>> storeToDisk(posts:)
    }
    
    func store(users objects: [User]) {
        guard validate(objects) else { return }
        objects |> encode >>> storeToDisk(users:)
    }
    
    func store(comments objects: [Comment]) {
        guard validate(objects) else { return }
        objects |> encode >>> storeToDisk(comments:)
    }
}

extension FeedStore.Persistence {
    
    private func loadFromDisk() -> Data? {
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            PersistenceError.documentDirectoryNotFound.log()
            return nil
        }
        
        do {
            return try Data(contentsOf: documentDirectory.appendingPathComponent("posts.data").absoluteURL)
        }
        catch {
            PersistenceError.decodeFailure.log()
        }
        
        return nil
    }
    
    private  func decode<T: Decodable>(data: Data?) -> T? {
        
        guard let data = data else {
            PersistenceError.readFailure.log()
            return nil
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            PersistenceError.decodeFailure.log()
        }
        
        return nil
    }
}

extension FeedStore.Persistence {
    
    private func encode<T: Encodable>(items: T) -> String? {
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(items)
            return String(data: data, encoding: .utf8)
        }
        catch {
            PersistenceError.encodeFailure.log()
        }
        
        return nil
    }
    
    private func storeToDisk(posts: String?) {
        storeToDisk(payload: posts, filename: "posts")
    }
    
    private func storeToDisk(users: String?) {
        storeToDisk(payload: users, filename: "comments")
    }
    private func storeToDisk(comments: String?) {
        storeToDisk(payload: comments, filename: "comments")
    }
    
    private func storeToDisk(payload: String?, filename: String) {
        do {
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                PersistenceError.documentDirectoryNotFound.log()
                return
            }
            
            guard let payload = payload else {
                PersistenceError.nullDataToEncode.log()
                return
            }
            
            try payload.write(to: documentDirectory.appendingPathComponent("\(filename).data"), atomically: true, encoding: .utf8)
        }
        catch {
            PersistenceError.writeFailure.log()
        }
    }
}

extension FeedStore.Persistence {
    
    fileprivate func validate<T>(_ objects: [T]) -> Bool {
        guard objects.count > 0 else {
            PersistenceError.noObjectsToStore.log()
            return false
        }
        
        return true
    }
}
