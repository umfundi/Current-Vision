//
//  AllGroupsDataSource.h
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@protocol AllGroupsDataSourceDelegate <NSObject>

- (void)gridSorted;

@end

@interface AllGroupsDataSource : NSObject <SGridDataSource>
{
    NSInteger sortedColumn;
    NSComparisonResult sortedResult;
}

@property (nonatomic, strong) NSArray *groupArray;
@property (nonatomic, assign) id<AllGroupsDataSourceDelegate> delegate;

@end
