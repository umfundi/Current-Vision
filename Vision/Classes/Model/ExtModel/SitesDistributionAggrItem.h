//
//  SitesDistributionAggrItem.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SitesDistributionAggr.h"

@interface SitesDistributionAggrItem : NSObject

@property (nonatomic, retain) NSString *cursitesString;
@property (nonatomic, assign) double prvqtr;
@property (nonatomic, retain) NSString *prvqtrString;
@property (nonatomic, assign) double curqtr;
@property (nonatomic, retain) NSString *curqtrString;
@property (nonatomic, assign) double change;
@property (nonatomic, retain) NSString *changeString;
@property (nonatomic, retain) NSString *prvqtrAvg;
@property (nonatomic, retain) NSString *curqtrAvg;

@property (nonatomic, retain) NSMutableArray *aggrPerCustomerArray;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) SitesDistributionType type;

- (void)addSitesDistribution:(NSDictionary *)sitesDistribution;
- (void)finishAdd;

@end
