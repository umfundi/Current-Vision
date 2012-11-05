//
//  CountiesViewController.h
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>

#import "AllCountiesDataSource.h"

@protocol AllCountiesDelegate <NSObject>

- (void)countySelected:(NSString *)selected;

@end

@interface AllCountiesViewController : UIViewController<SGridDataSource, SGridDelegate, AllCountiesDataSourceDelegate>
{
    ShinobiGrid *countyGrid;
    AllCountiesDataSource *dataSource;
}

@property (strong, nonatomic) NSArray *searchResult;
@property (strong, nonatomic) id<AllCountiesDelegate> delegate;

- (CGSize)contentSizeForViewInPopover;

@end
