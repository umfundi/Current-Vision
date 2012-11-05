//
//  SitesDistributionAggr.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SitesDistributionAggrItem;

typedef enum _sites_distribution_period
{
    PrevYear = 0,
    CurYear,
    YTD,
} SitesDistributionPeriod;

typedef enum _sites_distribution_type
{
    Retained = 0,
    Gained,
    Lost,
} SitesDistributionType;

@interface SitesDistributionAggr : NSObject

@property (nonatomic, retain) SitesDistributionAggrItem *retainedItem;
@property (nonatomic, retain) SitesDistributionAggrItem *gainedItem;
@property (nonatomic, retain) SitesDistributionAggrItem *lostItem;
@property (nonatomic, retain) SitesDistributionAggrItem *totalItem;

+ (SitesDistributionAggr *)AggrFilteredByBrands:(NSArray *)brands period:(SitesDistributionPeriod)period;
+ (SitesDistributionAggr *)AggrFilteredByProducts:(NSArray *)products period:(SitesDistributionPeriod)period;

- (void)finishAdd;

@end
