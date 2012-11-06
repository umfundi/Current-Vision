//
//  SitesDistributionPerCustomerDataSource.m
//  Vision
//
//  Created by Jin on 11/1/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SitesDistributionSubDataSource.h"

#import "SitesDistributionAggrItem.h"
#import "SitesDistributionAggrPerCustomer.h"

@implementation SitesDistributionSubDataSource

@synthesize sitesDistributionAggrItem;

#pragma mark -
#pragma mark ShinobiGridDataSource

- (SGridCell *)shinobiGrid:(ShinobiGrid *)grid cellForGridCoord:(const SGridCoord *) gridCoord
{
    if (gridCoord.section == 0)
    {
        SGridTextCell *cell = (SGridTextCell *)[grid dequeueReusableCellWithIdentifier:@"headerCell"];
        if (!cell)
            cell = [[SGridTextCell alloc] initWithReuseIdentifier:@"headerCell"];
        
        cell.textField.textAlignment = UITextAlignmentCenter;
        cell.textField.backgroundColor = [UIColor darkGrayColor];
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.textField.textColor = [UIColor whiteColor];
        
        cell.textField.font = [UIFont fontWithName:@"Verdana-Bold" size:14.f];
        
        NSString *cellText;
        switch (gridCoord.column)
        {
            case 0:
                cellText = NSLocalizedString(@"ID", @"");
                break;
            case 1:
                cellText = NSLocalizedString(@"Customer", @"");
                break;
            case 2:
                if (sitesDistributionAggrItem.type == Gained)
                    cellText = NSLocalizedString(@"Prv. Total", @"");
                else
                    cellText = NSLocalizedString(@"Cur. Total", @"");
                break;
            case 3:
                cellText = NSLocalizedString(@"Cur. Total", @"");
                break;
            case 4:
                cellText = NSLocalizedString(@"Growth", @"");
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
        
        cell.textField.font = [UIFont fontWithName:@"Arial" size:15.0f];
        cell.textField.textColor = [UIColor blackColor];
        cell.textField.textAlignment = UITextAlignmentRight;
        cell.textField.font = [UIFont fontWithName:@"Arial" size:15.0f];
        
        cell.textField.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        
        SitesDistributionAggrPerCustomer *aggrPerCustomer = [sitesDistributionAggrItem.aggrPerCustomerArray objectAtIndex:gridCoord.rowIndex];
        
        NSString *cellText;
        switch (gridCoord.column)
        {
            case 0:
                cellText = aggrPerCustomer.id_customer;
                break;
            case 1:
                cellText = aggrPerCustomer.customerName;
                break;
            case 2:
                if (sitesDistributionAggrItem.type == Gained)
                    cellText = aggrPerCustomer.curTotalString;
                else
                    cellText = aggrPerCustomer.prvTotalString;
                break;
            case 3:
                cellText = aggrPerCustomer.curTotalString;
                break;
            case 4:
                cellText = aggrPerCustomer.growthString;
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
    if (sitesDistributionAggrItem.type == Retained)
        return 5;
    return 3;
}

- (NSUInteger)numberOfSectionsInShinobiGrid:(ShinobiGrid *)grid
{
    if (sitesDistributionAggrItem)
        return 2;
    return 1;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    if (sectionIndex == 0)
        return 1;
    return [sitesDistributionAggrItem.aggrPerCustomerArray count];
}

@end
