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
@property (nonatomic, retain) NSString *totq1;
@property (nonatomic, retain) NSString *totq2;
@property (nonatomic, retain) NSString *totq3;
@property (nonatomic, retain) NSString *totq4;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSString *growth;
@property (nonatomic, retain) NSString *qty;
@property (nonatomic, retain) NSString *qtygrowth;

- (void)addCustomerSale:(NSDictionary *)customerSale YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull Year:(NSString *)yearInData;
- (void)finishAdd;

@end
