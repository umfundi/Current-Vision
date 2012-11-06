//
//  SitesDistributionPerCustomerDataSource.h
//  Vision
//
//  Created by Jin on 11/1/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>
#import "SitesDistributionAggr.h"

@class SitesDistributionAggrItem;

@interface SitesDistributionSubDataSource : NSObject <SGridDataSource>

@property (nonatomic, strong) SitesDistributionAggrItem *sitesDistributionAggrItem;

@end
