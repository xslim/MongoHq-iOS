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
        // Configure the controller
#ifdef USE_COREDATA
        self.useCoreData = YES;
        self.objectClass = [MDatabase class];
#endif
        self.path = @"/databases";
        self.title = @"Databases";
        self.tabBarItem.image = [UIImage fi_imageIcon:@"Entypo/database" size:(CGSize){30,30} color:[UIColor blackColor]];
    }
    return self;
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
    MDatabase *db = [self itemAtIndexPath:indexPath];
    CollectionsViewController *vc = [[CollectionsViewController alloc] init];
    vc.title = db.name;
    vc.database = db;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
