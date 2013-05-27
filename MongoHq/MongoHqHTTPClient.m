//
//  MongoHqHTTPClient.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/22/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "MongoHqHTTPClient.h"
#import "MongoHqApi.h"

@implementation MongoHqHTTPClient

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
{
    NSString *apiKey = [MongoHqApi shared].apiKey;
    if (apiKey) {
        path = [path stringByAppendingFormat:@"?_apikey=%@", apiKey];
    }
    
    return [super requestWithMethod:method path:path parameters:parameters];
}

@end
