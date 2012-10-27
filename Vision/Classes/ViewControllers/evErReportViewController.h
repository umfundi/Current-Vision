//
//  evErReportViewController.h
//  Vision
//
//  Created by Ian Molesworth on 23/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>

@class Practice;
@class ErReportDataSource;

@interface evErReportViewController : UIViewController <SGridDelegate>
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
    IBOutlet UIButton *btnCustomer;
    IBOutlet UIButton *btnBGroup;
    IBOutlet UIButton *btnKAM;
    IBOutlet UIButton *btnPractice;
    IBOutlet UIButton *btnCounty;
    IBOutlet UIButton *btnCountry;
    IBOutlet UITextField *findText;
    
    ShinobiGrid *erReportGrid;
    ErReportDataSource *erReportDataSource;
    
    NSInteger currentFilter;
    
}

@property (nonatomic, retain) Practice *selectedPractice;

@end
