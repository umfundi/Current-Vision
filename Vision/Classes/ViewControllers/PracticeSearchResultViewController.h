//
//  PracticeSearchResultViewController.h
//  Vision
//
//  Created by Ian Molesworth on 21/10/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>
#import "PracticeSearchResultDataSource.h"

@class Practice;

@protocol PracticeSearchSelectDelegate <NSObject>

- (void)practiceSelected:(Practice *)selected;

@end

@interface PracticeSearchResultViewController : UIViewController<SGridDataSource, SGridDelegate, PracticeSearchResultDataSourceDelegate>
{
    ShinobiGrid *practiceGrid;
    PracticeSearchResultDataSource *dataSource;
}

@property (strong, nonatomic) NSArray *searchResult;
@property (strong, nonatomic) id<PracticeSearchSelectDelegate> delegate;

- (CGSize)contentSizeForViewInPopover;

@end
