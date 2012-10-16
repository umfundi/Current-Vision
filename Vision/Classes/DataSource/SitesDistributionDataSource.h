//
//  SitesDistributionDataSource.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@class SitesDistributionAggr;

@interface SitesDistributionDataSource : NSObject <SGridDataSource>

@property (nonatomic, strong) SitesDistributionAggr *sitesDistributionAggr;

@end
