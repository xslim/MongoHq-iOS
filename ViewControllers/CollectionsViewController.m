//
//  CollectionsViewController.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/23/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "CollectionsViewController.h"


@interface CollectionsViewController ()

@end

@implementation CollectionsViewController


- (void)viewDidLoad
{
    self.path = RKPathFromPatternWithObject(@"/databases/:databaseID/collections", self.database);
    
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createNewItem:(id)sender
{
    
}

@end
