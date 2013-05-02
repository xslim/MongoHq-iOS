//
//  AppController.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/2/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "AppController.h"

@implementation AppController

+ (AppController *)shared
{
    static AppController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppController alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setupStatusObjectManager];
    }
    return self;
}

- (void)setupStatusObjectManager
{
    NSString *baseUrl = @"http://status.mongohq.com/api/v1/";
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:baseUrl]];
    
    NSMutableIndexSet *statusCodes = [NSMutableIndexSet indexSet];
    [statusCodes addIndexes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    self.statusObjectManager = objectManager;
}

@end
