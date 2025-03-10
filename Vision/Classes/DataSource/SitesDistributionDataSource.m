//
//  SitesDistributionDataSource.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SitesDistributionDataSource.h"

#import "SitesDistributionAggr.h"
#import "SitesDistributionAggrItem.h"
#import "UIUnderlinedButton.h"

@implementation SitesDistributionDataSource

@synthesize sitesDistributionAggr;
@synthesize delegate;

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
        if (gridCoord.column == 0)
        {
            SGridCell *cell = (SGridCell *)[grid dequeueReusableCellWithIdentifier:@"buttonCell"];
            if (!cell)
            {
                cell = [[SGridCell alloc] initWithReuseIdentifier:@"buttonCell"];
                cell.backgroundColor = [UIColor darkGrayColor];
            }
            else
            {
                for (UIView *subview in cell.subviews)
                    [subview removeFromSuperview];
            }
            
            UIUnderlinedButton *titleButton = [UIUnderlinedButton underlinedButtonWithOrder:NSOrderedSame];

            NSString *cellText;
            switch (gridCoord.rowIndex)
            {
                case 0:
                    cellText = @"Retained";
                    titleButton.underline = [sitesDistributionAggr.retainedItem.aggrPerCustomerArray count] > 0;
                    break;
                case 1:
                    cellText = @"Gained";
                    titleButton.underline =  [sitesDistributionAggr.gainedItem.aggrPerCustomerArray count] > 0;
                    break;
                case 2:
                    cellText = @"Lost";
                    titleButton.underline =  [sitesDistributionAggr.lostItem.aggrPerCustomerArray count] > 0;
                    break;
                case 3:
                    cellText = @"Total";
                    titleButton.underline = NO;
                    break;
                default:
                    cellText = @"";
                    titleButton.underline = NO;
                    break;
            }
            [titleButton setBackgroundColor:[UIColor whiteColor]];
            titleButton.autoresizingMask = ~UIViewAutoresizingNone;
            if (titleButton.underline)
            {
                [titleButton addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [titleButton setShowsTouchWhenHighlighted:YES];
            }
            [titleButton setFrame:cell.bounds];
            [titleButton.titleLabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:14.f]];
            [titleButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            titleButton.tag = gridCoord.rowIndex;
            
            [titleButton setTitle:cellText forState:UIControlStateNormal];
            [titleButton setFrame:CGRectMake(titleButton.frame.origin.x, titleButton.frame.origin.y,
                                             titleButton.titleLabel.frame.size.width, titleButton.frame.size.height)];
            
            [cell addSubview:titleButton];
            
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
            
            NSString *cellText;
            switch (gridCoord.column)
            {
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


- (void)titleButtonClicked:(id)sender
{
    switch ([sender tag])
    {
        case 0:
            [delegate aggrItemSelected:sitesDistributionAggr.retainedItem dataSource:self];
            break;
        case 1:
            [delegate aggrItemSelected:sitesDistributionAggr.gainedItem dataSource:self];
            break;
        case 2:
            [delegate aggrItemSelected:sitesDistributionAggr.lostItem dataSource:self];
            break;
    }
}

@end
