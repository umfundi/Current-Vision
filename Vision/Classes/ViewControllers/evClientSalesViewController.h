//
//  evClientSalesViewController.h
//  Vision
//
//  Created by Ian Molesworth on 23/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiGrids/ShinobiGrid.h>

@class ClientSalesDataSource;
@class ProductListDataSource;

@interface evClientSalesViewController : UIViewController <SGridDelegate>
{
    ShinobiGrid *clientSalesGrid;
    ClientSalesDataSource *clientSalesDataSource;
    ShinobiGrid *productListGrid;
    ProductListDataSource *productListDataSource;
}

- (IBAction)clearButtonClicked:(id)sender;
- (IBAction)selectButtonClicked:(id)sender;

@end
