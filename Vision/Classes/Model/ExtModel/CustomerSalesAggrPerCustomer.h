//
//  CustomerSalesAggrPerGroup.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CustomerSalesAggrPerYear;

@interface CustomerSalesAggrPerCustomer : NSObject

@property (nonatomic, retain) NSString *id_customer;
@property (nonatomic, retain) NSString *customerName;
@property (nonatomic, retain) NSMutableArray *aggrPerYears;

+ (NSArray *)CustomerSalesGroupByGroupFrom:(NSString *)aField andValue:(NSString *)aValue YDTorMAT:(BOOL)isYTD;
+ (NSArray *)CustomerSalesGroupByGroupFromCustomers:(NSString *)aField andValue:(NSString *)aValue YDTorMAT:(BOOL)isYTD;

- (void)addAggrPerYear:(CustomerSalesAggrPerYear *)aggrPerYear;

@end
