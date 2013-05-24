//
//  MDocument.h
//  MongoHq
//
//  Created by Taras Kalapun on 5/24/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDocument : NSObject

@property (nonatomic, strong) NSString *documentID;

@property (nonatomic, assign) NSDictionary *rootDocument;
@property (nonatomic, strong) NSDictionary *document;


@property (nonatomic, readonly) NSString *titleText;
@property (nonatomic, assign) NSString *documentString;

// relation
@property (nonatomic, strong) NSString *databaseID;
@property (nonatomic, strong) NSString *collectionID;

@end
