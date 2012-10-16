//
//  SalesTrendsReportDataSource.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@interface SalesTrendsReportDataSource : NSObject <SGridDataSource>

@property (nonatomic, assign) BOOL isMonthReport;
@property (nonatomic, strong) NSArray *reportArray;

@end
