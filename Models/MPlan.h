//
//  MPlan.h
//  MongoHq
//
//  Created by Taras Kalapun on 5/23/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPlan : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *type;

//@metadata.mapping.collectionIndex
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) NSDictionary *headers;

@end
