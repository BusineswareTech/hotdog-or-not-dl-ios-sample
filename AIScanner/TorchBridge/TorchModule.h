//
//  TorchModule.h
//  DLModels
//
//  Created by Alexandr Mikhailov on 16.10.2019.
//  Copyright © 2019 Alexandr Mikhailov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TorchModule : NSObject

- (nullable instancetype)initWithFileAtPath:(NSString*)filePath
    NS_SWIFT_NAME(init(fileAtPath:))NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (nullable NSArray<NSNumber*>*)predictImage:(void*)imageBuffer NS_SWIFT_NAME(predict(image:));

@end

NS_ASSUME_NONNULL_END
