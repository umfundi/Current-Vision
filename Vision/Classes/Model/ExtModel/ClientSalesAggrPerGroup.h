//
//  ClientSalesAggrPerGroup.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientSalesAggrPerGroup : NSObject

@property (nonatomic, retain) NSString *group;
@property (nonatomic, retain) NSString *rank;

@property (nonatomic, assign) double *monthValArray;
@property (nonatomic, retain) NSArray *monthValStringArray;
@property (nonatomic, assign) double yearsum;
@property (nonatomic, retain) NSString *yearsumString;
@property (nonatomic, retain) NSString *totpro;
@property (nonatomic, assign) double lastyearsum;
@property (nonatomic, retain) NSString *lastyearsumString;
@property (nonatomic, retain) NSString *diffpro;
@property (nonatomic, retain) NSString *diffsum;

@property (nonatomic, retain) NSMutableArray *aggrPerPractices;

- (void)addClientSales:(NSDictionary *)report YTDorMAT:(BOOL)isYTD;
- (void)addClientSales:(NSDictionary *)report YTDorMAT:(BOOL)isYTD curYear:(NSString *)curYear lastYear:(NSString *)lastYear;
- (void)finishAdd;

@end
