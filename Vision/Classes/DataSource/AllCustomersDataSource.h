//
//  AllCustomersDataSource.h
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@protocol AllCustomersDataSourceDelegate <NSObject>

- (void)gridSorted;

@end

@interface AllCustomersDataSource : NSObject <SGridDataSource>
{
    NSInteger sortedColumn;
    NSComparisonResult sortedResult;
}

@property (nonatomic, strong) NSArray *customerArray;
@property (nonatomic, assign) id<AllCustomersDataSourceDelegate> delegate;

@end
