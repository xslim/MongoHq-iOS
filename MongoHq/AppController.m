//
//  AppController.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/2/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "AppController.h"
#import "MongoHqHTTPClient.h"

#import "StatusItem.h"
#import "MDatabase.h"
#import "MPlan.h"
#import "MCollection.h"

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
        //[self mockHTTP];
        [self setupStatusObjectManager];
        [self setupObjectManager];
        [self addErrorMappings];
        [self setupResponseDescriptors];
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

- (void)addErrorMappings
{
    // Define Error mapping
    
    // You can map errors to any class, but `RKErrorMessage` is included for free
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    // The entire value at the source key path containing the errors maps to the message
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
    
    NSIndexSet *clientErrorStatusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError);
    // Any response in the 4xx status code range with an "error" key path uses this mapping
    RKResponseDescriptor *errorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping pathPattern:nil keyPath:@"error" statusCodes:clientErrorStatusCodes];
    
    // Add it to default response mappers
    [self.objectManager addResponseDescriptor:errorDescriptor];
}

- (void)setupObjectManager
{
    // Remember not to put `/` at the end.
    // Otherwise, you'll be in a problem with response mapping.
    NSString *baseUrl = @"https://api.mongohq.com";
    
    // Initialize our custom HTTP Client to always add _apikey to url params
    MongoHqHTTPClient *httpClient = [[MongoHqHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    
    // Init with custom HTTPClient
    RKObjectManager *manager = [[RKObjectManager alloc] initWithHTTPClient:httpClient];

    // Add text/plain as json content type to properly parse errors
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    [manager.HTTPClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [manager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    manager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;

    
    self.objectManager = manager;
}

- (void)setupResponseDescriptors
{
    [self.objectManager addResponseDescriptor:[self databasesResponseDescriptor]];
    [self.objectManager addResponseDescriptor:[self plansResponseDescriptor]];
    [self.objectManager addResponseDescriptor:[self collectionsResponseDescriptor]];
}

#pragma mark - Response Descriptors

- (RKResponseDescriptor *)databasesResponseDescriptor
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[MDatabase class]];
    [mapping addAttributeMappingsFromArray:@[@"name", @"plan", @"hostname", @"port"]];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:@"/databases" keyPath:nil statusCodes:statusCodes];
    return responseDescriptor;
}

- (RKResponseDescriptor *)plansResponseDescriptor
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[MPlan class]];
    [mapping addAttributeMappingsFromArray:@[@"name", @"slug", @"price", @"type"]];
    
    //[mapping addAttributeMappingsFromDictionary:@{@"@metadata.mapping.collectionIndex": @"index"}];
    //[mapping addAttributeMappingsFromDictionary:@{@"@metadata.HTTP.response.headers": @"headers"}];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:@"/plans" keyPath:nil statusCodes:statusCodes];
    return responseDescriptor;
}

- (RKResponseDescriptor *)collectionsResponseDescriptor
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[MCollection class]];
    [mapping addAttributeMappingsFromArray:@[@"name", @"count", @"indexCount", @"storageSize"]];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:@"/databases/:databaseID/collections" keyPath:nil statusCodes:statusCodes];
    return responseDescriptor;
}

#pragma mark - Stub stuff

+ (void)stubRequestType:(NSString *)type uri:(NSString *)uri returnCode:(NSUInteger)code fixture:(NSString *)fixture {
//#ifdef COCOAPODS_POD_AVAILABLE_Nocilla
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fixture ofType:@"json" inDirectory:@"fixtures"];
    NSString *body = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    stubRequest(type, uri).andReturn(code).
    withHeaders(@{@"Content-Type": @"application/json"}).withBody(body);
//#endif
}

+ (void)stubGetRequest:(id)uri withFixture:(NSString *)fixtureName {
    [self stubRequestType:@"GET" uri:uri returnCode:200 fixture:fixtureName];
}

+ (void)stubGetRequest:(id)uri withFixtureFile:(NSString *)fixtureFile {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fixtureFile ofType:nil inDirectory:@"fixtures"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    stubRequest(@"GET", uri).andReturn(200).withData(data);
}

- (void)mockHTTP
{
//#ifdef COCOAPODS_POD_AVAILABLE_Nocilla
    [[LSNocilla sharedInstance] start];
    
    // Status
    [AppController stubGetRequest:@"http://status.mongohq.com/api/v1/services" withFixture:@"status_services"];
    [AppController stubGetRequest:@"^http://(.*?)tick-circle\.png".regex withFixtureFile:@"tick-circle.png"];
    
    // API
    [AppController stubGetRequest:@"^https://api.mongohq.com/databases?_apikey=(.*?)".regex withFixture:@"databases"];
//#endif
}

@end
