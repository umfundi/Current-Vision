//
//  KeyAccountManagerViewController.h
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>

@class AllKeyAccountManagersDataSource;

@protocol AllKeyAccountManagersDelegate <NSObject>

- (void)keyAccountManagerSelected:(NSString *)selected;

@end

@interface AllKeyAccountManagersViewController : UIViewController<SGridDataSource, SGridDelegate>
{
    ShinobiGrid *keyAccountManagerGrid;
    AllKeyAccountManagersDataSource *dataSource;
}

@property (strong, nonatomic) NSArray *searchResult;
@property (strong, nonatomic) id<AllKeyAccountManagersDelegate> delegate;

- (CGSize)contentSizeForViewInPopover;


@end
