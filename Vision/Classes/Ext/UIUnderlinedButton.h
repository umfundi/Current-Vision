//
//  UIUnderlinedButton.h
//  iFMW_v20
//
//  Created by System Administrator on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIUnderlinedButton : UIButton

+ (UIUnderlinedButton*) underlinedButtonWithOrder:(NSComparisonResult)order;

@property (nonatomic, assign) BOOL underline;

@end
