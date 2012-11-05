//
//  AllKeyAccountManagersDataSource.h
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShinobiGrids/ShinobiGrid.h>

@protocol AllKeyAccountManagersDataSourceDelegate <NSObject>

- (void)gridSorted;

@end

@interface AllKeyAccountManagersDataSource : NSObject <SGridDataSource>
{
    NSInteger sortedColumn;
    NSComparisonResult sortedResult;
}

@property (nonatomic, strong) NSArray *keyAccountManagerArray;
@property (nonatomic, assign) id<AllKeyAccountManagersDataSourceDelegate> delegate;

@end
