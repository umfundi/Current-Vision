//
//  evProductSalesViewController.h
//  Vision
//
//  Created by Ian Molesworth on 23/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>

@class Practice;
@class ProductSalesDataSource;

@interface evProductSalesViewController : UIViewController <SGridDelegate>
{
    IBOutlet UILabel *lblPracticeName;
    IBOutlet UILabel *lblAddress1;
    IBOutlet UILabel *lblAddress2;
    IBOutlet UILabel *lblAddress3;
    IBOutlet UILabel *lblPostcode;
    IBOutlet UILabel *lblPracticeCode;
    IBOutlet UILabel *lblIDUser;

    
    ShinobiGrid *productSalesGrid;
    ProductSalesDataSource *productSalesDataSource;
}

@property (nonatomic, retain) Practice *selectedPractice;

@end
