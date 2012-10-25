//
//  PracticeAggr.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PracticeAggrPerBrand;

@interface PracticeAggr : NSObject

@property (nonatomic, assign) double month;
@property (nonatomic, retain) NSString *monthString;
@property (nonatomic, assign) double ytd;
@property (nonatomic, retain) NSString *ytdString;
@property (nonatomic, assign) double mat;
@property (nonatomic, retain) NSString *matString;

@property (nonatomic, retain) NSMutableArray *aggrPerBrands;

+ (PracticeAggr *)AggrFrom:(NSString *)practiceCode;

- (void)addAggrPerBrand:(PracticeAggrPerBrand *)aggrPerBrand;
- (void)finishAdd;

@end