//
//  AppController.h
//  MongoHq
//
//  Created by Taras Kalapun on 5/2/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppController : NSObject

@property (nonatomic, strong) RKObjectManager *statusObjectManager;

+ (AppController *)shared;

@end
