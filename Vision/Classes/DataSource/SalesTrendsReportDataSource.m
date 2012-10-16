//
//  SalesTrendsReportDataSource.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SalesTrendsReportDataSource.h"

#import "SalesTrendAggrPerBrand.h"

@implementation SalesTrendsReportDataSource

@synthesize isMonthReport;
@synthesize reportArray;

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
                cellText = NSLocalizedString(isMonthReport ? @"Month. Figures" : @"YTD Figures", @"");
                break;
            case 1:
                cellText = NSLocalizedString(@"Jan", @"");
                break;
            case 2:
                cellText = NSLocalizedString(@"Feb", @"");
                break;
            case 3:
                cellText = NSLocalizedString(@"Mar", @"");
                break;
            case 4:
                cellText = NSLocalizedString(@"Apr", @"");
                break;
            case 5:
                cellText = NSLocalizedString(@"May", @"");
                break;
            case 6:
                cellText = NSLocalizedString(@"Jun", @"");
                break;
            case 7:
                cellText = NSLocalizedString(@"Jul", @"");
                break;
            case 8:
                cellText = NSLocalizedString(@"Aug", @"");
                break;
            case 9:
                cellText = NSLocalizedString(@"Sep", @"");
                break;
            case 10:
                cellText = NSLocalizedString(@"Oct", @"");
                break;
            case 11:
                cellText = NSLocalizedString(@"Nov", @"");
                break;
            case 12:
                cellText = NSLocalizedString(@"Dec", @"");
                break;
            case 13:
                cellText = NSLocalizedString(@"Growth%", @"");
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
        
        SalesTrendAggrPerBrand *aggr = [reportArray objectAtIndex:gridCoord.rowIndex - 1];
        
        NSString *cellText;
        switch (gridCoord.column)
        {
            case 0:
                cellText = aggr.brand;
                break;
            case 1:
                cellText = aggr.janString;
                break;
            case 2:
                cellText = aggr.febString;
                break;
            case 3:
                cellText = aggr.marString;
                break;
            case 4:
                cellText = aggr.aprString;
                break;
            case 5:
                cellText = aggr.mayString;
                break;
            case 6:
                cellText = aggr.junString;
                break;
            case 7:
                cellText = aggr.julString;
                break;
            case 8:
                cellText = aggr.augString;
                break;
            case 9:
                cellText = aggr.sepString;
                break;
            case 10:
                cellText = aggr.octString;
                break;
            case 11:
                cellText = aggr.novString;
                break;
            case 12:
                cellText = aggr.decString;
                break;
            case 13:
                cellText = aggr.growthString;
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
    return 14;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    return [reportArray count] + 1;
}

@end
