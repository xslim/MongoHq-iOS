//
//  NewDatabaseViewController.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/23/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "DatabaseFormViewController.h"
#import "SVProgressHUD.h"
#import "MDatabase.h"
#import "MPlan.h"


@interface DatabaseFormViewController ()
@end

@implementation DatabaseFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.path = @"/databases";
    if (self.shouldCreateNewItem) {
        if ([MDatabase isSubclassOfClass:[NSManagedObject class]]) {
            self.database = [MDatabase MR_createEntity];
        } else {
            self.database = [MDatabase new];
        }
    }
    
    [self loadPlans];
}


- (void)displayNewDatabaseFormWithPlans:(NSArray *)plans {
    
    NSMutableDictionary *plansDict = [NSMutableDictionary dictionaryWithCapacity:[plans count]];
    for (MPlan *plan in plans) {
        [plansDict setObject:plan.slug forKey:plan.selectName];
    }
    
    QSection *section = [[QSection alloc] initWithTitle:self.title];
    QEntryElement *nameEntry = [[QEntryElement alloc] initWithTitle:@"Name" Value:self.database.name Placeholder:@"my_new_database"];
    nameEntry.bind = @"textValue:name";
    [section addElement:nameEntry];
    
    
    QRadioElement *planEntry = [[QRadioElement alloc] initWithDict:plansDict selected:0 title:@"Plan"];
    planEntry.bind = @"selectedValue:plan";
    [section addElement:planEntry];
    
    [self.root addSection:section];
    if (!self.shouldCreateNewItem) [self.root addSection:[self deleteButtonSection]];
        
    [self updateQuickDialogView];
}

- (id)item {
    return self.database;
}

- (void)setItem:(id)item {
    self.database = item;
}

- (BOOL)validateItemPassed {
    if (self.database.name.length == 0 || self.database.plan.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Missing data" message:@"Plase fill the data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    return YES;
}


- (void)loadPlans
{
    
    [SVProgressHUD showWithStatus:@"Loading plans"];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
//    [manager getObjectsAtPathForRouteNamed:@"plans" object:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//        <#code#>
//    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//        <#code#>
//    }]
    
    [manager getObjectsAtPath:@"/plans" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [SVProgressHUD dismiss];
        [self displayNewDatabaseFormWithPlans:[mappingResult array]];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        [SVProgressHUD dismiss];
    }];
    
}

@end
