//
//  CustomerSalesAggr.h
//  Vision
//
//  Created by Jin on 11/6/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerSalesAggr : NSObject

@property (nonatomic, retain) NSArray *monthArray;
@property (nonatomic, retain) NSArray *aggrPerCustomers;

- (id)initWithYTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull;
+ (CustomerSalesAggr *)aggrFromAggrPerCustomersArray:(NSArray *)aggrPerCustomers YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull;

+ (CustomerSalesAggr *)CustomerSalesGroupByGroupFrom:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull;
+ (CustomerSalesAggr *)CustomerSalesGroupByGroupFromCustomers:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull;

@end
