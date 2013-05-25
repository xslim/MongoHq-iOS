//
//  AppController.h
//  MongoHq
//
//  Created by Taras Kalapun on 5/2/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"

@interface ApiController : NSObject

@property (nonatomic, strong) RKObjectManager *statusObjectManager;
@property (nonatomic, strong) NSString *apiKey;

+ (ApiController *)shared;

- (void)saveApiKey;
- (void)loadApiKey;

@end
