//
//  FileSelectorViewController.h
//  MongoHq
//
//  Created by Taras Kalapun on 19/06/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FileSelectorViewController;

@protocol FileSelectorDelegate <NSObject>

- (void)fileSelector:(FileSelectorViewController *)fileSelector didSelectFile:(NSString *)filePath;
- (void)fileSelectorDidCancel:(FileSelectorViewController *)fileSelector;

@end

@interface FileSelectorViewController : UITableViewController

@property (nonatomic, assign) id <FileSelectorDelegate> delegate;

@property (nonatomic, strong) NSString *rootPath;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) NSString *ext;
@property (nonatomic, strong) NSPredicate *predicate;

@end
