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

+ (NSArray *)ProductSalesGroupByBrandFrom:(NSArray *)reports YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull;

- (void)addAggrPerYear:(ProductSalesAggrPerYear *)aggrPerYear;
- (void)addAggrPerProduct:(ProductSalesAggrPerBrand *)aggrPerProduct;

@end
