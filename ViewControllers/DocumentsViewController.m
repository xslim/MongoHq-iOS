//
//  DocumentsViewController.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/24/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "DocumentsViewController.h"
#import "DocumentViewController.h"
#import "DocumentFormViewController.h"
#import "DocumentImporter.h"

@interface DocumentsViewController () <DocumentImporterDelegate, UIAlertViewDelegate>

// Or ARC will kick it
@property (nonatomic, strong) DocumentImporter *importer;
@property (nonatomic, assign) BOOL userAgreedOnLoading;

#if USE_DOCUMENT_PAGINATION
@property (nonatomic, strong) RKPaginator *documentsPaginator;
#endif

@end

@implementation DocumentsViewController

- (void)viewDidLoad
{
    self.userAgreedOnLoading = NO;
    self.routeName = @"documents";
    self.routeObject = @{@"databaseID": self.database.databaseID,
                         @"collectionID": self.collection.collectionID};

#if USE_DOCUMENT_PAGINATION
    RKObjectManager *manager = [RKObjectManager sharedManager];
    NSURL *url = [manager.router URLForRouteNamed:self.routeName method:RKRequestMethodGET object:self.routeObject];
    NSString *itemsPath = url.path;
    NSString *paginatorPath = [itemsPath stringByAppendingString:@"?skip=:offset&limit=:perPage"];
    RKPaginator *paginator = [manager paginatorWithPathPattern:paginatorPath];
    paginator.perPage = kMongoHqDocumentsPerPage;
    
    [paginator setCompletionBlockWithSuccess:^(RKPaginator *paginator, NSArray *objects, NSUInteger page) {
        [self finishedLoadingWithItems:objects];
    } failure:^(RKPaginator *paginator, NSError *error) {
        [self finishedLoadingWithError:error];
    }];
    
    self.documentsPaginator = paginator;
#endif
    
    //self.path = RKPathFromPatternWithObject(@"/databases/:databaseID/collections/:collectionID/documents", pathParams);
    
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#if USE_DOCUMENT_PAGINATION
- (void)refresh
{
    // If refreshed from editing mode, switch to normal
    
    if (![self shouldStartLoading]) {
        return;
    }
    
    [self willStartLoading];
    
    [self.documentsPaginator loadPage:1];
    
    [self setEditing:NO animated:NO];
}

- (IBAction)loadPrevPage:(id)sender
{
    [self.documentsPaginator loadPreviousPage];
}

- (IBAction)loadNextPage:(id)sender
{
    [self.documentsPaginator loadNextPage];
}
#endif

- (BOOL)shouldStartLoading {
    
    if (self.userAgreedOnLoading) {
        return YES;
    }
    
    AFHTTPClient *client = [RKObjectManager sharedManager].HTTPClient;
    if (client.networkReachabilityStatus != AFNetworkReachabilityStatusReachableViaWiFi) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not a WiFi connection" message:@"Your internet seems to be on a cellular. Are you sure you want to load Documents?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Load", nil];
        alert.tag = 1002; // extra check
        [alert show];
        return NO;
    } else {
        return YES;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag != 1002) {
        return;
    }
    
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (buttonIndex == 1) {
        self.userAgreedOnLoading = YES;
        [self refresh];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing) {
        NSArray *toolbarItems = @[
                                  [[UIBarButtonItem alloc] initWithTitle:@"Import" style:UIBarButtonItemStyleBordered target:self action:@selector(importItems:)]
                                  ];
        
        
        [self setToolbarItems:toolbarItems animated:NO];
        [self.navigationController setToolbarHidden:NO animated:YES];
    } else {
#if USE_DOCUMENT_PAGINATION
        NSString *pagesString = [NSString stringWithFormat:@"%i / %i",
                                 self.documentsPaginator.currentPage,
                                 self.documentsPaginator.pageCount];
        NSArray *toolbarItems = @[
                                  [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStyleBordered target:self action:@selector(loadPrevPage:)],
                                  [[UIBarButtonItem alloc] initWithTitle:pagesString style:UIBarButtonItemStylePlain target:nil action:nil],
                                  [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStyleBordered target:self action:@selector(loadNextPage:)]
                                  ];
        
        
        [self setToolbarItems:toolbarItems animated:NO];
        [self.navigationController setToolbarHidden:NO animated:YES];
#else
        [self.navigationController setToolbarHidden:YES animated:NO];
#endif
    }
    
}

- (IBAction)createNewItem:(id)sender
{
    DocumentFormViewController *vc = [[DocumentFormViewController alloc] init];
    vc.delegate = self;
    vc.database = self.database;
    vc.collection = self.collection;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nc animated:YES completion:nil];
}

- (IBAction)importItems:(id)sender
{
    if (!self.importer) {
        self.importer = [[DocumentImporter alloc] init];
        self.importer.collection = self.collection;
        self.importer.delegate = self;
    }
    
    [self.importer openFromViewController:self.navigationController];
}

- (void)editItemAtIndexPath:(NSIndexPath *)indexPath
{
    DocumentFormViewController *vc = [[DocumentFormViewController alloc] init];
    vc.delegate = self;
    vc.database = self.database;
    vc.collection = self.collection;
    vc.document = (self.items)[indexPath.row];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nc animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDocument *doc = [self itemAtIndexPath:indexPath];
    DocumentViewController *vc = [[DocumentViewController alloc] init];
    vc.title = doc.documentID;
    vc.document = doc;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)documentImporterDidFinishImporting:(DocumentImporter *)importer
{
    [self setEditing:NO animated:YES];
    self.importer = nil;
    [self refresh];
}

@end
