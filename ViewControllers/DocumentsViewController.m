//
//  DocumentsViewController.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/24/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "DocumentsViewController.h"
#import "DocumentViewController.h"
#import "DocumentFormViewController.h"

@interface DocumentsViewController ()

@end

@implementation DocumentsViewController

- (void)viewDidLoad
{
    NSDictionary *pathParams = @{@"databaseID": self.database.databaseID,
                                 @"collectionID": self.collection.collectionID};
    
    self.path = RKPathFromPatternWithObject(@"/databases/:databaseID/collections/:collectionID/documents", pathParams);
    
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)createNewItem:(id)sender
{
    DocumentFormViewController *vc = [[DocumentFormViewController alloc] init];
    vc.delegate = self;
    vc.database = self.database;
    vc.collection = self.collection;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentModalViewController:nc animated:YES];
}

- (void)editItemAtIndexPath:(NSIndexPath *)indexPath
{
    DocumentFormViewController *vc = [[DocumentFormViewController alloc] init];
    vc.delegate = self;
    vc.database = self.database;
    vc.collection = self.collection;
    vc.document = [self.items objectAtIndex:indexPath.row];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentModalViewController:nc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDocument *doc = [self.items objectAtIndex:indexPath.row];
    DocumentViewController *vc = [[DocumentViewController alloc] init];
    vc.title = doc.documentID;
    vc.document = doc;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
