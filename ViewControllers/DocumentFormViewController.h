//
//  DocumentFormViewController.h
//  MongoHq
//
//  Created by Taras Kalapun on 5/24/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "GenericFormViewController.h"
#import "MDatabase.h"
#import "MCollection.h"
#import "MDocument.h"

@interface DocumentFormViewController : GenericFormViewController

@property (nonatomic, strong) MDatabase *database;
@property (nonatomic, strong) MCollection *collection;
@property (nonatomic, strong) MDocument *document;

@end
