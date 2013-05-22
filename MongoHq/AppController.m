//
//  AppController.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/2/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "AppController.h"
#import "StatusItem.h"

#import "Nocilla.h"

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
        [self mockHTTP];
        [self setupStatusObjectManager];
        
    }
    return self;
}

- (void)setupStatusObjectManager
{
    NSString *baseUrl = @"http://status.mongohq.com/api/v1/";
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:baseUrl]];
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[StatusItem class]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"name" : @"name",
     @"description" : @"itemDescription",
     @"current-event.status.name" : @"statusName",
     @"current-event.status.image" : @"statusImageUrlString",
     @"current-event.timestamp" : @"timestamp",
     @"current-event.message" : @"eventMessage",
     }];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    
    
    self.statusObjectManager = objectManager;
}

+ (void)stubRequestType:(NSString *)type uri:(NSString *)uri returnCode:(NSUInteger)code fixture:(NSString *)fixture {
//#ifdef COCOAPODS_POD_AVAILABLE_Nocilla
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fixture ofType:@"json" inDirectory:@"fixtures"];
    NSString *body = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    stubRequest(type, uri).andReturn(code).
    withHeaders(@{@"Content-Type": @"application/json"}).withBody(body);
//#endif
}

+ (void)stubGetRequest:(NSString *)uri withFixture:(NSString *)fixtureName {
    [self stubRequestType:@"GET" uri:uri returnCode:200 fixture:fixtureName];
}

+ (void)stubGetRequest:(NSString *)uri withFixtureFile:(NSString *)fixtureFile {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fixtureFile ofType:nil inDirectory:@"fixtures"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    stubRequest(@"GET", uri).andReturn(200).withData(data);
}

- (void)mockHTTP
{
//#ifdef COCOAPODS_POD_AVAILABLE_Nocilla
    [[LSNocilla sharedInstance] start];
    
    [AppController stubGetRequest:@"http://status.mongohq.com/api/v1/services" withFixture:@"status_services"];
    [AppController stubGetRequest:@"^http://(.*?)tick-circle\.png".regex withFixtureFile:@"tick-circle.png"];
    
//#endif
}

@end
