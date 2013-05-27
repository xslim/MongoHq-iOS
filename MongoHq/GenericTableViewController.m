//
//  GenericTableViewController.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/23/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "GenericTableViewController.h"
#import "ApiKeyViewController.h"

@interface GenericTableViewController ()

@end

@implementation GenericTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    // Pull to refresh control
    self.refreshControl = (id)[[ISRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    
    // Load items on initial start
    if (!self.items) [self refresh];
    
    // Preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
 
    // Display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)presentApiKeyEntry {
    ApiKeyViewController *vc = [[ApiKeyViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nc animated:YES completion:nil];
}

- (BOOL)apiKeyExists {
    if ([MongoHqApi shared].apiKey) return YES;
    
    [self presentApiKeyEntry];
    
    return NO;
}

- (void)refresh
{    
    if (![self apiKeyExists]) {
        return;
    }
    
    // If refreshed from editing mode, switch to normal
    [self setEditing:NO animated:NO];
    
    [self willStartLoading];
    
    // Get the object manager
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    if (self.routeName) {
        
        [manager getObjectsAtPathForRouteNamed:self.routeName object:self.routeObject parameters:self.parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [self finishedLoadingWithItems:[mappingResult array]];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            // hack
            int code = [[[operation HTTPRequestOperation] response] statusCode];
            if (code == 401) {
                [self presentApiKeyEntry];
            }
            
            [self finishedLoadingWithError:error];
        }];
        
        return;
    }
    
    [manager getObjectsAtPath:self.path parameters:self.parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self finishedLoadingWithItems:[mappingResult array]];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        // hack
        int code = [[[operation HTTPRequestOperation] response] statusCode];
        if (code == 401) {
            [self presentApiKeyEntry];
        }
        
        [self finishedLoadingWithError:error];
    }];
}

- (void)willStartLoading
{
    // Toggle "Pull to refresh" to show Activity indicator
    [self.refreshControl beginRefreshing];
    
    // Show a "Loading" HUD to the user
    [SVProgressHUD showWithStatus:@"Loading"];
}

- (void)finishedLoadingWithItems:(NSArray *)newItems
{
    // Update the current items with new one
    self.items = newItems;
    NSLog(@"Loaded items: %@", self.items);
    
    // Reload table view
    [self.tableView reloadData];
    
    // Hide loading indicators
    [self.refreshControl endRefreshing];
    [SVProgressHUD dismiss];
}

- (void)finishedLoadingWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    NSLog(@"Error on loading: %@", error);
    
    // Show some Alert with error description
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)createNewItem:(id)sender
{
    NSLog(@"createNewItem:");
}

- (void)editItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{    
    [super setEditing:editing animated:animated];
    
    if (editing) {
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewItem:)];
        self.navigationItem.leftBarButtonItem = btn;
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

#pragma mark - PresentingViewControllerDelegate

- (void)presentedViewControllerDidDone:(UIViewController *)viewController {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self refresh];
}

- (void)presentedViewControllerDidCancel:(UIViewController *)viewController {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSObject *item = [self.items objectAtIndex:indexPath.row];
    
    // Assume, that every item has a 'titleText' and 'subtitleText' getters
    cell.textLabel.text = [item performSelector:@selector(titleText)];
    cell.detailTextLabel.text = [item performSelector:@selector(subtitleText)];
    
    // If the's an imageUrl...
    if ([item respondsToSelector:@selector(imageUrl)]) {
        NSString *imageUrl = [item performSelector:@selector(imageUrl)];
        UIImage *placeholderImage = ([item respondsToSelector:@selector(placeholderImage)]) ? [item performSelector:@selector(placeholderImage)] : nil;
        if (imageUrl) {
            [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholderImage];
        } else {
            cell.imageView.image = placeholderImage;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    } 
     */
    
    NSObject *item = [self.items objectAtIndex:indexPath.row];
    
    [SVProgressHUD showWithStatus:@"Deleting..."];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager deleteObject:item path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self refresh];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self finishedLoadingWithError:error];
    }];
    
}


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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableView.editing) return;
    
    [self editItemAtIndexPath:indexPath];
}

@end
