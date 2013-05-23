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
#import "NewDatabaseViewController.h"

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
}

- (void)displayNewDatabaseFormWithPlans:(NSArray *)plans {
    
    NSMutableDictionary *plansDict = [NSMutableDictionary dictionaryWithCapacity:[plans count]];
    for (MPlan *plan in plans) {
        [plansDict setObject:plan.selectName forKey:plan.slug];
    }
    
    MDatabase *newDatabase = [[MDatabase alloc] init];
    
    QRootElement *root = [[QRootElement alloc] init];
    root.title = @"New Database";
    root.grouped = YES;
    
    QSection *section = [[QSection alloc] initWithTitle:@"Create new Database"];
    QEntryElement *nameEntry = [[QEntryElement alloc] initWithTitle:@"Name" Value:nil Placeholder:@"my_new_database"];
    nameEntry.bind = @"textValue:name";
    [section addElement:nameEntry];
    
    
    QRadioElement *planEntry = [[QRadioElement alloc] initWithDict:plansDict selected:0 title:@"Plans"];
    planEntry.bind = @"textValue:plan";
    [section addElement:planEntry];
    
    [root addSection:section];
    
    UINavigationController *nc = [QuickDialogController controllerWithNavigationForRoot:root];
    
    [self.navigationController presentViewController:nc animated:YES completion:nil];
}

- (IBAction)createNewItem:(id)sender
{

    NewDatabaseViewController *vc = [[NewDatabaseViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
