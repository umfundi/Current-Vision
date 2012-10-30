//
//  ErReportAggrPerBrand.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ErReportAggrPerYear;

@interface ErReportAggrPerBrand : NSObject

@property (nonatomic, retain) NSString *brand;
@property (nonatomic, retain) NSMutableArray *aggrPerYears;
@property (nonatomic, retain) NSMutableArray *aggrPerProducts;

+ (NSArray *)ErReportGroupByBrandFrom:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD;
+ (NSArray *)ErReportGroupByBrandFromCustomers:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD;
+ (NSArray *)ErReportGroupByBrandFrom:(NSArray *)reports YTDorMAT:(BOOL)isYTD;

- (void)addAggrPerYear:(ErReportAggrPerYear *)aggrPerYear;
- (void)addAggrPerProduct:(ErReportAggrPerBrand *)aggrPerProduct;

@end
