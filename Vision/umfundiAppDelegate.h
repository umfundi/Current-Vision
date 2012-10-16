//
//  umfundiAppDelegate.h
//  Vision
//
//  Created by Ian Molesworth on 02/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;
@class umfundiViewController;

@interface umfundiAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) umfundiViewController *frontViewController;

@property (nonatomic, retain) Reachability *reachability;

@end
