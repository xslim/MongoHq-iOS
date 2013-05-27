//
//  MCollection.h
//  MongoHq
//
//  Created by Taras Kalapun on 5/23/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCollection : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSNumber *indexCount;
@property (nonatomic, strong) NSNumber *storageSize;

@property (nonatomic, readonly) NSString *titleText;
@property (nonatomic, readonly) NSString *subtitleText;
@property (nonatomic, readonly) NSString *collectionID;

@property (nonatomic, strong) NSString *databaseID;

@end
