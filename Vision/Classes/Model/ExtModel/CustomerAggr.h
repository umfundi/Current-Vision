//
//  SalesExtModel.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CustomerAggrPerBrand;

@interface CustomerAggr : NSObject

@property (nonatomic, assign) double month;
@property (nonatomic, retain) NSString *monthString;
@property (nonatomic, assign) double ytd;
@property (nonatomic, retain) NSString *ytdString;
@property (nonatomic, assign) double mat;
@property (nonatomic, retain) NSString *matString;

@property (nonatomic, retain) NSMutableArray *aggrPerBrands;

+ (CustomerAggr *)AggrFrom:(NSString *)customer;

- (void)addAggrPerBrand:(CustomerAggrPerBrand *)aggrPerBrand;
- (void)finishAdd;

@end
