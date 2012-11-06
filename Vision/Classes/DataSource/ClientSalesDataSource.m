//
//  ClientSalesDataSource.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ClientSalesDataSource.h"

#import "ClientSalesAggr.h"
#import "ClientSalesAggrPerGroup.h"
#import "UIUnderlinedButton.h"

@implementation ClientSalesDataSource

@synthesize clientSalesAggr;
@synthesize delegate;

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
                cellText = clientSalesAggr.monthArray[gridCoord.column - 2];
                break;
        }
        
        cell.textField.text = cellText;
        
        return cell;
    }
    else
    {
        ClientSalesAggrPerGroup *aggrPerGroup = [clientSalesAggr.aggrPerGroups objectAtIndex:gridCoord.rowIndex - 1];

        if (aggrPerGroup.aggrPerPractices && gridCoord.column == 1)
        {
            SGridCell *cell = (SGridCell *)[grid dequeueReusableCellWithIdentifier:@"buttonCell"];
            if (!cell)
                cell = [[SGridCell alloc] initWithReuseIdentifier:@"buttonCell"];
            else
            {
                for (UIView *subview in cell.subviews)
                    [subview removeFromSuperview];
            }

            UIUnderlinedButton *titleButton = [UIUnderlinedButton underlinedButtonWithOrder:NSOrderedSame];
            titleButton.backgroundColor = [UIColor whiteColor];
            titleButton.autoresizingMask = ~UIViewAutoresizingNone;
            if (titleButton.underline)
            {
                [titleButton addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [titleButton setShowsTouchWhenHighlighted:YES];
            }
            [titleButton setFrame:cell.bounds];
            [titleButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:15.0f]];
            [titleButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [titleButton setTitle:aggrPerGroup.group forState:UIControlStateNormal];
            [titleButton setFrame:CGRectMake(titleButton.frame.origin.x, titleButton.frame.origin.y,
                                             titleButton.titleLabel.frame.size.width, titleButton.frame.size.height)];
            titleButton.tag = gridCoord.rowIndex;
            
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
            cell.textField.textAlignment = UITextAlignmentLeft;
            
            cell.textField.backgroundColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor whiteColor];
            
            NSString *cellText;
            switch (gridCoord.column)
            {
                case 0:
                    cellText = aggrPerGroup.rank;
                    break;
                case 1:
                    cellText = aggrPerGroup.group;
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
                    cellText = aggrPerGroup.monthValStringArray[gridCoord.column - 2];
                    break;
            }
            
            cell.textField.text = cellText;

            return cell;
        }
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

- (void)titleButtonClicked:(id)sender
{
    ClientSalesAggrPerGroup *aggrPerGroup = [clientSalesAggr.aggrPerGroups objectAtIndex:[sender tag] - 1];
    
    [delegate performSelector:@selector(groupSelected:) withObject:aggrPerGroup];
}

@end
