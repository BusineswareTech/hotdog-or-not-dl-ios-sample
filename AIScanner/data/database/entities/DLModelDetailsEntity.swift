//
//  DLModelDetailsDTO.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 17.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import RealmSwift

class DLModelDetailsEntity: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var imgURL: String? = nil
    @objc dynamic var fileURL: String? = nil
    @objc dynamic var name: String? = nil
    @objc dynamic var userId: String? = nil
    @objc dynamic var modelType: String? = nil
    
    var modelTypeEnum: DLModelType? {
        get {
            guard let modelType = modelType else { return nil }
            return DLModelType(rawValue: modelType)
        }
        set {
            guard let newValue = newValue else {
                modelType = nil
                return
            }
            modelType = newValue.rawValue
        }
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
