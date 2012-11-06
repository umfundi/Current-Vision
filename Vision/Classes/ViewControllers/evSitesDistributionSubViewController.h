//
//  evSitesDistributionSubViewController.h
//  Vision
//
//  Created by Jin on 11/2/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>

@class SitesDistributionAggrItem;
@class BrandListDataSource;
@class ProductListDataSource;
@class SitesDistributionSubDataSource;

@interface evSitesDistributionSubViewController : UIViewController <SGridDelegate>
{
    IBOutlet UIImageView *imgLogo;
    IBOutlet UIButton *btnDone;
    
    ShinobiGrid *filterListGrid;
    BrandListDataSource *brandListDataSource;
    ProductListDataSource *productListDataSource;

    ShinobiGrid *sitesDistributionGrid;
    SitesDistributionSubDataSource *sitesDistributionDataSource;
}

@property (nonatomic, retain) NSArray *selectedBrands;
@property (nonatomic, retain) NSArray *selectedProducts;
@property (nonatomic, retain) SitesDistributionAggrItem *aggrItem;

- (IBAction)doneClicked:(id)sender;

- (void)applyTheme:(BOOL)redTheme;

@end
