//
//  SalesExtModel.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerAggr : NSObject

@property (nonatomic, assign) double month;
@property (nonatomic, retain) NSString *monthString;
@property (nonatomic, assign) double ytd;
@property (nonatomic, retain) NSString *ytdString;
@property (nonatomic, assign) double mat;
@property (nonatomic, retain) NSString *matString;

+ (CustomerAggr *)AggrFrom:(NSString *)customer;

- (void)finishAdd;

@end
