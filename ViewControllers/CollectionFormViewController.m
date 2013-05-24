//
//  NewCollectionViewController.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/24/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "CollectionFormViewController.h"
#import "SVProgressHUD.h"
#import "MDatabase.h"
#import "MPlan.h"
#import "MCollection.h"

@interface CollectionFormViewController ()

@end

@implementation CollectionFormViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    

    self.path = RKPathFromPatternWithObject(@"/databases/:databaseID/collections", self.database);

    if (self.collection) {
        NSDictionary *pathParams = @{
         @"databaseID": self.database.databaseID,
         @"collectionID": RKPercentEscapedQueryStringFromStringWithEncoding(self.collection.collectionID, NSUTF8StringEncoding)};

        self.itemPath = RKPathFromPatternWithObject(@"/databases/:databaseID/collections/:collectionID", pathParams);
    }
    
    
    if (self.itemIsNew) self.collection = [MCollection new];
    
    QSection *section = [[QSection alloc] initWithTitle:self.title];
    QEntryElement *nameEntry = [[QEntryElement alloc] initWithTitle:@"Name" Value:self.collection.name Placeholder:@"collection name"];
    nameEntry.bind = @"textValue:name";
    [section addElement:nameEntry];
    
    
    [self.root addSection:section];
    if (!self.itemIsNew) [self.root addSection:[self deleteButtonSection]];
    
    [self updateQuickDialogView];
}

- (id)item {
    return self.collection;
}

- (void)setItem:(id)item {
    self.collection = item;
}

- (BOOL)validateItem {
    if (self.collection.name.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Missing data" message:@"Plase fill the data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    return YES;
}

@end
