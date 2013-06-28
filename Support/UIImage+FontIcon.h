//
//  UIImage+FontIcon.h
//  Events
//
//  Created by Taras Kalapun on 4/4/13.
//  Copyright (c) 2013 Xaton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FontIcon)

#ifdef COCOAPODS_POD_AVAILABLE_FontasticIcons
+ (UIImage *)fi_imageIcon:(NSString *)name size:(CGSize)size color:(UIColor *)color;
+ (UIImage *)fi_imageIcon:(NSString *)name size:(CGSize)size hexColor:(NSString *)hexString;
#endif

@end
