//
//  DocumentImporter.h
//  MongoHq
//
//  Created by Taras Kalapun on 6/7/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCollection;

@interface DocumentImporter : NSObject

@property (nonatomic, strong) MCollection *collection;

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *filePath;

- (void)run;

@end
