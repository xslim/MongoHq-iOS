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

#ifdef COCOAPODS_POD_AVAILABLE_RestKit_Search
#import "RestKit/Search.h"
#endif

@interface CollectionsViewController () <UISearchBarDelegate>

@end

@implementation CollectionsViewController

- (id)init
{
    self = [super init];
    if (self) {
#if USE_COREDATA
        self.useCoreData = YES;
        self.objectClass = [MCollection class];
#endif
    }
    return self;
}

- (void)viewDidLoad
{
    //self.path = RKPathFromPatternWithObject(@"/databases/:databaseID/collections", self.database);
    
#ifdef COCOAPODS_POD_AVAILABLE_RestKit_Search
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
    [searchBar sizeToFit];
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    
    // iOS7
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
#endif
    
    self.routeName = @"collections";
    self.routeObject = self.database;

#if USE_COREDATA
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

#pragma mark - Search

- (void)searchWithText:(NSString *)textToSearch
{
#ifdef COCOAPODS_POD_AVAILABLE_RestKit_Search
    
    // The filtering predicate
    NSPredicate *parentPredicate = [NSPredicate predicateWithFormat:@"databaseID = %@", self.database.databaseID];
    
    /*
     Construct the predicate.
     Supported predicate types are NSNotPredicateType, NSAndPredicateType, and NSOrPredicateType.
     */
    NSCompoundPredicateType type = NSAndPredicateType;
    NSCompoundPredicate *searchPredicate = (id)[RKSearchPredicate searchPredicateWithText:textToSearch type:type];
    
    // Create mutable copy of sub-predicates
    // To add our filtering predicate to it
    NSMutableArray *subpredicates = [searchPredicate.subpredicates mutableCopy];
    [subpredicates addObject:parentPredicate];
    
    // Assign it to our fetchPredicate, which is used by Fetched Results Controlle
    self.fetchPredicate = [[NSCompoundPredicate alloc] initWithType:type subpredicates:subpredicates];
    
    // Reconstruct the Fetched Results Controlle
    // Perform the fetch and reload the data in table
    [self constructFetchedResultsController];
    [self.tableView reloadData];
#endif
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    [searchBar resignFirstResponder];
    
    NSString *textToSearch = searchBar.text;
    
    [self searchWithText:textToSearch];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if (searchText.length != 0) {
        return;
    }
    
    // reset
    NSPredicate *parentPredicate = [NSPredicate predicateWithFormat:@"databaseID = %@", self.database.databaseID];
    self.fetchPredicate = parentPredicate;
    [self constructFetchedResultsController];
    [self.tableView reloadData];
    
    if ([searchText length] == 0) {
        [self performSelector:@selector(hideKeyboardWithSearchBar:) withObject:searchBar afterDelay:0];
    }
    
}

- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

@end
