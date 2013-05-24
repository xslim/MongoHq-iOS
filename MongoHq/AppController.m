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
#import "MDocument.h"

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
        [self setupMappings];
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
    manager.requestSerializationMIMEType = RKMIMETypeJSON;

    
    self.objectManager = manager;
}

- (void)setupMappings
{
    [self setupErrorMappings];
    [self setupDatabaseMappings];
    [self setupCollectionMappings];
    [self setupDocumentMappings];
}

#pragma mark - Object Mappings

- (void)setupErrorMappings
{
    // Define Error mapping
    
    // You can map errors to any class, but `RKErrorMessage` is included for free
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    // The entire value at the source key path containing the errors maps to the message
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
    
    NSIndexSet *clientErrorStatusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError);
    NSIndexSet *serverStatusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassServerError); // Anything in 5xx
    
    NSMutableIndexSet *statusCodes = [[NSMutableIndexSet alloc] initWithIndexSet:clientErrorStatusCodes];
    //    [statusCodes addIndexes:goodStatusCodes];
    [statusCodes addIndexes:serverStatusCodes];
    
    // Any response in the 4xx status code range with an "error" key path uses this mapping
    RKResponseDescriptor *errorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping pathPattern:nil keyPath:@"error" statusCodes:statusCodes];
    
    // Add it to default response mappers
    [self.objectManager addResponseDescriptor:errorDescriptor];
}

- (void)setupPlanMappings
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[MPlan class]];
    [mapping addAttributeMappingsFromArray:@[@"name", @"slug", @"price", @"type"]];
    
    //[mapping addAttributeMappingsFromDictionary:@{@"@metadata.mapping.collectionIndex": @"index"}];
    //[mapping addAttributeMappingsFromDictionary:@{@"@metadata.HTTP.response.headers": @"headers"}];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:@"/plans" keyPath:nil statusCodes:statusCodes];
    [self.objectManager addResponseDescriptor:responseDescriptor];
}

- (void)setupDatabaseMappings
{
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping addAttributeMappingsFromArray:@[@"name"]];
    [requestMapping addAttributeMappingsFromDictionary:@{@"plan": @"slug"}];
    
    
    // For any object of class MDatabase, serialize into an NSMutableDictionary using the given mapping
    // If we will provide the rootKeyPath, serialization will nest under the 'provided' key path
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[MDatabase class] rootKeyPath:nil];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[MDatabase class]];
    [mapping addAttributeMappingsFromArray:@[@"name", @"plan", @"hostname", @"port"]];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:@"/databases" keyPath:nil statusCodes:statusCodes];
    [self.objectManager addResponseDescriptor:responseDescriptor];
}

- (void)setupCollectionMappings
{
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping addAttributeMappingsFromArray:@[@"name"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[MCollection class] rootKeyPath:nil];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[MCollection class]];
    [mapping addAttributeMappingsFromArray:@[@"name", @"count", @"indexCount", @"storageSize"]];

    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:@"/databases/:databaseID/collections" keyPath:nil statusCodes:statusCodes];
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    RKResponseDescriptor *emptyResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RKObjectMapping new] pathPattern:@"/databases/:databaseID/collections/:collectionID" keyPath:nil statusCodes:statusCodes];
    [self.objectManager addResponseDescriptor:emptyResponseDescriptor];
}

- (void)setupDocumentMappings
{
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping addAttributeMappingsFromArray:@[@"document"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[MDocument class] rootKeyPath:nil];
    [self.objectManager addRequestDescriptor:requestDescriptor];
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[MDocument class]];
    [mapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"rootDocument"]];
    
    NSString *path = @"/databases/:databaseID/collections/:collectionID/documents";
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:path keyPath:nil statusCodes:statusCodes];
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    RKResponseDescriptor *emptyResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RKObjectMapping new] pathPattern:@"/databases/:databaseID/collections/:collectionID/documents/:documentID" keyPath:nil statusCodes:statusCodes];
    [self.objectManager addResponseDescriptor:emptyResponseDescriptor];
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
