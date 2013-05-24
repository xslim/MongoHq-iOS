//
//  ApiKeyViewController.h
//  MongoHq
//
//  Created by Taras Kalapun on 5/24/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentingViewControllerDelegate.h"
#import "QuickDialog.h"

@interface ApiKeyViewController : QuickDialogController

@property (nonatomic, assign) id <PresentingViewControllerDelegate> delegate;

- (void)done;

@end
