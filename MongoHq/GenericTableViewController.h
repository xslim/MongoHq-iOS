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

@interface GenericTableViewController : UITableViewController

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSArray *items;

- (void)refresh;
- (void)startLoading;
- (void)loadedItems:(NSArray *)newItems;
- (void)loadedWithError:(NSError *)error;

@end
