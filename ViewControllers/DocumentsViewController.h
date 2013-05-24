//
//  DocumentsViewController.h
//  MongoHq
//
//  Created by Taras Kalapun on 5/24/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "GenericTableViewController.h"
#import "MDatabase.h"
#import "MCollection.h"

@interface DocumentsViewController : GenericTableViewController

@property (nonatomic, strong) MDatabase *database;
@property (nonatomic, strong) MCollection *collection;

@end
