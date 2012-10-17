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
    IBOutlet UILabel *lblPracticeName;
    IBOutlet UILabel *lblAddress1;
    IBOutlet UILabel *lblAddress2;
    IBOutlet UILabel *lblAddress3;
    IBOutlet UILabel *lblPracticeCode;
    IBOutlet UILabel *lblIDUser;
    IBOutlet UILabel *lblPostcode;
    
    ShinobiGrid *erReportGrid;
    ErReportDataSource *erReportDataSource;
}

@property (nonatomic, retain) Practice *selectedPractice;

@end
