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
    return [NSString stringWithFormat:@"%@ - %@ on %@",
            self.name, self.eventMessage, self.timestamp];
}

+ (UIImage *)placeholderImage
{
    return [UIImage imageIcon:@"FontAwesome/picture" size:(CGSize){16,16} color:[UIColor lightGrayColor]];
}

@end
