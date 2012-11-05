//
//  ClientSalesAggr.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ClientSalesAggrPerGroup;

@interface ClientSalesAggr : NSObject

@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSString *lastyear;

@property (nonatomic, retain) NSMutableArray *aggrPerGroups;

+ (ClientSalesAggr *)AggrWithYTDorMAT:(BOOL)isYTD;
+ (ClientSalesAggr *)AggrByBrands:(NSArray *)brands YTDorMAT:(BOOL)isYTD;

- (void)addAggrPerGroup:(ClientSalesAggrPerGroup *)aggrPerGroup;
- (void)finishAdd;

@end
