//
//  CollectionsViewController.h
//  MongoHq
//
//  Created by Taras Kalapun on 5/23/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "GenericTableViewController.h"
#import "MDatabase.h"

@interface CollectionsViewController : GenericTableViewController

@property (nonatomic, strong) MDatabase *database;

@end
