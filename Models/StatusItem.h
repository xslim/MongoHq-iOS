//
//  StatusItem.h
//  MongoHq
//
//  Created by Taras Kalapun on 5/1/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *itemDescription;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSString *eventMessage;
@property (nonatomic, strong) NSString *statusName;


@property (nonatomic, readonly) NSString *titleText;
@property (nonatomic, readonly) NSString *subtitleText;
@property (nonatomic, readonly) UIImage *statusImage;

@end
