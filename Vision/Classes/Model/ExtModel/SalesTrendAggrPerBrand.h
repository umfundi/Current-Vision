//
//  SalesTrendAggrPerBrand.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SalesTrendAggrPerBrand : NSObject

@property (nonatomic, retain) NSString *brand;

@property (nonatomic, assign) double jan;
@property (nonatomic, retain) NSString *janString;
@property (nonatomic, assign) double feb;
@property (nonatomic, retain) NSString *febString;
@property (nonatomic, assign) double mar;
@property (nonatomic, retain) NSString *marString;
@property (nonatomic, assign) double apr;
@property (nonatomic, retain) NSString *aprString;
@property (nonatomic, assign) double may;
@property (nonatomic, retain) NSString *mayString;
@property (nonatomic, assign) double jun;
@property (nonatomic, retain) NSString *junString;
@property (nonatomic, assign) double jul;
@property (nonatomic, retain) NSString *julString;
@property (nonatomic, assign) double aug;
@property (nonatomic, retain) NSString *augString;
@property (nonatomic, assign) double sep;
@property (nonatomic, retain) NSString *sepString;
@property (nonatomic, assign) double oct;
@property (nonatomic, retain) NSString *octString;
@property (nonatomic, assign) double nov;
@property (nonatomic, retain) NSString *novString;
@property (nonatomic, assign) double dec;
@property (nonatomic, retain) NSString *decString;
@property (nonatomic, retain) NSString *growthString;

+ (NSArray *)SalesTrendsGroupByBrandFrom:(NSString *)aField andValue:(NSString *)aValue YDTorMAT:(BOOL)isYTD;
+ (NSArray *)SalesTrendsGroupByBrandFromCustomers:(NSString *)aField andValue:(NSString *)aValue YDTorMAT:(BOOL)isYTD;

+ (NSArray *)yearReportsFrom:(NSArray *)monthReports;

- (void)addSalesTrend:(NSDictionary *)trend YDTorMAT:(BOOL)isYTD;
- (void)finishAdd;

- (SalesTrendAggrPerBrand *)convertToYearAggr;

@end
