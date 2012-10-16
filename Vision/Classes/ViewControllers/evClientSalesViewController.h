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

@interface evClientSalesViewController : UIViewController <SGridDelegate>
{
    ShinobiGrid *clientSalesGrid;
    ClientSalesDataSource *clientSalesDataSource;
}

@end
