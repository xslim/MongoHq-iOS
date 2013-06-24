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
#import "UIImage+FontIcon.h"
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

// For CoreData

// Assign YES to start using CoreData
@property (nonatomic, assign) BOOL useCoreData;

// Class of objects that are shown in table
@property (nonatomic, assign) Class objectClass;

// How to sort objects
@property (nonatomic, strong) NSString *sortBy;

// Grouping
@property (nonatomic, strong) NSString *groupBy;

// Predicate for fetch (filtering)
@property (nonatomic, strong) NSPredicate *fetchPredicate;

// Fetched results controller to interact with data
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

// Methods to re-use / override
- (void)refresh;
- (BOOL)shouldStartLoading;
- (void)willStartLoading;
- (void)finishedLoadingWithItems:(NSArray *)newItems;
- (void)finishedLoadingWithError:(NSError *)error;

- (void)constructFetchedResultsController;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)presentCreateOrEditFormForObject:(id)item;
- (IBAction)createNewItem:(id)sender;

- (BOOL)apiKeyExists;

@end
