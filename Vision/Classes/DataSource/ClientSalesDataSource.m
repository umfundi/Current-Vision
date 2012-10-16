//
//  ClientSalesDataSource.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ClientSalesDataSource.h"

#import "ClientSalesAggr.h"
#import "ClientSalesAggrPerGroup.h"

@implementation ClientSalesDataSource

@synthesize clientSalesAggr;

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
                cellText = NSLocalizedString(@"Rank", @"");
                break;
            case 1:
                cellText = NSLocalizedString(@"Buying Group", @"");
                break;
            case 2:
                cellText = NSLocalizedString(@"Jan", @"");
                break;
            case 3:
                cellText = NSLocalizedString(@"Feb", @"");
                break;
            case 4:
                cellText = NSLocalizedString(@"Mar", @"");
                break;
            case 5:
                cellText = NSLocalizedString(@"Apr", @"");
                break;
            case 6:
                cellText = NSLocalizedString(@"May", @"");
                break;
            case 7:
                cellText = NSLocalizedString(@"Jun", @"");
                break;
            case 8:
                cellText = NSLocalizedString(@"Jul", @"");
                break;
            case 9:
                cellText = NSLocalizedString(@"Aug", @"");
                break;
            case 10:
                cellText = NSLocalizedString(@"Sep", @"");
                break;
            case 11:
                cellText = NSLocalizedString(@"Oct", @"");
                break;
            case 12:
                cellText = NSLocalizedString(@"Nov", @"");
                break;
            case 13:
                cellText = NSLocalizedString(@"Dec", @"");
                break;
            case 14:
                cellText = clientSalesAggr.year;
                break;
            case 15:
                cellText = NSLocalizedString(@"% Tot", @"");
                break;
            case 16:
                cellText = clientSalesAggr.lastyear;
                break;
            case 17:
                cellText = NSLocalizedString(@"+/- %", @"");
                break;
            case 18:
                cellText = NSLocalizedString(@"+/-", @"");
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
        
        ClientSalesAggrPerGroup *aggrPerGroup = [clientSalesAggr.aggrPerGroups objectAtIndex:gridCoord.rowIndex - 1];
        
        NSString *cellText;
        switch (gridCoord.column)
        {
            case 0:
                cellText = aggrPerGroup.rank;
                break;
            case 1:
                cellText = aggrPerGroup.group;
                break;
            case 2:
                cellText = aggrPerGroup.janString;
                break;
            case 3:
                cellText = aggrPerGroup.febString;
                break;
            case 4:
                cellText = aggrPerGroup.marString;
                break;
            case 5:
                cellText = aggrPerGroup.aprString;
                break;
            case 6:
                cellText = aggrPerGroup.mayString;
                break;
            case 7:
                cellText = aggrPerGroup.junString;
                break;
            case 8:
                cellText = aggrPerGroup.julString;
                break;
            case 9:
                cellText = aggrPerGroup.augString;
                break;
            case 10:
                cellText = aggrPerGroup.sepString;
                break;
            case 11:
                cellText = aggrPerGroup.octString;
                break;
            case 12:
                cellText = aggrPerGroup.novString;
                break;
            case 13:
                cellText = aggrPerGroup.decString;
                break;
            case 14:
                cellText = aggrPerGroup.yearsumString;
                break;
            case 15:
                cellText = aggrPerGroup.totpro;
                break;
            case 16:
                cellText = aggrPerGroup.lastyearsumString;
                break;
            case 17:
                cellText = aggrPerGroup.diffpro;
                break;
            case 18:
                cellText = aggrPerGroup.diffsum;
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
    return 19;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    return [clientSalesAggr.aggrPerGroups count] + 1;
}

@end
