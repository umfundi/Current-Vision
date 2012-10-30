//
//  ProductSalesDataSource.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@class ProductSalesAggrPerBrand;

@protocol ProductSalesDataSourceDelegate <NSObject>

- (void)brandSelected:(ProductSalesAggrPerBrand *)brand;

@end

@interface ProductSalesDataSource : NSObject <SGridDataSource>

@property (nonatomic, strong) NSArray *productSalesArray;
@property (nonatomic, strong) NSNumberFormatter *numberFormat;
@property (nonatomic, assign) id<ProductSalesDataSourceDelegate> delegate;

- (NSString *)shinobiGrid:(ShinobiGrid *)grid textForGridCoord:(const SGridCoord *) gridCoord;

@end
