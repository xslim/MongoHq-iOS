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

- (id)init
{
    self = [super init];
    if (self) {
#ifdef USE_COREDATA
        self.useCoreData = YES;
        self.objectClass = [MCollection class];
#endif
    }
    return self;
}

- (void)viewDidLoad
{
    //self.path = RKPathFromPatternWithObject(@"/databases/:databaseID/collections", self.database);
    
    self.routeName = @"collections";
    self.routeObject = self.database;

#ifdef USE_COREDATA
    // Specify predicate to filter collections
    self.fetchPredicate = [NSPredicate predicateWithFormat:@"databaseID = %@", self.database.databaseID];
#endif
    
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentCreateOrEditFormForObject:(id)item
{
    CollectionFormViewController *vc = [[CollectionFormViewController alloc] init];
    vc.delegate = self;
    vc.database = self.database;
    vc.collection = item;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentModalViewController:nc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCollection *collection = [self itemAtIndexPath:indexPath];
    DocumentsViewController *vc = [[DocumentsViewController alloc] init];
    vc.title = collection.name;
    vc.database = self.database;
    vc.collection = collection;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
