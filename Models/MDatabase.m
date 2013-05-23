//
//  MDatabase.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/22/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "MDatabase.h"

@implementation MDatabase

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ on %@ @ %@:%@", self.name, self.plan, self.hostname, self.port];
}

- (NSString *)subtitleText
{
    return self.plan;
}

- (NSString *)databaseID
{
    return self.name;
}

@end
