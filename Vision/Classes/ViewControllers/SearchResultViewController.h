//
//  SearchResultViewController.h
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>

@class Customer;
@class SearchResultDataSource;

@protocol SearchSelectDelegate <NSObject>

- (void)customerSelected:(Customer *)selected;

@end

@interface SearchResultViewController : UIViewController<SGridDataSource, SGridDelegate>
{
    ShinobiGrid *customerGrid;
    SearchResultDataSource *dataSource;
}

@property (strong, nonatomic) NSArray *searchResult;
@property (strong, nonatomic) id<SearchSelectDelegate> delegate;

- (CGSize)contentSizeForViewInPopover;

@end
