//
//  evClientSalesViewController.h
//  Vision
//
//  Created by Ian Molesworth on 23/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>
#import "ClientSalesDataSource.h"
#import "MBProgressHUD.h"

@class BrandListDataSource;

@interface evClientSalesViewController : UIViewController <SGridDelegate, ClientSalesDataSourceDelegate>
{
    ShinobiGrid *clientSalesGrid;
    ClientSalesDataSource *clientSalesDataSource;
    ShinobiGrid *brandListGrid;
    BrandListDataSource *brandListDataSource;
    
    ClientSalesAggr *clientSalesAggr;
    
    BOOL isYTD;
    
    IBOutlet UIImageView *imgLogo;
    IBOutlet UIButton *btnDone;
    IBOutlet UIButton *btnMAT;
    IBOutlet UIButton *btnYTD;
    IBOutlet UIButton *btnClear;
    IBOutlet UIButton *btnSelect;
    IBOutlet UIButton *btnSelFocus;
    IBOutlet UIButton *btnAll;

    MBProgressHUD *HUDProcessing;
}

- (IBAction)doneClicked:(id)sender;

- (IBAction)clearButtonClicked:(id)sender;
- (IBAction)selectButtonClicked:(id)sender;

- (IBAction)ytdClicked:(id)sender;
- (IBAction)matClicked:(id)sender;

- (IBAction)allClicked:(id)sender;

- (void)displayGrids;
- (void)applyTheme:(BOOL)redTheme;

@end
