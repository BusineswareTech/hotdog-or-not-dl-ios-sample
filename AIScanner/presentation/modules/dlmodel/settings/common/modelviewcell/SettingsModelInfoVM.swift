//
//  SettingsModelInfo.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 11.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation

enum SettingsModelDownloadingStatus {
    case notDownloaded, downloading, downloaded
}

struct SettingsModelInfoVM {
    let imgURL: String?
    let name: String?
    let downloadingStatus: SettingsModelDownloadingStatus
    let id: String?
    let progress: Double?
    let isActive: Bool
    
    init(dlModelInfo: DLModelInfoItem) {
        imgURL = dlModelInfo.imgURL
        id = dlModelInfo.id
        name = dlModelInfo.name
        self.progress = dlModelInfo.progress
        self.isActive = dlModelInfo.isActive
        
        if dlModelInfo.progress != nil {
            self.downloadingStatus = .downloading
        } else if dlModelInfo.fileURL == nil {
            self.downloadingStatus = .notDownloaded
        } else {
            self.downloadingStatus = .downloaded
        }
    }
}
