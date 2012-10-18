//
//  BrandListDataSource.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@interface BrandListDataSource : NSObject <SGridDataSource>

@property (nonatomic, strong) NSArray *brandArray;
@property (nonatomic, strong) NSMutableArray *itemSelected;

@end
