//
//  ImageProgressUploadDTO.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 23.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation

struct ImageProgressUploadResponseDTO: Decodable {
    var progress: Double?
    var imgURL: String?
}
