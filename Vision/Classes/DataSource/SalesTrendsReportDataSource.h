//
//  SalesTrendsReportDataSource.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@interface SalesTrendsReportDataSource : NSObject <SGridDataSource>

@property (nonatomic, strong) NSString *figureTitle;
@property (nonatomic, strong) NSArray *reportArray;

- (NSString *)shinobiGrid:(ShinobiGrid *)grid textForGridCoord:(const SGridCoord *) gridCoord;

@end
