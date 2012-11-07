//
//  CustomerSalesAggrPerYear.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerSalesAggrPerYear : NSObject

@property (nonatomic, retain) NSString *year;

@property (nonatomic, assign) double *monthValArray;
@property (nonatomic, retain) NSArray *monthValStringArray;
@property (nonatomic, assign) double totq1;
@property (nonatomic, assign) double totq2;
@property (nonatomic, assign) double totq3;
@property (nonatomic, assign) double totq4;
@property (nonatomic, assign) double value;
@property (nonatomic, assign) double growth;
@property (nonatomic, assign) double qty;
@property (nonatomic, assign) double qtygrowth;

- (void)addCustomerSale:(NSDictionary *)customerSale YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull Year:(NSString *)yearInData;
- (void)finishAdd;

@end
