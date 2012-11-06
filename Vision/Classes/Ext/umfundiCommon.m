//
//  umfundiCommon.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//
//  Some common stuff
//

#import "umfundiCommon.h"

#import <QuartzCore/QuartzCore.h>

NSArray *monthArray;

@implementation umfundiCommon

+ (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


+ (void)applyColorToButton:(UIButton *)button withColor:(UIColor *)color
{
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

    UIImage *backImage = [umfundiCommon imageFromColor:color];
    [button setBackgroundImage:backImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:backImage forState:UIControlStateSelected];
    [button setBackgroundImage:[umfundiCommon imageFromColor:[UIColor whiteColor]] forState:UIControlStateNormal];

    button.layer.masksToBounds = YES;
    button.layer.borderColor = color.CGColor;
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 10.0f;
}


+ (NSString *)monthString:(NSInteger)month
{
    if (!monthArray)
    {
        monthArray = [NSArray arrayWithObjects:
                      NSLocalizedString(@"Jan", @""),
                      NSLocalizedString(@"Feb", @""),
                      NSLocalizedString(@"Mar", @""),
                      NSLocalizedString(@"Apr", @""),
                      NSLocalizedString(@"May", @""),
                      NSLocalizedString(@"Jun", @""),
                      NSLocalizedString(@"Jul", @""),
                      NSLocalizedString(@"Aug", @""),
                      NSLocalizedString(@"Sep", @""),
                      NSLocalizedString(@"Oct", @""),
                      NSLocalizedString(@"Nov", @""),
                      NSLocalizedString(@"Dec", @""), nil];
    }
    
    return [monthArray objectAtIndex:(month + 11) % 12];
}

@end
