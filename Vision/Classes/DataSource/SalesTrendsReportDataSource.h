//
//  SalesTrendsReportDataSource.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@class SalesTrendAggr;

@interface SalesTrendsReportDataSource : NSObject <SGridDataSource>

@property (nonatomic, strong) NSString *figureTitle;
@property (nonatomic, strong) SalesTrendAggr *salesTrendAggr;

- (NSString *)shinobiGrid:(ShinobiGrid *)grid textForGridCoord:(const SGridCoord *) gridCoord;

@end
