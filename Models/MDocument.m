//
//  MDocument.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/24/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "MDocument.h"

@implementation MDocument

- (NSString *)titleText {
    return self.documentID;
}

- (NSString *)description {
    return (self.titleText) ? self.titleText : self.documentString;
}

- (NSString *)documentString
{
    if (!self.document) return nil;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.document
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}

- (void)setDocumentString:(NSString *)documentString
{
    NSError *error = nil;
    NSData *JSONData = [documentString dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:&error];
    
    if (!jsonObject) {
        NSLog(@"Error parsing JSON: %@", error);
    } else if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        self.document = jsonObject;
    } else {
        NSLog(@"Wrong json - not an NSDictionary");
    }
}

- (void)setRootDocument:(NSDictionary *)rootDocument {

    if (!rootDocument) return;
    
    // Extract document _id
    id idObj = rootDocument[@"_id"];
    if ([idObj isKindOfClass:[NSString class]]) {
        self.documentID = idObj;
    } else if ([idObj isKindOfClass:[NSDictionary class]]) {
        static NSString *oidKey = @"$oid";
        self.documentID = ((NSDictionary *)idObj)[oidKey];
    }
    
    // Remove _id from document
    NSMutableDictionary *dict = [rootDocument mutableCopy];
    [dict removeObjectForKey:@"_id"];
    self.document = dict;
}


@end
