//
//  StatusViewController.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/1/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "StatusViewController.h"
#import "StatusItem.h"
#import "DetailStatusViewController.h"

@interface StatusViewController ()

@end

@implementation StatusViewController

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
    
    
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)refresh
{
    [self refreshOld];
}

- (void)refreshOld
{
    // Simple sample of code to get started
    
    [SVProgressHUD showWithStatus:@"Loading"];
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[StatusItem class]];
    [mapping addAttributeMappingsFromDictionary:@{
     @"name" : @"name",
     @"description" : @"itemDescription",
     @"current-event.status.name" : @"statusName",
     @"current-event.status.image" : @"imageUrl",
     @"current-event.timestamp" : @"timestamp",
     @"current-event.message" : @"eventMessage",
     }];
    
    // Define the response mapping
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:@"/api/v1/services" keyPath:@"services" statusCodes:statusCodes];
    
    // Prepare the request operation
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://status.mongohq.com/api/v1/services"]];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        self.items = [result array];
        //NSLog(@"Loaded items: %@", self.items);
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        [SVProgressHUD showSuccessWithStatus:nil];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
        
        [self.refreshControl endRefreshing];
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
    [operation start]; //Fire the request

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    StatusItem *item = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.titleText;
    cell.detailTextLabel.text = item.subtitleText;

    if (item.imageUrl) {
        [cell.imageView setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:[StatusItem placeholderImage]];
    } else {
        cell.imageView.image = [StatusItem placeholderImage];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailStatusViewController *detailViewController = [[DetailStatusViewController alloc] init];
    detailViewController.item = [self.items objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
