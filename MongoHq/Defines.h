//
//  Defines.h
//  MongoHq
//
//  Created by Taras Kalapun on 6/6/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#define USE_COREDATA 1
#define USE_DOCUMENT_PAGINATION 0

static NSString * const kTestFlightTeamToken = @"";
static NSString * const kMongoHqApiKey = @"picpjs6mxl2sx1dmc6so";
static NSUInteger const kMongoHqDocumentsPerPage = 20;

/*
 NSUInteger DeviceSystemMajorVersion();
 NSUInteger DeviceSystemMajorVersion() {
 static NSUInteger _deviceSystemMajorVersion = -1;
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
 _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
 });
 return _deviceSystemMajorVersion;
 }
 
 #define MY_MACRO_NAME (DeviceSystemMajorVersion() < 7)
*/