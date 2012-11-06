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

+ (NSArray *)ErReportGroupByBrandFrom:(NSArray *)reports YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull;

- (void)addAggrPerYear:(ErReportAggrPerYear *)aggrPerYear;
- (void)addAggrPerProduct:(ErReportAggrPerBrand *)aggrPerProduct;

@end
