//
//  ProductSalesAggr.h
//  Vision
//
//  Created by Jin on 11/6/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductSalesAggr : NSObject

@property (nonatomic, retain) NSArray *monthArray;
@property (nonatomic, retain) NSArray *aggrPerBrands;

- (id)initWithYTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull;
+ (ProductSalesAggr *)aggrFromAggrPerBrandsArray:(NSArray *)aggrPerBrands YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull;

+ (ProductSalesAggr *)ProductSalesGroupByBrandFrom:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull;
+ (ProductSalesAggr *)ProductSalesGroupByBrandFromCustomers:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull;

@end
