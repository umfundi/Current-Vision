//
//  ProductSalesAggrPerBrand.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductSalesAggrPerYear;

@interface ProductSalesAggrPerBrand : NSObject

@property (nonatomic, retain) NSString *brand;
@property (nonatomic, retain) NSMutableArray *aggrPerYears;
@property (nonatomic, retain) NSMutableArray *aggrPerProducts;

+ (NSArray *)ProductSalesGroupByBrandFrom:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD;
+ (NSArray *)ProductSalesGroupByBrandFromCustomers:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD;
+ (NSArray *)ProductSalesGroupByBrandFrom:(NSArray *)reports YTDorMAT:(BOOL)isYTD;

- (void)addAggrPerYear:(ProductSalesAggrPerYear *)aggrPerYear;
- (void)addAggrPerProduct:(ProductSalesAggrPerBrand *)aggrPerProduct;

@end
