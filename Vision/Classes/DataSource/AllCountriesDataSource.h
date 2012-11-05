//
//  AllCountriesDataSource.h
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@protocol AllCountriesDataSourceDelegate <NSObject>

- (void)gridSorted;

@end

@interface AllCountriesDataSource : NSObject <SGridDataSource>
{
    NSInteger sortedColumn;
    NSComparisonResult sortedResult;
}

@property (nonatomic, strong) NSArray *countryArray;
@property (nonatomic, assign) id<AllCountriesDataSourceDelegate> delegate;

@end
