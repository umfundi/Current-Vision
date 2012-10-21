//
//  umfundiViewController.h
//  Vision
//
//  Created by Ian Molesworth on 02/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>
#import "MBProgressHUD.h"
#import "PracticeSearchResultViewController.h"

@class Customer;
@class Practice;
@class SitesDataSource;
@class SalesDataSource;

@interface umfundiViewController : UIViewController <UITextFieldDelegate, PracticeSearchSelectDelegate, SGridDelegate>
{
    IBOutlet UITextField *accountNoField;
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *addressField;
    IBOutlet UITextField *townField;
    IBOutlet UITextField *countryField;
    IBOutlet UITextField *practiceField;
    IBOutlet UITextField *KAMField;
    IBOutlet UITextField *postcodeField;
    IBOutlet UITextField *brickField;
    IBOutlet UITextField *SAPCodeField;
    IBOutlet UITextField *MonthField;
    IBOutlet UITextField *YTDField;
    IBOutlet UITextField *MATField;
    
    // For Theme
    IBOutlet UIButton *aboutButton;
    IBOutlet UILabel *selectLabel;
    IBOutlet UIButton *accountButton;
    IBOutlet UIButton *nameButton;
    IBOutlet UIButton *townButton;
    IBOutlet UIButton *postcodeButton;
    IBOutlet UIButton *salesButton;
    IBOutlet UIButton *sitesButton;
    IBOutlet UIButton *salesTrendButton;
    IBOutlet UIButton *productSalesButton;
    IBOutlet UIButton *erReportButton;
    IBOutlet UIButton *clientSalesButton;
    IBOutlet UIButton *sitesDistributionButton;
    IBOutlet UIButton *customerSalesButton;
    
    // For Search
    IBOutlet UITextField *searchField;
    
    NSArray *searchResults;
    UIPopoverController *searchPopoverController;
    MBProgressHUD *HUDSearch;
    MBProgressHUD *HUDProcessing;
    
//    PracticeSearchResultDataSource *dataSource;
    
    // Sites & Sales
    ShinobiGrid *sitesGrid, *salesGrid;
    SitesDataSource *sitesDataSource;
    SalesDataSource *salesDataSource;
}

@property (strong, nonatomic) Customer *currentCustomer;
@property (strong, nonatomic) Practice *currentPractice;

- (IBAction)searchClicked:(id)sender;

- (IBAction)setSites:(id)sender;
- (IBAction)setSales:(id)sender;
- (IBAction)SyncData:(id)sender;

- (void)displayCustomer;
- (void)displayPractice;

- (void)applyTheme:(BOOL)redTheme;

- (void)searchThread:(id)sender;
- (void)searchFinished:(id)sender;

@end
