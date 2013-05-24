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

    
    if (self.itemIsNew) self.document = [MDocument new];
    
    // Presetting relation info for Class Routes
    self.document.databaseID = self.database.databaseID;
    self.document.collectionID = self.collection.collectionID;
    
    QSection *section = [[QSection alloc] initWithTitle:self.title];
    
    if (self.document.documentID)
        [section addElement:[[QLabelElement alloc] initWithTitle:@"id" Value:self.document.documentID]];
    
    QMultilineElement *textEntry = [[QMultilineElement alloc] initWithTitle:@"document" value:self.document.documentString];
    textEntry.bind = @"textValue:documentString";
    [section addElement:textEntry];
    
    
    [self.root addSection:section];
    if (!self.itemIsNew) [self.root addSection:[self deleteButtonSection]];
    
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
