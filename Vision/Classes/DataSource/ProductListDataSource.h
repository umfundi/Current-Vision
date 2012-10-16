//
//  ProductListDataSource.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@interface ProductListDataSource : NSObject <SGridDataSource>

@property (nonatomic, strong) NSArray *productArray;

@end
