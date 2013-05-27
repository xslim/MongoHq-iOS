//
//  GenericTableViewController.h
//  MongoHq
//
//  Created by Taras Kalapun on 5/23/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ISRefreshControl.h"
#import "SVProgressHUD.h"
#import "PresentingViewControllerDelegate.h"

@interface GenericTableViewController : UITableViewController <PresentingViewControllerDelegate>

// Property to hold our loaded objects
@property (nonatomic, strong) NSArray *items;

// Path to use for loading the remote objects
@property (nonatomic, strong) NSString *path;

// Possible parameters for a request
@property (nonatomic, strong) NSDictionary *parameters;

@property (nonatomic, strong) NSString *routeName;
@property (nonatomic, strong) id routeObject;

// Methods to re-use / override
- (void)refresh;
- (void)willStartLoading;
- (void)finishedLoadingWithItems:(NSArray *)newItems;
- (void)finishedLoadingWithError:(NSError *)error;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (IBAction)createNewItem:(id)sender;

- (BOOL)apiKeyExists;

@end
