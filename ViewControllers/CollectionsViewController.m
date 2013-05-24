//
//  CollectionsViewController.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/23/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "CollectionsViewController.h"
#import "CollectionFormViewController.h"
#import "DocumentsViewController.h"

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
    CollectionFormViewController *vc = [[CollectionFormViewController alloc] init];
    vc.delegate = self;
    vc.database = self.database;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentModalViewController:nc animated:YES];
}

- (void)editItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionFormViewController *vc = [[CollectionFormViewController alloc] init];
    vc.delegate = self;
    vc.database = self.database;
    vc.collection = [self.items objectAtIndex:indexPath.row];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentModalViewController:nc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCollection *collection = [self.items objectAtIndex:indexPath.row];
    DocumentsViewController *vc = [[DocumentsViewController alloc] init];
    vc.title = collection.name;
    vc.database = self.database;
    vc.collection = collection;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
