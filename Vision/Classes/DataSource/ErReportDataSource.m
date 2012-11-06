//
//  ErReportDataSource.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ErReportDataSource.h"

#import "ErReportAggr.h"
#import "ErReportAggrPerYear.h"
#import "ErReportAggrPerBrand.h"
#import "UIUnderlinedButton.h"

@implementation ErReportDataSource

@synthesize erReportAggr;
@synthesize delegate;
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
                cellText = erReportAggr.monthArray[0];
                break;
            case 2:
                cellText = erReportAggr.monthArray[1];
                break;
            case 3:
                cellText = erReportAggr.monthArray[2];
                break;
            case 4:
                cellText = NSLocalizedString(@"Tot. Q-1", @"");
                break;
            case 5:
                cellText = erReportAggr.monthArray[3];
                break;
            case 6:
                cellText = erReportAggr.monthArray[4];
                break;
            case 7:
                cellText = erReportAggr.monthArray[5];
                break;
            case 8:
                cellText = NSLocalizedString(@"Tot. Q-2", @"");
                break;
            case 9:
                cellText = erReportAggr.monthArray[6];
                break;
            case 10:
                cellText = erReportAggr.monthArray[7];
                break;
            case 11:
                cellText = erReportAggr.monthArray[8];
                break;
            case 12:
                cellText = NSLocalizedString(@"Tot. Q-3", @"");
                break;
            case 13:
                cellText = erReportAggr.monthArray[9];
                break;
            case 14:
                cellText = erReportAggr.monthArray[10];
                break;
            case 15:
                cellText = erReportAggr.monthArray[11];
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
        ErReportAggrPerBrand *aggrPerBrand = [erReportAggr.aggrPerBrands objectAtIndex:gridCoord.section - 1];
        ErReportAggrPerYear *aggrPerYear = [aggrPerBrand.aggrPerYears objectAtIndex:gridCoord.rowIndex];
        
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
    return [erReportAggr.aggrPerBrands count] + 1;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    if (sectionIndex == 0)
        return 1;
    
    ErReportAggrPerBrand *aggrPerBrand = [erReportAggr.aggrPerBrands objectAtIndex:sectionIndex - 1];
    return [aggrPerBrand.aggrPerYears count];
}

//Return the titles for the sections
- (NSString *)shinobiGrid:(ShinobiGrid *)grid titleForHeaderInSection:(int)section
{
    if (section == 0)
        return nil;
    
    ErReportAggrPerBrand *aggrPerBrand = [erReportAggr.aggrPerBrands objectAtIndex:section - 1];
    return aggrPerBrand.brand;
}

- (UIView *)shinobiGrid:(ShinobiGrid *)grid viewForHeaderInSection:(int)section inFrame:(CGRect)frame
{
    NSString *title = [self shinobiGrid:grid titleForHeaderInSection:section];
    if (!title)
        return nil;
    
    ErReportAggrPerBrand *aggrPerBrand = [erReportAggr.aggrPerBrands objectAtIndex:section - 1];

    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIUnderlinedButton *titleButton = [UIUnderlinedButton underlinedButtonWithOrder:NSOrderedSame];
    titleButton.underline = (aggrPerBrand.aggrPerProducts != nil);
    titleButton.backgroundColor = [UIColor clearColor];
    titleButton.autoresizingMask = ~UIViewAutoresizingNone;
    if (titleButton.underline)
    {
        [titleButton addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [titleButton setShowsTouchWhenHighlighted:YES];
        [self performSelector:@selector(enableButton:) withObject:headerView afterDelay:0.1];
    }
    [titleButton setFrame:CGRectInset(headerView.bounds, 5, 3)];
    [titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [titleButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton setTitle:title forState:UIControlStateNormal];
    [titleButton setFrame:CGRectMake(titleButton.frame.origin.x, titleButton.frame.origin.y,
                                     titleButton.titleLabel.frame.size.width, titleButton.frame.size.height)];
    [titleButton setTag:section];
    
    [headerView addSubview:titleButton];
    
    return headerView;
}

- (void)enableButton:(id)sender
{
    [[sender superview] setUserInteractionEnabled:YES];
}

- (void)titleButtonClicked:(id)sender
{
    ErReportAggrPerBrand *aggrPerBrand = [erReportAggr.aggrPerBrands objectAtIndex:[sender tag] - 1];
    
    [delegate performSelector:@selector(brandSelected:) withObject:aggrPerBrand];
}

@end
