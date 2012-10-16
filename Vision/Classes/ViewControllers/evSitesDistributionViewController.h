//
//  evSitesDistributionViewController.h
//  Vision
//
//  Created by Ian Molesworth on 23/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>

@class SitesDistributionDataSource;
@class BrandListDataSource;
@class ProductListDataSource;

@interface evSitesDistributionViewController : UIViewController <SGridDelegate>
{
    ShinobiGrid *brandListGrid;
    BrandListDataSource *brandListDataSource;
    ShinobiGrid *sitesDistByBrandGrid;
    SitesDistributionDataSource *sitesDistByBrandDataSource;

    ShinobiGrid *productListGrid;
    ProductListDataSource *productListDataSource;
    ShinobiGrid *sitesDistByProductGrid;
    SitesDistributionDataSource *sitesDistByProductDataSource;
    
    NSInteger selectedBrand;
    NSInteger selectedProduct;
}

- (IBAction)filterbyBrandClicked:(id)sender;
- (IBAction)filterbyProductClicked:(id)sender;

@end
