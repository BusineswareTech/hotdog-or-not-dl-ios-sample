//
//  DLModelEntity.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 08.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation

struct DLModelDetailsDownloadDTO: Decodable {
    let imgURL: String?
    let id: String?
    let name: String?
    let modelType: DLModelType?
    let userId: String?
}
