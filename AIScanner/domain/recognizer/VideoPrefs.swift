//
//  VideoPrefs.swift
//  mlrecognizer
//
//  Created by Alexandr Mikhailov on 10.09.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation
import UIKit

struct VideoPrefs {
    let fps: Int
    let size: CGSize
    
    static func defaultPrefs() -> VideoPrefs {
        return VideoPrefs(fps: 5, size: CGSize(width:224, height:224))
    }
}
