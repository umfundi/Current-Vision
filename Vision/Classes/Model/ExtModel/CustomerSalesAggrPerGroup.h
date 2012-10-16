//
//  CustomerSalesAggrPerGroup.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CustomerSalesAggrPerYear;

@interface CustomerSalesAggrPerGroup : NSObject

@property (nonatomic, retain) NSString *group;
@property (nonatomic, retain) NSMutableArray *aggrPerYears;

+ (NSArray *)CustomerSalesGroupByGroupFrom:(NSString *)customer;

- (void)addAggrPerYear:(CustomerSalesAggrPerYear *)aggrPerYear;

@end
