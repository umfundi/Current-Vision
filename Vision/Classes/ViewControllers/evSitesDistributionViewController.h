//
//  evSitesDistributionViewController.h
//  Vision
//
//  Created by Ian Molesworth on 23/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>

#import "SitesDistributionAggr.h"
#import "SitesDistributionDataSource.h"
#import "MBProgressHUD.h"

@class User;

@class BrandListDataSource;
@class ProductListDataSource;

@interface evSitesDistributionViewController : UIViewController <SGridDelegate, SitesDistributionDataSourceDelegate>
{
    IBOutlet UILabel *lblThemeBox;
    IBOutlet UIImageView *imgLogo;
    IBOutlet UIButton *btnDone;
    IBOutlet UIButton *btnEmail;
    IBOutlet UIButton *btnCharts;
    IBOutlet UIButton *btnFilterByBrands;
    IBOutlet UIButton *btnFilterByProducts;
    
    ShinobiGrid *brandListGrid;
    BrandListDataSource *brandListDataSource;
    ShinobiGrid *sitesDistByBrandGrid;
    SitesDistributionDataSource *sitesDistByBrandDataSource;

    ShinobiGrid *productListGrid;
    ProductListDataSource *productListDataSource;
    ShinobiGrid *sitesDistByProductGrid;
    SitesDistributionDataSource *sitesDistByProductDataSource;
    
    SitesDistributionPeriod selectedPeriod;
    
    IBOutlet UIButton *btnPrevYear;
    IBOutlet UIButton *btnCurYear;
    IBOutlet UIButton *btnYTD;
    
    MBProgressHUD *HUDProcessing;
}

@property (nonatomic, retain) User *selectedUser;

- (IBAction)doneClicked:(id)sender;

- (IBAction)prevYearClicked:(id)sender;
- (IBAction)curYearClicked:(id)sender;
- (IBAction)YTDClicked:(id)sender;

- (IBAction)filterbyBrandClicked:(id)sender;
- (IBAction)filterbyProductClicked:(id)sender;

- (void)applyTheme:(BOOL)redTheme;

@end
