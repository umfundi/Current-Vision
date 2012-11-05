//
//  PracticeSearchResultDataSource.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@protocol PracticeSearchResultDataSourceDelegate <NSObject>

- (void)gridSorted;

@end

@interface PracticeSearchResultDataSource : NSObject <SGridDataSource>
{
    NSInteger sortedColumn;
    NSComparisonResult sortedResult;
}

@property (nonatomic, strong) NSArray *searchResult;
@property (nonatomic, assign) id<PracticeSearchResultDataSourceDelegate> delegate;

- (id)initWithResults:(NSArray *)resultArray;

@end
