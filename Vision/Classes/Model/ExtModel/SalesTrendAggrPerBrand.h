//
//  SalesTrendAggrPerBrand.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SalesTrendAggrPerBrand : NSObject

@property (nonatomic, retain) NSString *brand;

@property (nonatomic, assign) double *monthValArray;
@property (nonatomic, retain) NSArray *monthValStringArray;
@property (nonatomic, retain) NSString *growthString;

+ (NSArray *)SalesTrendsGroupByBrandFrom:(NSArray *)trends YTDorMAT:(BOOL)isYTD;

- (void)addSalesTrend:(NSDictionary *)trend YTDorMAT:(BOOL)isYTD;
- (void)finishAdd;

- (SalesTrendAggrPerBrand *)convertToYearAggr;

@end
