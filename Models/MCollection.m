//
//  MCollection.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/23/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "MCollection.h"

@implementation MCollection


- (NSString *)subtitleText
{
    return [NSString stringWithFormat:@"count: %@, indexCount: %@, storageSize: %@",
            self.count, self.indexCount, self.storageSize];
}

- (NSString *)collectionID
{
    return self.name;
}

@end
