//
//  DocumentFormViewController.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/24/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "DocumentFormViewController.h"

@interface DocumentFormViewController ()

@end

@implementation DocumentFormViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    
    NSDictionary *postParams = @{@"databaseID": self.database.databaseID,
                                 @"collectionID": self.collection.collectionID};
    
    self.postPath = RKPathFromPatternWithObject(@"/databases/:databaseID/collections/:collectionID/documents", postParams);
    
    if (self.document) {
        NSDictionary *putParams = @{@"databaseID": self.database.databaseID,
                                    @"collectionID": self.collection.collectionID,
                                    @"documentID": self.document.documentID
                                    };
        
        self.putPath = RKPathFromPatternWithObject(@"/databases/:databaseID/collections/:collectionID/documents/:documentID", putParams);
    }
    
    
    if (self.itemIsNew) self.document = [MDocument new];
    
    QSection *section = [[QSection alloc] initWithTitle:self.title];
    
    if (self.document.documentID)
        [section addElement:[[QLabelElement alloc] initWithTitle:@"id" Value:self.document.documentID]];
    
    QMultilineElement *textEntry = [[QMultilineElement alloc] initWithTitle:@"document" value:self.document.documentString];
    textEntry.bind = @"textValue:documentString";
    [section addElement:textEntry];
    
    
    [self.root addSection:section];
    
    [self updateQuickDialogView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)item {
    return self.document;
}

- (void)setItem:(id)item {
    self.document = item;
}

@end
