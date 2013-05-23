//
//  MPlan.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/23/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "MPlan.h"

@implementation MPlan

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ (%@) - %@: %@", self.name, self.slug, self.type, self.price];
}

- (NSString *)subtitleText
{
    return [NSString stringWithFormat:@"%@ - %@", self.type, self.price];;
}

- (NSString *)selectName
{
    return [NSString stringWithFormat:@"%@ - $%@", self.name, self.price];;
}

- (void)setIndex:(NSNumber *)index {
    _index = index;
    NSLog(@"setting index %@ for %@", index, self.name);
}

- (void)setHeaders:(NSDictionary *)headers {
    _headers = headers;
    NSLog(@"headers %@", headers);
}

@end
