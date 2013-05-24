//
//  NewDatabaseViewController.h
//  MongoHq
//
//  Created by Taras Kalapun on 5/23/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericFormViewController.h"
#import "MDatabase.h"

@interface DatabaseFormViewController : GenericFormViewController

@property (nonatomic, strong) MDatabase *database;

@end
