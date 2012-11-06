//
//  CustomerSalesDataSource.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@class CustomerSalesAggr;

@interface CustomerSalesDataSource : NSObject <SGridDataSource>

@property (nonatomic, strong) CustomerSalesAggr *customerSalesAggr;
@property (nonatomic, assign) BOOL isYTD;
@property (nonatomic, assign) BOOL isFull;

- (NSString *)shinobiGrid:(ShinobiGrid *)grid textForGridCoord:(const SGridCoord *) gridCoord;

@end
