//
//  SitesDistributionDataSource.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@class SitesDistributionAggr;
@class SitesDistributionAggrItem;
@class SitesDistributionDataSource;

@protocol SitesDistributionDataSourceDelegate <NSObject>

- (void)aggrItemSelected:(SitesDistributionAggrItem *)selected dataSource:(SitesDistributionDataSource *)dataSource;

@end

@interface SitesDistributionDataSource : NSObject <SGridDataSource>

@property (nonatomic, strong) SitesDistributionAggr *sitesDistributionAggr;
@property (nonatomic, assign) id<SitesDistributionDataSourceDelegate> delegate;

@end
