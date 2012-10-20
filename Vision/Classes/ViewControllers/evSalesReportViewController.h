//
//  evSalesReportViewController.h
//  Vision
//
//  Created by Ian Molesworth on 22/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>

@class Practice;
@class SalesTrendsReportDataSource;

@interface evSalesReportViewController : UIViewController <SGridDelegate>
{
    IBOutlet UILabel *lblPracticeName;
    IBOutlet UILabel *lblAddress1;
    IBOutlet UILabel *lblAddress2;
    IBOutlet UILabel *lblAddress3;
    IBOutlet UILabel *lblPracticeCode;
    IBOutlet UILabel *lblIDUser;    
    IBOutlet UILabel *lblPostcode;
    ShinobiGrid *monthReportGrid;
    SalesTrendsReportDataSource *monthReportDataSource;

    ShinobiGrid *YTDReportGrid;
    SalesTrendsReportDataSource *YTDReportDataSource;
    
    ShinobiGrid *MATReportGrid;
    SalesTrendsReportDataSource *MATReportDataSource;
    
}

@property (nonatomic, retain) Practice *selectedPractice;

@end
