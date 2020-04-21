//
//  DLModelsListItemEntity.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 08.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation

struct DLModelInfoDTO: Decodable {
    let id: String
    let imgURL: String?
    let name: String
    let modelType: String
    let userId: String?
}
