//
//  NewDatabaseViewController.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/23/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "NewDatabaseViewController.h"
#import "SVProgressHUD.h"
#import "MDatabase.h"
#import "MPlan.h"


@interface NewDatabaseViewController ()
@end

@implementation NewDatabaseViewController

- (id)init
{
    QRootElement *root = [[QRootElement alloc] init];
    root.title = @"New Database";
    root.grouped = YES;
    self = [super initWithRoot:root];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *btn1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = btn1;
    UIBarButtonItem *btn2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = btn2;
    
    [self loadPlans];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    
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

- (void)displayNewDatabaseFormWithPlans:(NSArray *)plans {
    
    NSMutableDictionary *plansDict = [NSMutableDictionary dictionaryWithCapacity:[plans count]];
    for (MPlan *plan in plans) {
        [plansDict setObject:plan.slug forKey:plan.selectName];
    }
    
    QSection *section = [[QSection alloc] initWithTitle:@"Create new Database"];
    QEntryElement *nameEntry = [[QEntryElement alloc] initWithTitle:@"Name" Value:nil Placeholder:@"my_new_database"];
    nameEntry.bind = @"textValue:name";
    [section addElement:nameEntry];
    
    
    QRadioElement *planEntry = [[QRadioElement alloc] initWithDict:plansDict selected:0 title:@"Plan"];
    planEntry.bind = @"selectedValue:plan";
    [section addElement:planEntry];
    
    [self.root addSection:section];
        
    [self updateQuickDialogView];
}

- (void)save
{
    MDatabase *newDatabase = [MDatabase new];
    [self.root fetchValueUsingBindingsIntoObject:newDatabase];
    
    if (newDatabase.name.length == 0 || newDatabase.plan.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Missing data" message:@"Plase fill the data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"Creating new database"];
    RKObjectManager *manager = [AppController shared].objectManager;
    [manager postObject:newDatabase path:@"/databases" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [SVProgressHUD dismiss];
        [self cancel];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        [SVProgressHUD dismiss];
    }];
}

- (void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)loadPlans
{
    
    [SVProgressHUD showWithStatus:@"Loading plans"];
    RKObjectManager *manager = [AppController shared].objectManager;
    [manager getObjectsAtPath:@"/plans" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [SVProgressHUD dismiss];
        [self displayNewDatabaseFormWithPlans:[mappingResult array]];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        [SVProgressHUD dismiss];
    }];
    
}

@end
