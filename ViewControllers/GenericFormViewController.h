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

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *itemPath;

@property (nonatomic, assign) id <PresentingViewControllerDelegate> delegate;

@property (nonatomic, assign) id item;
@property (nonatomic, strong) NSString *itemTypeName;
@property (nonatomic, assign) BOOL itemIsNew;


+ (QRootElement *)createRootElement;
- (QSection *)deleteButtonSection;

- (void)updateQuickDialogView;

- (BOOL)validateItem;

- (void)save;
- (void)deleteItem;
- (void)saveNew;
- (void)saveEdit;
- (void)saveDelete;

- (void)done;
- (void)cancel;



@end
