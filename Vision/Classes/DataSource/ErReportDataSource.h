//
//  ErReportDataSource.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@class ErReportAggrPerBrand;

@protocol ErReportDataSourceDelegate <NSObject>

- (void)brandSelected:(ErReportAggrPerBrand *)brand;

@end

@interface ErReportDataSource : NSObject <SGridDataSource>

@property (nonatomic, strong) NSArray *erReportArray;
@property (nonatomic, assign) id<ErReportDataSourceDelegate> delegate;

- (NSString *)shinobiGrid:(ShinobiGrid *)grid textForGridCoord:(const SGridCoord *) gridCoord;

@end
