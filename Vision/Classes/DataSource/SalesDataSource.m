//
//  SalesDataSource.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SalesDataSource.h"

#import "CustomerAggrPerBrand.h"

@implementation SalesDataSource

@synthesize salesArray;

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
                cellText = NSLocalizedString(@"Type", @"");
                break;
            case 1:
                cellText = NSLocalizedString(@"Previous", @"");
                break;
            case 2:
                cellText = NSLocalizedString(@"Current", @"");
                break;
            case 3:
                cellText = NSLocalizedString(@"%", @"");
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
        
        CustomerAggrPerBrand *aggrPerBrand = [salesArray objectAtIndex:gridCoord.section - 1];
        
        NSString *cellText;
        switch (gridCoord.column)
        {
            case 0:
                switch (gridCoord.rowIndex)
                {
                    case 0:
                        cellText = @"Month";
                        break;
                    case 1:
                        cellText = @"YTD";
                        break;
                    case 2:
                        cellText = @"MAT";
                        break;
                    default:
                        cellText = @"";
                        break;
                }
                break;
            case 1:
                switch (gridCoord.rowIndex)
                {
                    case 0:
                        cellText = aggrPerBrand.monthprvString;
                        break;
                    case 1:
                        cellText = aggrPerBrand.ytdprvString;
                        break;
                    case 2:
                        cellText = aggrPerBrand.matprvString;
                        break;
                }
                break;
            case 2:
                switch (gridCoord.rowIndex)
                {
                    case 0:
                        cellText = aggrPerBrand.monthString;
                        break;
                    case 1:
                        cellText = aggrPerBrand.ytdString;
                        break;
                    case 2:
                        cellText = aggrPerBrand.matString;
                        break;
                }
                break;
            case 3:
            {
                switch (gridCoord.rowIndex)
                {
                    case 0:
                        cellText = aggrPerBrand.monthpro;
                        break;
                    case 1:
                        cellText = aggrPerBrand.ytdpro;
                        break;
                    case 2:
                        cellText = aggrPerBrand.matpro;
                        break;
                }
                break;
            }
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
    return 4;
}

- (NSUInteger) numberOfSectionsInShinobiGrid:(ShinobiGrid *) grid
{
    return [salesArray count] + 1;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    if (sectionIndex == 0)
        return 1;
    return 3;
}

//Return the titles for the sections
- (NSString *)shinobiGrid:(ShinobiGrid *)grid titleForHeaderInSection:(int)section
{
    switch (section)
    {
        case 0:
            return @"Sales";
        default:
        {
            CustomerAggrPerBrand *aggrPerBrand = [salesArray objectAtIndex:section - 1];
            return aggrPerBrand.brand;
        }
    }
}

@end
