//
//  AppController.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/2/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "MongoHqApi.h"
#import "MongoHqHTTPClient.h"

#import "StatusItem.h"
#import "MDatabase.h"
#import "MPlan.h"
#import "MCollection.h"
#import "MDocument.h"

#ifdef COCOAPODS_POD_AVAILABLE_Nocilla
#import "Nocilla.h"
#endif

#ifdef COCOAPODS_POD_AVAILABLE_MagicalRecord
// Use a class extension to expose access to MagicalRecord's private setter methods
@interface NSManagedObjectContext ()
+ (void)MR_setRootSavingContext:(NSManagedObjectContext *)context;
+ (void)MR_setDefaultContext:(NSManagedObjectContext *)moc;
@end
@interface NSPersistentStoreCoordinator ()
+ (void)MR_setDefaultStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;
@end
#endif

@implementation MongoHqApi

+ (MongoHqApi *)shared
{
    static MongoHqApi *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MongoHqApi alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        //[self mockHTTP];
        
        //RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
        //RKLogConfigureByName("RestKit/CoreData", RKLogLevelTrace);
        
        [self loadApiKey];
        [self setupStatusObjectManager];
        [self setupObjectManager];
        
        // Setup CoreData stack after Object Manager
        [self setupCoreData];
        
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
    
    //NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    
    
    self.statusObjectManager = objectManager;
}


- (void)setupObjectManager
{
    // Set the base Url. Remember not to put `/` at the end.
    // Otherwise, you'll be in a problem with response mapping.
    NSString *baseUrl = @"https://api.mongohq.com";
    
    // Initialize our custom HTTP Client to always add _apikey to url
    MongoHqHTTPClient *httpClient = [[MongoHqHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    
    // Init with custom HTTPClient
    RKObjectManager *manager = [[RKObjectManager alloc] initWithHTTPClient:httpClient];

    // MongoHQ APIs sometimes return errors in text/plain
    // Add text/plain as JSON content type to properly parse errors
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    // register JSONRequestOperation to parse JSON in requests
    [manager.HTTPClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [manager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    // Set the shared instance of the object manager
    // So we can easily re-use it later
    [RKObjectManager setSharedManager:manager];
    
    // Show activity indicator in status bar
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
}

- (void)setupCoreData
{
#ifndef USE_COREDATA
    return;
#endif
    
    // Configure RestKit's Core Data stack
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"MongoHq" ofType:@"momd"]];
    
    // NOTE: Due to an iOS 5 bug, the managed object model returned is immutable.
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"MongoHq.sqlite"];
    NSError *error = nil;
    [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    [managedObjectStore createManagedObjectContexts];
    
#ifdef COCOAPODS_POD_AVAILABLE_MagicalRecord
    // Configure MagicalRecord to use RestKit's Core Data stack
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:managedObjectStore.persistentStoreCoordinator];
    [NSManagedObjectContext MR_setRootSavingContext:managedObjectStore.persistentStoreManagedObjectContext];
    [NSManagedObjectContext MR_setDefaultContext:managedObjectStore.mainQueueManagedObjectContext];
#endif
    // Set the default store shared instance
    [RKManagedObjectStore setDefaultStore:managedObjectStore];
    
    // Assign Managed object store to Object manager
    RKObjectManager *manager = [RKObjectManager sharedManager];
    manager.managedObjectStore = managedObjectStore;
}

- (void)setupMappings
{
    [self setupErrorMappings];
    [self setupPlanMappings];
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
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager addResponseDescriptor:errorDescriptor];
}

- (void)setupPlanMappings
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[MPlan class]];
    [mapping addAttributeMappingsFromArray:@[@"name", @"slug", @"price", @"type"]];
    
    //[mapping addAttributeMappingsFromDictionary:@{@"@metadata.mapping.collectionIndex": @"index"}];
    //[mapping addAttributeMappingsFromDictionary:@{@"@metadata.HTTP.response.headers": @"headers"}];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:@"/plans" keyPath:nil statusCodes:statusCodes];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager addResponseDescriptor:responseDescriptor];

    RKRoute *route = [RKRoute routeWithName:@"plans" pathPattern:@"/plans" method:RKRequestMethodGET];
    [manager.router.routeSet addRoute:route];
}

- (void)setupDatabaseMappings
{
    // Get the object manager we use
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    // The class we map to
    Class itemClass = [MDatabase class];
    
    // The endpoint we plan to request for getting a list of objects
    NSString *itemsPath = @"/databases";
    
    // The endpoint for manipulating with existing object
    NSString *itemPath  = @"/databases/:databaseID";
    
    // REQUEST
    
    // Create the request mapping
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    
    // "name" will be same in JSON and in a class
    [requestMapping addAttributeMappingsFromArray:@[@"name"]];
    
    // Map "plan" property from class to "slug" in serialized JSON
    [requestMapping addAttributeMappingsFromDictionary:@{@"plan": @"slug"}];
    
    
    // For any object of class MDatabase, serialize into an NSMutableDictionary using the given mapping
    // If we will provide the rootKeyPath, serialization will nest under the 'provided' key path
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:itemClass rootKeyPath:nil];
    [manager addRequestDescriptor:requestDescriptor];
    
    // RESPONSE
    
    // Define that a mapping will be for MDatabase class
#ifdef USE_COREDATA
    RKManagedObjectStore *managedObjectStore = [RKManagedObjectStore defaultStore];
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Database" inManagedObjectStore:managedObjectStore];
    
    // How to identify if the object we got is in database
    // Here, we identify by name.
    mapping.identificationAttributes = @[@"name"];
#else
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:itemClass];
#endif
    // The names of JSON fields and class properties are same here
    [mapping addAttributeMappingsFromArray:@[@"name", @"plan", @"hostname", @"port"]];
    
    // The root JSON key path. nil in our case states that there won't be one.
    NSString *keyPath = nil;
    
    // The mapping will be triggered if a response status code is anything in 2xx
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    // Put it all together in response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:itemsPath keyPath:keyPath statusCodes:statusCodes];
    
    // Add response descriptor to our manager
    [manager addResponseDescriptor:responseDescriptor];
    
    // ROUTING
    
    // Route for list of objects
    RKRoute *itemsRoute = [RKRoute routeWithName:@"databases" pathPattern:itemsPath method:RKRequestMethodGET];
    itemsRoute.shouldEscapePath = YES;
    
    // Route for creating a new object
    RKRoute *newItemRoute  = [RKRoute routeWithClass:itemClass pathPattern:itemsPath method:RKRequestMethodPOST];
    newItemRoute.shouldEscapePath = YES;
    
    // Route for manipulating with existing object
    RKRoute *itemRoute  = [RKRoute routeWithClass:itemClass pathPattern:itemPath method:RKRequestMethodAny];
    itemsRoute.shouldEscapePath = YES;
    
    // Add defined routes to the Object Manager router
    [manager.router.routeSet addRoutes:@[itemsRoute, newItemRoute, itemRoute]];
}

- (void)setupCollectionMappings
{
    RKObjectManager *manager = [RKObjectManager sharedManager];

    Class itemClass = [MCollection class];
    NSString *itemsPath = @"/databases/:databaseID/collections";
    
    // The endpoint for manipulating with existing object
    NSString *itemPath  = @"/databases/:databaseID/collections/:collectionID";

    // Create the request mapping
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];

    // "name" will be same in JSON and in a class
    [requestMapping addAttributeMappingsFromArray:@[@"name"]];

    // For any object of class MCollection, serialize into an NSMutableDictionary using the given mapping
    // If we will provide the rootKeyPath, serialization will nest under the 'provided' key path
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:itemClass rootKeyPath:nil];
    [manager addRequestDescriptor:requestDescriptor];
    
#ifdef USE_COREDATA
    RKManagedObjectStore *managedObjectStore = [RKManagedObjectStore defaultStore];
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Collection" inManagedObjectStore:managedObjectStore];
    
    // How to identify if the object we got is in database
    // Here, we identify by name. 
    mapping.identificationAttributes = @[@"name"];
    
    [mapping addConnectionForRelationship:@"database" connectedBy:@{@"databaseID": @"name"}];
#else
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:itemClass];
#endif
    [mapping addAttributeMappingsFromArray:@[@"name", @"count", @"indexCount", @"storageSize"]];
    [mapping addAttributeMappingsFromDictionary:@{@"@metadata.routing.parameters.databaseID": @"databaseID"}];

    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:itemsPath keyPath:nil statusCodes:statusCodes];
    [manager addResponseDescriptor:responseDescriptor];
    
    RKResponseDescriptor *emptyResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RKObjectMapping new] pathPattern:itemPath keyPath:nil statusCodes:statusCodes];
    [manager addResponseDescriptor:emptyResponseDescriptor];
    
    // Route for list of objects
    RKRoute *itemsRoute = [RKRoute routeWithName:@"collections" pathPattern:itemsPath method:RKRequestMethodGET];
    itemsRoute.shouldEscapePath = YES;

    // Route for creating a new object
    RKRoute *newItemRoute  = [RKRoute routeWithClass:itemClass pathPattern:itemsPath method:RKRequestMethodPOST];
    newItemRoute.shouldEscapePath = YES;

    // Route for manipulating with existing object
    RKRoute *itemRoute  = [RKRoute routeWithClass:itemClass pathPattern:itemPath method:RKRequestMethodAny];
    itemsRoute.shouldEscapePath = YES;

    // Add defined routes to the Object Manager router
    [manager.router.routeSet addRoutes:@[itemsRoute, newItemRoute, itemRoute]];

#ifdef USE_COREDATA
    // Deleating orphaned objects
    [manager addFetchRequestBlock:^NSFetchRequest *(NSURL *URL) {
        RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:itemsPath];
        
        NSDictionary *argsDict = nil;
        BOOL match = [pathMatcher matchesPath:[URL relativePath] tokenizeQueryStrings:NO parsedArguments:&argsDict];
        NSString *databaseID = nil;
        if (match) {
            databaseID = [argsDict objectForKey:@"databaseID"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"databaseID = %@", databaseID];
            NSFetchRequest *fetchRequest = [MCollection MR_requestAllSortedBy:@"name" ascending:YES withPredicate:predicate];
            return fetchRequest;
        }
        
        return nil;
    }];
#endif
    
}

- (void)setupDocumentMappings
{
    Class itemClass = [MDocument class];
    NSString *itemsPath = @"/databases/:databaseID/collections/:collectionID/documents";
    NSString *itemPath  = @"/databases/:databaseID/collections/:collectionID/documents/:documentID";
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping addAttributeMappingsFromArray:@[@"document"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:itemClass rootKeyPath:nil];
    [manager addRequestDescriptor:requestDescriptor];
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:itemClass];
    [mapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"rootDocument"]];
    
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:itemsPath keyPath:nil statusCodes:statusCodes];
    [manager addResponseDescriptor:responseDescriptor];
    
    RKResponseDescriptor *emptyResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RKObjectMapping new] pathPattern:itemPath keyPath:nil statusCodes:statusCodes];
    [manager addResponseDescriptor:emptyResponseDescriptor];
    
    RKRoute *itemsRoute = [RKRoute routeWithName:@"documents" pathPattern:itemsPath method:RKRequestMethodGET];
    itemsRoute.shouldEscapePath = YES;
    RKRoute *newItemRoute  = [RKRoute routeWithClass:itemClass pathPattern:itemsPath method:RKRequestMethodPOST];
    newItemRoute.shouldEscapePath = YES;
    RKRoute *itemRoute  = [RKRoute routeWithClass:itemClass pathPattern:itemPath method:RKRequestMethodAny];
    itemsRoute.shouldEscapePath = YES;
    
    [manager.router.routeSet addRoutes:@[itemsRoute, newItemRoute, itemRoute]];
}

#pragma mark - Helpers

- (void)saveApiKey {
    [[NSUserDefaults standardUserDefaults] setObject:self.apiKey forKey:@"apiKey"];
}

- (void)loadApiKey {
    self.apiKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKey"];
}

#pragma mark - Stub stuff

+ (void)stubRequestType:(NSString *)type uri:(NSString *)uri returnCode:(NSUInteger)code fixture:(NSString *)fixture {
#ifdef COCOAPODS_POD_AVAILABLE_Nocilla
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fixture ofType:@"json" inDirectory:@"fixtures"];
    NSString *body = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    stubRequest(type, uri).andReturn(code).
    withHeaders(@{@"Content-Type": @"application/json"}).withBody(body);
#endif
}

+ (void)stubGetRequest:(id)uri withFixture:(NSString *)fixtureName {
    [self stubRequestType:@"GET" uri:uri returnCode:200 fixture:fixtureName];
}

+ (void)stubGetRequest:(id)uri withFixtureFile:(NSString *)fixtureFile {
#ifdef COCOAPODS_POD_AVAILABLE_Nocilla
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fixtureFile ofType:nil inDirectory:@"fixtures"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    stubRequest(@"GET", uri).andReturn(200).withData(data);
#endif
}

- (void)mockHTTP
{
#ifdef COCOAPODS_POD_AVAILABLE_Nocilla
    [[LSNocilla sharedInstance] start];
    
    // Status
    [MongoHqApi stubGetRequest:@"http://status.mongohq.com/api/v1/services" withFixture:@"status_services"];
    [MongoHqApi stubGetRequest:@"^http://(.*?)tick-circle\.png".regex withFixtureFile:@"tick-circle.png"];
    
    // API
    [MongoHqApi stubGetRequest:@"^https://api.mongohq.com/databases?_apikey=(.*?)".regex withFixture:@"databases"];
#endif
}

@end
