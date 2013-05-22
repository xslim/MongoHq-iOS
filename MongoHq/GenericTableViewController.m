//
//  GenericTableViewController.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/23/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "GenericTableViewController.h"

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
    [super viewDidLoad];

    self.refreshControl = (id)[[ISRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    
    if (!self.items) [self refresh];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)refresh {
    [self startLoading];
    RKObjectManager *manager = [AppController shared].objectManager;
    [manager getObjectsAtPath:self.path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self loadedItems:[mappingResult array]];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self loadedWithError:error];
    }];
}

- (void)startLoading
{
    [SVProgressHUD showWithStatus:@"Loading"];
}

- (void)loadedItems:(NSArray *)newItems
{
    self.items = newItems;
    //NSLog(@"Loaded items: %@", self.items);
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    [SVProgressHUD showSuccessWithStatus:nil];
}

- (void)loadedWithError:(NSError *)error
{
    NSLog(@"Error on loading: %@", error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
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

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSObject *item = [self.items objectAtIndex:indexPath.row];
    
    if ([item respondsToSelector:@selector(titleText)]) {
        cell.textLabel.text = [item performSelector:@selector(titleText)];
    } else if ([item respondsToSelector:@selector(name)]) {
        cell.textLabel.text = [item performSelector:@selector(name)];
    }
    
    if ([item respondsToSelector:@selector(subtitleText)]) {
        cell.detailTextLabel.text = [item performSelector:@selector(subtitleText)];
    } else if ([item respondsToSelector:@selector(descriptionText)]) {
        cell.detailTextLabel.text = [item performSelector:@selector(descriptionText)];
    }
    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
