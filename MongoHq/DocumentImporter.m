//
//  DocumentImporter.m
//  MongoHq
//
//  Created by Taras Kalapun on 6/7/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "DocumentImporter.h"

#import "MCollection.h"
#import "MDocument.h"

#import "CHCSVParser.h"

@interface DocumentImporter ()


@end

@implementation DocumentImporter

- (void)run
{
    if (!self.filePath) {
        self.filePath = [[NSBundle mainBundle] pathForResource:self.fileName ofType:nil];
        
        if (!self.filePath) return;
    }

    
    CHCSVParserOptions opts = CHCSVParserOptionsRecognizesBackslashesAsEscapes | CHCSVParserOptionsSanitizesFields;
    NSArray *parsedData = [NSArray arrayWithContentsOfCSVFile:self.filePath options:opts];
    
    NSMutableArray *documents = [NSMutableArray array];

    NSArray *headerNames = nil;
    NSMutableDictionary *dict = nil;
    
    BOOL first = YES;
    for (NSArray *arr in parsedData) {
        if (first) {
            headerNames = arr;
            dict = [[NSMutableDictionary alloc] initWithCapacity:headerNames.count];
            first = NO;
            continue;
        }
        
        
        for (int i=0; i<headerNames.count; i++) {
            dict[headerNames[i]] = arr[i];
        }
        
        MDocument *doc = [MDocument new];
        doc.databaseID = self.collection.databaseID;
        doc.collectionID = self.collection.collectionID;
        
        doc.document = [dict copy];
        
        
        [documents addObject:doc];
        
        //NSLog(@"obj: %@", dict);
        [dict removeAllObjects];
    }

    if (self.collection) {
        [self uploadDocuments:documents];
    } else {
        NSLog(@"Parsed thing: %@", documents);
    }
}

- (void)uploadDocuments:(NSArray *)docs
{
    // Enqueue a Batch of Object Request Operations
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    RKRoute *route = [manager.router.routeSet routeForClass:[MDocument class] method:RKRequestMethodPOST];
    
    [manager enqueueBatchOfObjectRequestOperationsWithRoute:route objects:docs progress:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        NSLog(@"Finished %d operations", numberOfFinishedOperations);
    } completion:^(NSArray *operations) {
        NSLog(@"All Documents Uploaded!");
    }];
}

@end
