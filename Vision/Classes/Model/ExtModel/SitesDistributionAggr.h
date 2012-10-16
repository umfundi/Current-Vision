//
//  SitesDistributionAggr.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SitesDistributionAggrItem;

@interface SitesDistributionAggr : NSObject

@property (nonatomic, retain) SitesDistributionAggrItem *retainedItem;
@property (nonatomic, retain) SitesDistributionAggrItem *gainedItem;
@property (nonatomic, retain) SitesDistributionAggrItem *lostItem;
@property (nonatomic, retain) SitesDistributionAggrItem *totalItem;

+ (SitesDistributionAggr *)AggrFilteredByBrands:(NSArray *)brands;
+ (SitesDistributionAggr *)AggrFilteredByProducts:(NSArray *)products;

- (void)finishAdd;

@end
