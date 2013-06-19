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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.tabBarItem.image = [UIImage fi_imageIcon:@"Entypo/database" size:(CGSize){30,30} color:[UIColor blackColor]];
        self.title = NSLocalizedString(@"Databases", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    
#if USE_COREDATA
    self.useCoreData = YES;
    self.objectClass = [MDatabase class];
#endif
    self.path = @"/databases";
    
    
    [super viewDidLoad];
}

- (IBAction)createNewItem:(id)sender
{
    DatabaseFormViewController *vc = [[DatabaseFormViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nc animated:YES completion:nil];
}

#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"DrillDown"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MDatabase *db = [self itemAtIndexPath:indexPath];
        
        CollectionsViewController *vc = [segue destinationViewController];
        vc.title = db.name;
        vc.database = db;
    }
}

@end
