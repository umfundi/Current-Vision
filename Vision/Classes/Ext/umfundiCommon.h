//
//  umfundiCommon.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface umfundiCommon : NSObject

+ (UIImage *)imageFromColor:(UIColor *)color;

+ (void)applyColorToButton:(UIButton *)button withColor:(UIColor *)color;

+ (NSString *)monthString:(NSInteger)month;

@end
