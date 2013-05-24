//
//  PresentingViewControllerDelegate.h
//  MongoHq
//
//  Created by Taras Kalapun on 5/24/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PresentingViewControllerDelegate <NSObject>

- (void)presentedViewControllerDidDone:(UIViewController *)viewController;
- (void)presentedViewControllerDidCancel:(UIViewController *)viewController;

@end
