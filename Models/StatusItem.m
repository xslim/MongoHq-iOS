//
//  StatusItem.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/1/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "StatusItem.h"
#import "UIImage+FontIcon.h"

@implementation StatusItem

- (NSString *)titleText
{
    return [NSString stringWithFormat:@"%@ - %@", self.name, self.itemDescription];
}

- (NSString *)subtitleText
{
    return self.eventMessage;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@\n\t%@", self.titleText, self.subtitleText];
}

- (UIImage *)statusImage
{
    UIImage *img = nil;
    CGSize size = (CGSize){20,20};
    
    if ([self.statusName isEqualToString:@"Up"]) {
        img = [UIImage imageIcon:@"FontAwesome/ok" size:size color:[UIColor greenColor]];
    } else if ([self.statusName isEqualToString:@"Warning"]) {
        img = [UIImage imageIcon:@"FontAwesome/attention-circle" size:size color:[UIColor yellowColor]];
    } else if ([self.statusName isEqualToString:@"Maintenance"]) {
        img = [UIImage imageIcon:@"Iconic/clock" size:size color:[UIColor blueColor]];
    } else if ([self.statusName isEqualToString:@"Down"]) {
        img = [UIImage imageIcon:@"FontAwesome/cancel-circle" size:size color:[UIColor redColor]];
    } else {
        img = [UIImage imageIcon:@"FontAwesome/picture" size:size color:[UIColor lightGrayColor]];
    }
    
    
    return img;
}

@end
