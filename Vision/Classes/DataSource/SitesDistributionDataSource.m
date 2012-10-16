//
//  SitesDistributionDataSource.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SitesDistributionDataSource.h"

#import "SitesDistributionAggr.h"
#import "SitesDistributionAggrItem.h"

@implementation SitesDistributionDataSource

@synthesize sitesDistributionAggr;

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
                cellText = @"";
                break;
            case 1:
                cellText = NSLocalizedString(@"Cur Sites", @"");
                break;
            case 2:
                cellText = NSLocalizedString(@"Prv Qtr", @"");
                break;
            case 3:
                cellText = NSLocalizedString(@"Cur Qtr", @"");
                break;
            case 4:
                cellText = NSLocalizedString(@"Change", @"");
                break;
            case 5:
                cellText = NSLocalizedString(@"Prv Qtr Avg", @"");
                break;
            case 6:
                cellText = NSLocalizedString(@"Cur Qtr Avg", @"");
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
        cell.textField.textAlignment = UITextAlignmentRight;
        cell.textField.font = [UIFont fontWithName:@"Courier" size:15.0f];
        
        cell.textField.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        
        NSString *cellText;
        switch (gridCoord.column)
        {
            case 0:
                switch (gridCoord.rowIndex)
            {
                case 0:
                    cellText = @"Retained";
                    break;
                case 1:
                    cellText = @"Gained";
                    break;
                case 2:
                    cellText = @"Lost";
                    break;
                case 3:
                    cellText = @"Total";
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
                    cellText = sitesDistributionAggr.retainedItem.cursitesString;
                    break;
                case 1:
                    cellText = sitesDistributionAggr.gainedItem.cursitesString;
                    break;
                case 2:
                    cellText = sitesDistributionAggr.lostItem.cursitesString;
                    break;
                case 3:
                    cellText = sitesDistributionAggr.totalItem.cursitesString;
                    break;
            }
                break;
            case 2:
                switch (gridCoord.rowIndex)
            {
                case 0:
                    cellText = sitesDistributionAggr.retainedItem.prvqtrString;
                    break;
                case 1:
                    cellText = sitesDistributionAggr.gainedItem.prvqtrString;
                    break;
                case 2:
                    cellText = sitesDistributionAggr.lostItem.prvqtrString;
                    break;
                case 3:
                    cellText = sitesDistributionAggr.totalItem.prvqtrString;
                    break;
            }
                break;
            case 3:
            {
                switch (gridCoord.rowIndex)
                {
                    case 0:
                        cellText = sitesDistributionAggr.retainedItem.curqtrString;
                        break;
                    case 1:
                        cellText = sitesDistributionAggr.gainedItem.curqtrString;
                        break;
                    case 2:
                        cellText = sitesDistributionAggr.lostItem.curqtrString;
                        break;
                    case 3:
                        cellText = sitesDistributionAggr.totalItem.curqtrString;
                        break;
                }
                break;
            }
            case 4:
            {
                switch (gridCoord.rowIndex)
                {
                    case 0:
                        cellText = sitesDistributionAggr.retainedItem.changeString;
                        break;
                    case 1:
                        cellText = sitesDistributionAggr.gainedItem.changeString;
                        break;
                    case 2:
                        cellText = sitesDistributionAggr.lostItem.changeString;
                        break;
                    case 3:
                        cellText = sitesDistributionAggr.totalItem.changeString;
                        break;
                }
                break;
            }
            case 5:
            {
                switch (gridCoord.rowIndex)
                {
                    case 0:
                        cellText = sitesDistributionAggr.retainedItem.prvqtrAvg;
                        break;
                    case 1:
                        cellText = sitesDistributionAggr.gainedItem.prvqtrAvg;
                        break;
                    case 2:
                        cellText = sitesDistributionAggr.lostItem.prvqtrAvg;
                        break;
                    case 3:
                        cellText = sitesDistributionAggr.totalItem.prvqtrAvg;
                        break;
                }
                break;
            }
            case 6:
            {
                switch (gridCoord.rowIndex)
                {
                    case 0:
                        cellText = sitesDistributionAggr.retainedItem.curqtrAvg;
                        break;
                    case 1:
                        cellText = sitesDistributionAggr.gainedItem.curqtrAvg;
                        break;
                    case 2:
                        cellText = sitesDistributionAggr.lostItem.curqtrAvg;
                        break;
                    case 3:
                        cellText = sitesDistributionAggr.totalItem.curqtrAvg;
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
    return 7;
}

- (NSUInteger)numberOfSectionsInShinobiGrid:(ShinobiGrid *)grid
{
    if (sitesDistributionAggr)
        return 2;
    return 1;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    if (sectionIndex == 0)
        return 1;
    return 4;
}

@end
