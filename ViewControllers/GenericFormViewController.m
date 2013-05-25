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
        // Custom initialization
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
        [self deleteItem];
    };
    
    QSection *section = [[QSection alloc] initWithTitle:@""];
    [section addElement:btn];
    return section;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *btn1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = btn1;
    UIBarButtonItem *btn2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = btn2;
    
    self.itemIsNew = (self.item) ? NO : YES;

    
    if (!self.itemTypeName) {
        // Cut 'M' from class name
        NSString *className = NSStringFromClass([self class]);
        self.itemTypeName = [className stringByReplacingOccurrencesOfString:@"FormViewController" withString:@""];
    }
    
    if (!self.title) {
        NSString *newOrEdit = (self.itemIsNew) ? @"New" : @"Edit";
        self.title = [NSString stringWithFormat:@"%@ %@", newOrEdit, self.itemTypeName];
    }
    
    self.root.title = self.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateQuickDialogView {
    // Hack to Update table
    self.quickDialogTableView.root = self.root;
}

- (BOOL)validateItem {
    return YES;
}

- (void)save
{
    [self.root fetchValueUsingBindingsIntoObject:self.item];
    
    // Validate
    [self validateItem];
    
    if (self.itemIsNew) {
        [self saveNew];
    } else {
        [self saveEdit];
    }
}

- (void)deleteItem {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete?" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        return;
    }
    
    [self saveDelete];
}

- (void)saveNew {
    [SVProgressHUD showWithStatus:@"Creating..."];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    // Use Route?
    if (!self.path) {
        NSLog(@"Will use Object route");
    }
    
    [manager postObject:self.item path:self.path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self done];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self errorOnLoad:error];
    }];
}

- (void)saveEdit {
    [SVProgressHUD showWithStatus:@"Saving..."];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager putObject:self.item path:self.itemPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self done];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self errorOnLoad:error];
    }];
}

- (void)saveDelete {
    [SVProgressHUD showWithStatus:@"Deleting..."];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager deleteObject:self.item path:self.itemPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
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
