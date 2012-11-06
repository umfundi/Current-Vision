//
//  ErReportAggr.h
//  Vision
//
//  Created by Jin on 11/6/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErReportAggr : NSObject

@property (nonatomic, retain) NSArray *monthArray;
@property (nonatomic, retain) NSArray *aggrPerBrands;

- (id)initWithYTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull;
+ (ErReportAggr *)aggrFromAggrPerBrandsArray:(NSArray *)aggrPerBrands YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull;

+ (ErReportAggr *)ErReportGroupByBrandFrom:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull;
+ (ErReportAggr *)ErReportGroupByBrandFromCustomers:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull;

@end
