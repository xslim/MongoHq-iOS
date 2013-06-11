//
//  GenericFormViewController.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/24/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "GenericFormViewController.h"

@interface GenericFormViewController ()<UIAlertViewDelegate>

@end

@implementation GenericFormViewController


- (id)init
{
    self = [super initWithRoot:[[self class] createRootElement]];
    if (self) {
    }
    return self;
}

+ (QRootElement *)createRootElement
{
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    return root;
}

- (QSection *)deleteButtonSection
{
    QButtonElement *btn = [[QButtonElement alloc] initWithTitle:@"Delete"];
    btn.onSelected = ^{
        [self deleteAction];
    };
    
    // Put in in a new section
    QSection *section = [[QSection alloc] initWithTitle:@""];
    [section addElement:btn];
    return section;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *btn1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItem = btn1;
    UIBarButtonItem *btn2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = btn2;
    
    self.shouldCreateNewItem = (self.item) ? NO : YES;

    
    if (!self.title) {
        // Preset the title
        NSString *className = NSStringFromClass([self class]);
        NSString *itemType = [className stringByReplacingOccurrencesOfString:@"FormViewController" withString:@""];
        NSString *newOrEdit = (self.shouldCreateNewItem) ? @"New" : @"Edit";
        self.title = [NSString stringWithFormat:@"%@ %@", newOrEdit, itemType];
    }
    
    self.root.title = self.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Hack to Update tableView of QuickDialog
- (void)updateQuickDialogView {
    // self.root is a property from QuickDialogController
    self.quickDialogTableView.root = self.root;
}

- (BOOL)validateItemPassed {
    return YES;
}

- (void)saveAction
{
    // Fetch the Entry element data to our object
    [self.root fetchValueUsingBindingsIntoObject:self.item];
    
    // Validate that entered data is correct
    if (![self validateItemPassed]) return;
    
    [SVProgressHUD show]; // Show loading HUD
    if (self.shouldCreateNewItem) {
        [self createItemRequest];
    } else {
        [self updateItemRequest];
    }
}

- (void)deleteAction {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete?" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        return;
    }
    
    [SVProgressHUD showWithStatus:@"Deleating"];
    [self deleteItemRequest];
}

- (RKObjectManager *)manager {
    return [RKObjectManager sharedManager];
}

- (void)createItemRequest {
    [self.manager postObject:self.item path:self.path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self done];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self errorOnLoad:error];
    }];
}

- (void)updateItemRequest {
    [self.manager putObject:self.item path:self.itemPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self done];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self errorOnLoad:error];
    }];
}

- (void)deleteItemRequest {
    [self.manager deleteObject:self.item path:self.itemPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self done];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self errorOnLoad:error];
    }];
}

- (void)errorOnLoad:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    [SVProgressHUD dismiss];
}

- (void)done {
    [SVProgressHUD dismiss];
    [self.delegate presentedViewControllerDidDone:self];
}

- (void)cancel {
    [self.delegate presentedViewControllerDidCancel:self];
}

@end
