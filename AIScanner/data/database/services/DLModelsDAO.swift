//
//  DLModelDAO.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 17.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import RealmSwift

protocol IDLModelsDAO {
    func getModelBy(id: String) -> DLModelDetailsEntity?
    func getModelsBy(user: String) -> [DLModelDetailsEntity]
    func getModels() -> [DLModelDetailsEntity]
    func getRemoteModels() -> [DLModelDetailsEntity]
    func insert(dlModelDetailsEntity: DLModelDetailsEntity) -> Bool
    func update(dlModelDetailsEntity: DLModelDetailsEntity) -> Bool
}

class DLModelsDAO: IDLModelsDAO {
    private let realm = try! Realm()
    
    func getModelBy(id: String) -> DLModelDetailsEntity? {
        let a = Array(realm.objects(DLModelDetailsEntity.self).filter(NSPredicate(format: "id = %@", id)))
        return a.first
//        let a = Array(realm.objects(DLModelDetailsEntity.self))
        return realm.object(ofType: DLModelDetailsEntity.self, forPrimaryKey: id)
    }
    
    func getModels() -> [DLModelDetailsEntity] {
        return Array(realm.objects(DLModelDetailsEntity.self))
    }
    
    func getModelsBy(user: String) -> [DLModelDetailsEntity] {
        return Array(realm.objects(DLModelDetailsEntity.self).filter(NSPredicate(format: "userId = %@", user)))
    }
    
    func getRemoteModels() -> [DLModelDetailsEntity] {
        return Array(realm.objects(DLModelDetailsEntity.self).filter("userId = null"))
    }
    
    func insert(dlModelDetailsEntity: DLModelDetailsEntity) -> Bool {
        try! realm.write {
            realm.add(dlModelDetailsEntity)
        }
        return true
    }
    
    func update(dlModelDetailsEntity: DLModelDetailsEntity) -> Bool {
        try! realm.write {
            realm.add(dlModelDetailsEntity, update: .modified)
        }
        return true
    }
}
