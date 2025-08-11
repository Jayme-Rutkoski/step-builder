//
//  BaseCollectionProtocol.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 8/11/25.
//


import Foundation
import FirebaseFirestore

protocol BaseCollectionProtocol {
    var collectionName: String { get set }
}

class BaseCollection: BaseCollectionProtocol {
    
    let CACHE = FirestoreSource.cache
    let SERVER = FirestoreSource.server
    var collectionName: String = ""
    
    let db = Firestore.firestore()
    
    public func getAllCollectionDocuments() async -> QuerySnapshot? {
        do {
            let documents = try await db.collection(self.collectionName).getDocuments()
            return documents
        } catch {
            return nil
        }
    }
    
    public func getCollection() -> CollectionReference {
        return db.collection(self.collectionName)
    }
}
