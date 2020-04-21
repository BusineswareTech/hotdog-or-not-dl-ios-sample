//
//  DI.swift
//  DL models
//
//  Created by Alexandr Mikhailov on 09.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

import Foundation

class DI {
    static func getApi() -> IApi {
        return Api()
    }
    
    static func getDLModelsCacheService() -> IMLModelCacheService {
        return MLModelCacheService()
    }
    
    static func getDLModelsRepository() -> IDLModelsRepository {
        return DLModelsRepository()
    }
    
    static func getDLModelsInteractor() -> IDLModelsInteractor {
        return DLModelsInteractor()
    }
    
    static func getDLModelsDAO() -> IDLModelsDAO {
        return DLModelsDAO()
    }
}
