//
//  DocumentImporter.m
//  MongoHq
//
//  Created by Taras Kalapun on 6/7/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "DocumentImporter.h"
#import "FileSelectorViewController.h"
#import "SVProgressHUD.h"

#import "MCollection.h"
#import "MDocument.h"

#import "CHCSVParser.h"

@interface DocumentImporter () <FileSelectorDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) FileSelectorViewController *fileSelector;
@property (nonatomic, strong) NSArray *documentsToImport;
@end

@implementation DocumentImporter

- (void)openFromViewController:(UIViewController *)controller
{
    [self openFileSelectorFromViewController:controller];
}

- (void)openFileSelectorFromViewController:(UIViewController *)controller
{
    FileSelectorViewController *vc = [[FileSelectorViewController alloc] init];
    vc.ext = @"csv";
    self.fileSelector = vc;
    self.fileSelector.delegate = self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [controller presentViewController:nc animated:YES completion:nil];
}

- (void)startImporting
{
    [SVProgressHUD show];
}

- (void)finishImporting
{
    [SVProgressHUD showSuccessWithStatus:nil];
    [self.fileSelector dismissViewControllerAnimated:YES completion:nil];
    self.fileSelector = nil;
    
    if ([self.delegate respondsToSelector:@selector(documentImporterDidFinishImporting:)]) {
        [self.delegate documentImporterDidFinishImporting:self];
    }
}

- (void)importingProgress:(CGFloat)progress
{
    [SVProgressHUD showProgress:progress];
}

- (void)run
{
    if (!self.filePath) {
        self.filePath = [[NSBundle mainBundle] pathForResource:self.fileName ofType:nil];
        
        if (!self.filePath) return;
    }
    
    self.documentsToImport = nil;

    [self importingProgress:0.0f];
    
    CHCSVParserOptions opts = CHCSVParserOptionsRecognizesBackslashesAsEscapes | CHCSVParserOptionsSanitizesFields;
    NSArray *parsedData = [NSArray arrayWithContentsOfCSVFile:self.filePath options:opts];
    
    NSMutableArray *documents = [NSMutableArray array];

    NSArray *headerNames = nil;
    NSMutableDictionary *dict = nil;
    
    NSUInteger dataCount = [parsedData count];
    int currentData = 0;
    
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
        
        [self importingProgress:((CGFloat)currentData / (CGFloat)dataCount)];
        
        //NSLog(@"obj: %@", dict);
        [dict removeAllObjects];
        currentData++;
    }
    [self importingProgress:1.0f];
    
    self.documentsToImport = documents;

    if (self.collection) {
        NSString *msg = [NSString stringWithFormat:@"Import %i entries?", [documents count]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Importer" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Import", nil];
        [alert show];
        
    } else {
        NSLog(@"Parsed thing: %@", documents);
    }
}

- (void)uploadDocuments:(NSArray *)docs
{
    [self importingProgress:0.0f];
    
    // Enqueue a Batch of Object Request Operations
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    // A route to be used for every single operation
    RKRoute *route = [manager.router.routeSet routeForClass:[MDocument class] method:RKRequestMethodPOST];
    
    __weak DocumentImporter *weakSelf = self;
    
    [manager enqueueBatchOfObjectRequestOperationsWithRoute:route objects:docs progress:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        NSLog(@"Finished %d operations", numberOfFinishedOperations);
        
        // Show some progress HUD
        CGFloat progress = ((CGFloat)numberOfFinishedOperations / (CGFloat)totalNumberOfOperations);
        [SVProgressHUD showProgress:progress];
        
        //[weakSelf importingProgress:progress];
    } completion:^(NSArray *operations) {
        NSLog(@"All Documents Uploaded!");
        [weakSelf importingProgress:1.0f];
        [weakSelf finishImporting];
    }];
}

#pragma mark - FileSelector

- (void)fileSelector:(FileSelectorViewController *)fileSelector didSelectFile:(NSString *)filePath
{
    //[fileSelector dismissViewControllerAnimated:YES completion:nil];
    self.filePath = filePath;
    [self run];
}

- (void)fileSelectorDidCancel:(FileSelectorViewController *)fileSelector
{
    [fileSelector dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Alert

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [SVProgressHUD dismiss];
    if (buttonIndex == 0) {
        return;
    }
    
    [self uploadDocuments:self.documentsToImport];
}

@end
