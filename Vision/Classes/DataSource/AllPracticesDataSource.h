//
//  AllPracticesDataSource.h
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@protocol AllPracticesDataSourceDelegate <NSObject>

- (void)gridSorted;

@end

@interface AllPracticesDataSource : NSObject <SGridDataSource>
{
    NSInteger sortedColumn;
    NSComparisonResult sortedResult;
}

@property (nonatomic, strong) NSArray *practiceArray;
@property (nonatomic, assign) id<AllPracticesDataSourceDelegate> delegate;

@end
