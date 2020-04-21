//
//  DLModelUploadEntity.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 08.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation

struct DLModelDetailsUploadDTO: Decodable {
    let imgURL: String?
    let fileURL: String?
    let name: String?
}
