//
//  DLModelDetailsUploadResponseDTO.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 22.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation

struct DLModelDetailsUploadResponseDTO: Decodable {
    var progress: Double?
    var modelType: DLModelType?
    var id: String?
}
