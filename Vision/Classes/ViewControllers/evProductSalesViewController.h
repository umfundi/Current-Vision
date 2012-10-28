//
//  evProductSalesViewController.h
//  Vision
//
//  Created by Ian Molesworth on 23/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>

#import "AllCustomersViewController.h"
#import "AllPracticesViewController.h"
#import "AllCountiesViewController.h"
#import "AllKeyAccountManagersViewController.h"
#import "AllGroupsViewController.h"
#import "AllCountriesViewController.h"

@class User;
@class Practice;
@class ProductSalesDataSource;

@interface evProductSalesViewController : UIViewController <SGridDelegate, AllCustomersDelegate, AllPracticesDelegate, AllCountiesDelegate, AllKeyAccountManagersDelegate, AllGroupsDelegate, AllCountriesDelegate>
{
    IBOutlet UILabel *lblThemeBox;
    IBOutlet UILabel *lblPracticeName;
    IBOutlet UILabel *lblAddress1;
    IBOutlet UILabel *lblAddress2;
    IBOutlet UILabel *lblAddress3;
    IBOutlet UILabel *lblPracticeCode;
    IBOutlet UILabel *lblIDUser;
    IBOutlet UILabel *lblPostcode;
    IBOutlet UILabel *lblPracticeHdr;
    IBOutlet UILabel *lblAccountHdr;
    IBOutlet UILabel *lblAccmgrHdr;
    IBOutlet UILabel *lblCountryHdr;
    IBOutlet UILabel *lblCountyHdr;
    IBOutlet UILabel *lblBGroupHdr;
    IBOutlet UIButton *btnMAT;
    IBOutlet UIButton *btmYTD;
    IBOutlet UIButton *btnFull;
    IBOutlet UIButton *btnCustomer;
    IBOutlet UIButton *btnBGroup;
    IBOutlet UIButton *btnKAM;
    IBOutlet UIButton *btnPractice;
    IBOutlet UIButton *btnCounty;
    IBOutlet UIButton *btnCountry;
    IBOutlet UITextField *findText;
    
    ShinobiGrid *productSalesGrid;
    ProductSalesDataSource *productSalesDataSource;
    
    UIPopoverController *searchPopoverController;
    
    NSInteger currentFilter;
    BOOL isYTD;
}

@property (nonatomic, retain) Practice *selectedPractice;
@property (nonatomic, retain) User *selectedUser;
@property (nonatomic, retain) Customer *selectedCustomer;
@property (nonatomic, retain) NSString *selectedFilterVal;

- (IBAction)customerClicked:(id)sender;
- (IBAction)practiceClicked:(id)sender;
- (IBAction)countyClicked:(id)sender;
- (IBAction)keyAccountManagerClicked:(id)sender;
- (IBAction)groupClicked:(id)sender;
- (IBAction)countryClicked:(id)sender;

- (IBAction)ytdClicked:(id)sender;
- (IBAction)matClicked:(id)sender;
- (IBAction)fullClicked:(id)sender;

- (IBAction)findClicked:(id)sender;
- (IBAction)nextClicked:(id)sender;

- (void)displayGrids;

@end
