//
//  evSitesDistributionViewController.h
//  Vision
//
//  Created by Ian Molesworth on 23/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>

@class User;

@class SitesDistributionDataSource;
@class BrandListDataSource;
@class ProductListDataSource;

@interface evSitesDistributionViewController : UIViewController <SGridDelegate>
{
    IBOutlet UIImageView *imgLogo;
    
    ShinobiGrid *brandListGrid;
    BrandListDataSource *brandListDataSource;
    ShinobiGrid *sitesDistByBrandGrid;
    SitesDistributionDataSource *sitesDistByBrandDataSource;

    ShinobiGrid *productListGrid;
    ProductListDataSource *productListDataSource;
    ShinobiGrid *sitesDistByProductGrid;
    SitesDistributionDataSource *sitesDistByProductDataSource;
}

@property (nonatomic, retain) User *selectedUser;

- (IBAction)filterbyBrandClicked:(id)sender;
- (IBAction)filterbyProductClicked:(id)sender;

- (void)applyTheme:(BOOL)redTheme;

@end
