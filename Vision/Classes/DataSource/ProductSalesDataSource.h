//
//  ProductSalesDataSource.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@class ProductSalesAggr;
@class ProductSalesAggrPerBrand;

@protocol ProductSalesDataSourceDelegate <NSObject>

- (void)brandSelected:(ProductSalesAggrPerBrand *)brand;

@end

@interface ProductSalesDataSource : NSObject <SGridDataSource>

@property (nonatomic, strong) ProductSalesAggr *productSalesAggr;
@property (nonatomic, strong) NSNumberFormatter *numberFormat;
@property (nonatomic, assign) id<ProductSalesDataSourceDelegate> delegate;
@property (nonatomic, assign) BOOL isYTD;
@property (nonatomic, assign) BOOL isFull;

- (NSString *)shinobiGrid:(ShinobiGrid *)grid textForGridCoord:(const SGridCoord *) gridCoord;

@end
