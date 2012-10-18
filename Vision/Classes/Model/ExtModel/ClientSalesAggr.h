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

+ (ClientSalesAggr *)AggrByProducts:(NSArray *)products;

- (void)addAggrPerGroup:(ClientSalesAggrPerGroup *)aggrPerGroup;
- (void)finishAdd;

@end
