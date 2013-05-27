//
//  MDatabase.h
//  MongoHq
//
//  Created by Taras Kalapun on 5/22/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDatabase : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *plan;
@property (nonatomic, strong) NSString *hostname;
@property (nonatomic, strong) NSNumber *port;

@property (nonatomic, readonly) NSString *titleText;
@property (nonatomic, readonly) NSString *subtitleText;
@property (nonatomic, readonly) NSString *databaseID;

@end
