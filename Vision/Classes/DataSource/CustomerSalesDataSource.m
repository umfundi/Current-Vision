//
//  CustomerSalesDataSource.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "CustomerSalesDataSource.h"

#import "CustomerSalesAggr.h"
#import "CustomerSalesAggrPerYear.h"
#import "CustomerSalesAggrPerCustomer.h"

@implementation CustomerSalesDataSource

@synthesize customerSalesAggr;
@synthesize isYTD;
@synthesize isFull;

#pragma mark -
#pragma mark ShinobiGridDataSource

- (NSString *)shinobiGrid:(ShinobiGrid *)grid textForGridCoord:(const SGridCoord *) gridCoord
{
    NSString *cellText;

    if (gridCoord.section == 0)
    {
        switch (gridCoord.column)
        {
            case 0:
                cellText = (!isYTD && !isFull) ? NSLocalizedString(@"Period", @"") : NSLocalizedString(@"Year", @"");
                break;
            case 1:
                cellText = customerSalesAggr.monthArray[0];
                break;
            case 2:
                cellText = customerSalesAggr.monthArray[1];
                break;
            case 3:
                cellText = customerSalesAggr.monthArray[2];
                break;
            case 4:
                cellText = NSLocalizedString(@"Tot. Q-1", @"");
                break;
            case 5:
                cellText = customerSalesAggr.monthArray[3];
                break;
            case 6:
                cellText = customerSalesAggr.monthArray[4];
                break;
            case 7:
                cellText = customerSalesAggr.monthArray[5];
                break;
            case 8:
                cellText = NSLocalizedString(@"Tot. Q-2", @"");
                break;
            case 9:
                cellText = customerSalesAggr.monthArray[6];
                break;
            case 10:
                cellText = customerSalesAggr.monthArray[7];
                break;
            case 11:
                cellText = customerSalesAggr.monthArray[8];
                break;
            case 12:
                cellText = NSLocalizedString(@"Tot. Q-3", @"");
                break;
            case 13:
                cellText = customerSalesAggr.monthArray[9];
                break;
            case 14:
                cellText = customerSalesAggr.monthArray[10];
                break;
            case 15:
                cellText = customerSalesAggr.monthArray[11];
                break;
            case 16:
                cellText = NSLocalizedString(@"Tot. Q-4", @"");
                break;
            case 17:
                cellText = NSLocalizedString(@"Value", @"");
                break;
            case 18:
                cellText = NSLocalizedString(@"Growth", @"");
                break;
            case 19:
                cellText = NSLocalizedString(@"Qty", @"");
                break;
            case 20:
                cellText = NSLocalizedString(@"Growth", @"");
                break;
            default:
                cellText = @"";
                break;
        }
    }
    else
    {
        CustomerSalesAggrPerCustomer *aggrPerGroup = [customerSalesAggr.aggrPerCustomers objectAtIndex:gridCoord.section - 1];
        CustomerSalesAggrPerYear *aggrPerYear = [aggrPerGroup.aggrPerYears objectAtIndex:gridCoord.rowIndex];
        
        switch (gridCoord.column)
        {
            case 0:
                cellText = aggrPerYear.year;
                break;
            case 1:
                cellText = aggrPerYear.monthValStringArray[0];
                break;
            case 2:
                cellText = aggrPerYear.monthValStringArray[1];
                break;
            case 3:
                cellText = aggrPerYear.monthValStringArray[2];
                break;
            case 4:
                cellText = aggrPerYear.totq1;
                break;
            case 5:
                cellText = aggrPerYear.monthValStringArray[3];
                break;
            case 6:
                cellText = aggrPerYear.monthValStringArray[4];
                break;
            case 7:
                cellText = aggrPerYear.monthValStringArray[5];
                break;
            case 8:
                cellText = aggrPerYear.totq2;
                break;
            case 9:
                cellText = aggrPerYear.monthValStringArray[6];
                break;
            case 10:
                cellText = aggrPerYear.monthValStringArray[7];
                break;
            case 11:
                cellText = aggrPerYear.monthValStringArray[8];
                break;
            case 12:
                cellText = aggrPerYear.totq3;
                break;
            case 13:
                cellText = aggrPerYear.monthValStringArray[9];
                break;
            case 14:
                cellText = aggrPerYear.monthValStringArray[10];
                break;
            case 15:
                cellText = aggrPerYear.monthValStringArray[11];
                break;
            case 16:
                cellText = aggrPerYear.totq4;
                break;
            case 17:
                cellText = aggrPerYear.value;
                break;
            case 18:
                cellText = aggrPerYear.growth;
                break;
            case 19:
                cellText = aggrPerYear.qty;
                break;
            case 20:
                cellText = aggrPerYear.qtygrowth;
                break;
            default:
                cellText = @"";
                break;
        }
    }
    
    return cellText;
}

- (SGridCell *)shinobiGrid:(ShinobiGrid *)grid cellForGridCoord:(const SGridCoord *) gridCoord
{
    NSString *cellText = [self shinobiGrid:grid textForGridCoord:gridCoord];
    
    if (gridCoord.section == 0)
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
        cell.textField.textAlignment = UITextAlignmentLeft;
        cell.textField.font = [UIFont fontWithName:@"Arial" size:15.0f];
        
        cell.textField.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];

        cell.textField.text = cellText;
        
        return cell;
    }
}

- (NSUInteger)numberOfColsForShinobiGrid:(ShinobiGrid *)grid
{
    return 21;
}

- (NSUInteger) numberOfSectionsInShinobiGrid:(ShinobiGrid *) grid
{
    return [customerSalesAggr.aggrPerCustomers count] + 1;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    if (sectionIndex == 0)
        return 1;
    
    CustomerSalesAggrPerCustomer *aggrPerGroup = [customerSalesAggr.aggrPerCustomers objectAtIndex:sectionIndex - 1];
    return [aggrPerGroup.aggrPerYears count];
}

//Return the titles for the sections
- (NSString *)shinobiGrid:(ShinobiGrid *)grid titleForHeaderInSection:(int)section
{
    if (section == 0)
        return nil;
    
    CustomerSalesAggrPerCustomer *aggrPerGroup = [customerSalesAggr.aggrPerCustomers objectAtIndex:section - 1];
    return aggrPerGroup.customerName;
}

- (UIView *)shinobiGrid:(ShinobiGrid *)grid viewForHeaderInSection:(int)section inFrame:(CGRect)frame
{
    NSString *title = [self shinobiGrid:grid titleForHeaderInSection:section];
    if (!title)
        return nil;
    
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 5, 0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.autoresizingMask = ~UIViewAutoresizingNone;
    [titleLabel setText:title];
    
    [headerView addSubview:titleLabel];
    
    return headerView;
}

@end
