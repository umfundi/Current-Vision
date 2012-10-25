//
//  AllPracticesViewController.h
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>

@class Practice;
@class AllPracticesDataSource;

@protocol AllPracticesDelegate <NSObject>

- (void)practiceSelected:(Practice *)selected;

@end

@interface AllPracticesViewController : UIViewController<SGridDataSource, SGridDelegate>
{
    ShinobiGrid *practiceGrid;
    AllPracticesDataSource *dataSource;
}

@property (strong, nonatomic) NSArray *searchResult;
@property (strong, nonatomic) id<AllPracticesDelegate> delegate;

- (CGSize)contentSizeForViewInPopover;

@end
