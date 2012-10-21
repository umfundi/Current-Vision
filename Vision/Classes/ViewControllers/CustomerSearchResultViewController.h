//
//  CustomerSearchResultViewController.h
//  Vision
//
//  Created by Ian Molesworth on 10/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>

@class Customer;
@class CustomerSearchResultDataSource;

@protocol CustomerSearchSelectDelegate <NSObject>

- (void)customerSelected:(Customer *)selected;

@end

@interface CustomerSearchResultViewController : UIViewController<SGridDataSource, SGridDelegate>
{
    ShinobiGrid *customerGrid;
    CustomerSearchResultDataSource *dataSource;
}

@property (strong, nonatomic) NSArray *searchResult;
@property (strong, nonatomic) id<CustomerSearchSelectDelegate> delegate;

- (CGSize)contentSizeForViewInPopover;

@end
