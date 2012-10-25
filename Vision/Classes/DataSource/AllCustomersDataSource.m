//
//  AllCustomersDataSource.m
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "AllCustomersDataSource.h"

#import "Customer.h"
#import "CustomerAggr.h"

@implementation AllCustomersDataSource

@synthesize customerArray;

#pragma mark -
#pragma mark ShinobiGridDataSource

- (SGridCell *)shinobiGrid:(ShinobiGrid *)grid cellForGridCoord:(const SGridCoord *) gridCoord
{
    if (gridCoord.rowIndex == 0)
    {
        SGridTextCell *cell = (SGridTextCell *)[grid dequeueReusableCellWithIdentifier:@"headerCell"];
        if (!cell)
        {
            cell = [[SGridTextCell alloc] initWithReuseIdentifier:@"headerCell"];
        }
        
        cell.textField.textAlignment = UITextAlignmentCenter;
        cell.textField.backgroundColor = [UIColor darkGrayColor];
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.textField.textColor = [UIColor whiteColor];
        
        cell.textField.font = [UIFont fontWithName:@"Verdana-Bold" size:14.f];
        
        NSString *cellText;
        switch (gridCoord.column)
        {
            case 0:
                cellText = NSLocalizedString(@"id_customer", @"");
                break;
            case 1:
                cellText = NSLocalizedString(@"Name", @"");
                break;
            case 2:
                cellText = NSLocalizedString(@"Address", @"");
                break;
            case 3:
                cellText = NSLocalizedString(@"Town", @"");
                break;
            case 4:
                cellText = NSLocalizedString(@"County", @"");
                break;
            case 5:
                cellText = NSLocalizedString(@"Postcode", @"");
                break;
            case 6:
                cellText = NSLocalizedString(@"MthValue", @"");
                break;
            case 7:
                cellText = NSLocalizedString(@"YTDValue", @"");
                break;
            case 8:
                cellText = NSLocalizedString(@"MATValue", @"");
                break;
            default:
                cellText = @"";
                break;
        }
        
        cell.textField.text = cellText;
        
        return cell;
    }
    else
    {
        SGridTextCell *cell = (SGridTextCell *)[grid dequeueReusableCellWithIdentifier:@"valueCell"];
        if (!cell)
            cell = [[SGridTextCell alloc] initWithReuseIdentifier:@"valueCell"];
        
        cell.textField.font = [UIFont fontWithName:@"Courier" size:15.0f];
        cell.textField.textColor = [UIColor blackColor];
        cell.textField.textAlignment = UITextAlignmentLeft;
        cell.textField.font = [UIFont fontWithName:@"Courier" size:15.0f];
        
        cell.textField.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        
        Customer *customer = [customerArray objectAtIndex:gridCoord.rowIndex - 1];
        
        NSString *cellText;
        switch (gridCoord.column)
        {
            case 0:
                cellText = customer.id_customer;
                break;
            case 1:
                cellText = customer.customerName;
                break;
            case 2:
                cellText = customer.address1;
                break;
            case 3:
                cellText = customer.province;
                break;
            case 4:
                cellText = customer.city;
                break;
            case 5:
                cellText = customer.postcode;
                break;
            case 6:
                cellText = customer.aggrValue.monthString;
                break;
            case 7:
                cellText = customer.aggrValue.ytdString;
                break;
            case 8:
                cellText = customer.aggrValue.matString;
                break;
            default:
                cellText = @"";
                break;
        }
        
        cell.textField.text = cellText;
        
        return cell;
    }
}

- (NSUInteger)numberOfColsForShinobiGrid:(ShinobiGrid *)grid
{
    return 9;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    return [customerArray count] + 1;
}

@end
