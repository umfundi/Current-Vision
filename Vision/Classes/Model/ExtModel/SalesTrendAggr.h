//
//  SalesTrendAggr.h
//  Vision
//
//  Created by Jin on 11/6/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SalesTrendAggr : NSObject

@property (nonatomic, retain) NSArray *monthArray;
@property (nonatomic, retain) NSArray *aggrPerBrands;

- (id)initWithYTDorMAT:(BOOL)isYTD;
+ (SalesTrendAggr *)aggrFromAggrPerBrands:(NSArray *)aggrPerBrands YTDorMAT:(BOOL)isYTD;

+ (SalesTrendAggr *)SalesTrendsGroupByBrandFrom:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD;
+ (SalesTrendAggr *)SalesTrendsGroupByBrandFromCustomers:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD;

+ (SalesTrendAggr *)yearReportsFrom:(NSArray *)monthReports YTDorMAT:(BOOL)isYTD;

@end
