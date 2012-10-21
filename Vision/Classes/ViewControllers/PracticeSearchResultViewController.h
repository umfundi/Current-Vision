//
//  PracticeSearchResultViewController.h
//  Vision
//
//  Created by Ian Molesworth on 21/10/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>

@class Practice;
@class PracticeSearchResultDataSource;

@protocol PracticeSearchSelectDelegate <NSObject>

- (void)practiceSelected:(Practice *)selected;

@end

@interface PracticeSearchResultViewController : UIViewController
{
    ShinobiGrid *practiceGrid;
    PracticeSearchResultDataSource *pdataSource;
}

@property (strong, nonatomic) NSArray *searchResult;
@property (strong, nonatomic) id<PracticeSearchSelectDelegate> delegate;

- (CGSize)contentSizeForViewInPopover;
@end
