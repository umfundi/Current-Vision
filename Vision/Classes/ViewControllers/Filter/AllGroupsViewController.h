//
//  AllGroupsViewController.h
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>

@class AllGroupsDataSource;

@protocol AllGroupsDelegate <NSObject>

- (void)groupSelected:(NSString *)selected;

@end

@interface AllGroupsViewController : UIViewController<SGridDataSource, SGridDelegate>
{
    ShinobiGrid *groupGrid;
    AllGroupsDataSource *dataSource;
}

@property (strong, nonatomic) NSArray *searchResult;
@property (strong, nonatomic) id<AllGroupsDelegate> delegate;

- (CGSize)contentSizeForViewInPopover;

@end
