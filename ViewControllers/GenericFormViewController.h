//
//  GenericFormViewController.h
//  MongoHq
//
//  Created by Taras Kalapun on 5/24/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentingViewControllerDelegate.h"
#import "QuickDialog.h"
#import "SVProgressHUD.h"


@interface GenericFormViewController : QuickDialogController

// Path for creating the item. If not set, use routes.
@property (nonatomic, strong) NSString *path;

// Path for manipulating with one item. If not set, use routes.
@property (nonatomic, strong) NSString *itemPath;

@property (nonatomic, assign) id <PresentingViewControllerDelegate> delegate;

// The alias to getter/setter of object we'r manipulating
@property (nonatomic, assign) id item;

// Create or Update
@property (nonatomic, assign) BOOL shouldCreateNewItem;


+ (QRootElement *)createRootElement;
- (QSection *)deleteButtonSection;

- (void)updateQuickDialogView;

// Interface actions
- (void)saveAction;
- (void)deleteAction;

- (BOOL)validateItemPassed;

- (void)createItemRequest;
- (void)updateItemRequest;
- (void)deleteItemRequest;

- (void)done;
- (void)cancel;

@end
