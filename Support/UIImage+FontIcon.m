//
//  UIImage+FontIcon.m
//  Events
//
//  Created by Taras Kalapun on 4/4/13.
//  Copyright (c) 2013 Xaton. All rights reserved.
//

#import "UIImage+FontIcon.h"
#import "FontasticIcons.h"

#define UIColorFromRGBA(rgbValue, alphaValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 \
alpha:alphaValue])
#define UIColorFromRGB(rgbValue) (UIColorFromRGBA((rgbValue), 1.0))

@implementation UIImage (FontIcon)

+ (UIImage *)imageIcon:(NSString *)name size:(CGSize)size color:(UIColor *)color {
    NSArray *components = [name componentsSeparatedByString:@"/"];
    
    NSString *clsName = components[0];
    clsName = [clsName stringByReplacingOccurrencesOfString:@"Iconic" withString:@"XXX"];
    clsName = [clsName stringByReplacingOccurrencesOfString:@"Icon" withString:@""];
    clsName = [clsName stringByReplacingOccurrencesOfString:@"FI" withString:@""];
    clsName = [clsName stringByReplacingOccurrencesOfString:@"XXX" withString:@"Iconic"];
    
    clsName = [NSString stringWithFormat:@"FI%@Icon", clsName];
    Class cls = NSClassFromString(clsName);
    
    FIIcon *icon = [cls iconWithName:components[1]];
    
    return [icon imageWithBounds:CGRectMake(0, 0, size.width, size.height) color:color];
}

+ (UIImage *)imageIcon:(NSString *)name size:(CGSize)size hexColor:(NSString *)hexString {
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    unsigned hex;
    BOOL success = [scanner scanHexInt:&hex];
    
    UIColor *color = nil;
    
    if (!success) return nil;
    if ([hexString length] <= 6)
        color = UIColorFromRGB(hex);
    else {
        unsigned color = (hex & 0xFFFFFF00) >> 8;
        CGFloat alpha = 1.0 * (hex & 0xFF) / 255.0;
        color = UIColorFromRGBA(color, alpha);
    }
    return [UIImage imageIcon:name size:size color:color];
}

@end
