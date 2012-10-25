//
//  AllCountriesViewController.h
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>

@class AllCountriesDataSource;

@protocol AllCountriesDelegate <NSObject>

- (void)countrySelected:(NSString *)selected;

@end

@interface AllCountriesViewController : UIViewController<SGridDataSource, SGridDelegate>
{
    ShinobiGrid *countryGrid;
    AllCountriesDataSource *dataSource;
}

@property (strong, nonatomic) NSArray *searchResult;
@property (strong, nonatomic) id<AllCountriesDelegate> delegate;

- (CGSize)contentSizeForViewInPopover;

@end
