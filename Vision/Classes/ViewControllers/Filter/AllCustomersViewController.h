//
//  AllCustomersViewController.h
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>

@class Customer;
@class AllCustomersDataSource;

@protocol AllCustomersDelegate <NSObject>

- (void)customerSelected:(Customer *)selected;

@end

@interface AllCustomersViewController : UIViewController<SGridDataSource, SGridDelegate>
{
    ShinobiGrid *customerGrid;
    AllCustomersDataSource *dataSource;
}

@property (strong, nonatomic) NSArray *searchResult;
@property (strong, nonatomic) id<AllCustomersDelegate> delegate;

- (CGSize)contentSizeForViewInPopover;

@end
