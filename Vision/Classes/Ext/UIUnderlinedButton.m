//
//  UIUnderlinedButton.m
//  iFMW_v20
//
//  Created by System Administrator on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIUnderlinedButton.h"


@implementation UIUnderlinedButton

@synthesize underline;

- (id)init
{
    self = [super init];
    if (self)
    {
        underline = YES;
    }
        
    return self;
}

+ (UIUnderlinedButton*) underlinedButtonWithOrder:(NSComparisonResult)order
{
    UIUnderlinedButton *button = [[UIUnderlinedButton alloc] init];
    
    if (order != NSOrderedSame)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.size.width - 20, (button.frame.size.height - 15) / 2, 14, 15)];
        imageView.image = [UIImage imageNamed:(order == NSOrderedAscending) ? @"down.png" : @"up.png"];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        [button addSubview:imageView];
    }
    
    return button;
}

- (void) drawRect:(CGRect)rect
{
    if (!underline)
        return;
    
    CGRect textRect = self.titleLabel.frame;
    
    // need to put the line at top of descenders (negative value)
    CGFloat descender = self.titleLabel.font.descender;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // set to same colour as text
    CGContextSetStrokeColorWithColor(contextRef, self.titleLabel.textColor.CGColor);
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender);
    
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender);
    
    CGContextClosePath(contextRef);
    
    CGContextDrawPath(contextRef, kCGPathStroke);
}

@end
