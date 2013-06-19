//
//  DocumentImporter.h
//  MongoHq
//
//  Created by Taras Kalapun on 6/7/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCollection;
@class DocumentImporter;

@protocol DocumentImporterDelegate <NSObject>
@optional
- (void)documentImporterDidFinishImporting:(DocumentImporter *)importer;

@end

@interface DocumentImporter : NSObject

@property (nonatomic, weak) id <DocumentImporterDelegate> delegate;

@property (nonatomic, strong) MCollection *collection;

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *filePath;

- (void)run;
- (void)openFromViewController:(UIViewController *)controller;
- (void)openFileSelectorFromViewController:(UIViewController *)controller;

@end
