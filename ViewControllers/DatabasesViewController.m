//
//  DatabasesViewController.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/22/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "DatabasesViewController.h"
#import "PlansViewController.h"
#import "CollectionsViewController.h"
#import "MDatabase.h"
#import "MPlan.h"
#import "DatabaseFormViewController.h"

@interface DatabasesViewController ()

@end

@implementation DatabasesViewController


- (id)init
{
    self = [super init];
    if (self) {
        self.path = @"/databases";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Databases";
}

- (IBAction)createNewItem:(id)sender
{

    DatabaseFormViewController *vc = [[DatabaseFormViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nc animated:YES completion:nil];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDatabase *db = [self.items objectAtIndex:indexPath.row];
    CollectionsViewController *vc = [[CollectionsViewController alloc] init];
    vc.title = db.name;
    vc.database = db;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
