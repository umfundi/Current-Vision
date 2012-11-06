//
//  ErReportDataSource.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@class ErReportAggr;
@class ErReportAggrPerBrand;

@protocol ErReportDataSourceDelegate <NSObject>

- (void)brandSelected:(ErReportAggrPerBrand *)brand;

@end

@interface ErReportDataSource : NSObject <SGridDataSource>

@property (nonatomic, strong) ErReportAggr *erReportAggr;
@property (nonatomic, assign) id<ErReportDataSourceDelegate> delegate;
@property (nonatomic, assign) BOOL isYTD;
@property (nonatomic, assign) BOOL isFull;

- (NSString *)shinobiGrid:(ShinobiGrid *)grid textForGridCoord:(const SGridCoord *) gridCoord;

@end
