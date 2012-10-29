//
//  ProductSalesDataSource.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@interface ProductSalesDataSource : NSObject <SGridDataSource>

@property (nonatomic, strong) NSArray *productSalesArray;

@property (nonatomic, strong) NSNumberFormatter *numberFormat;

- (NSString *)shinobiGrid:(ShinobiGrid *)grid textForGridCoord:(const SGridCoord *) gridCoord;

@end
