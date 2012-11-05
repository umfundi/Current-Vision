//
//  ErReportDataSource.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ErReportDataSource.h"

#import "ErReportAggrPerYear.h"
#import "ErReportAggrPerBrand.h"
#import "UIUnderlinedButton.h"

@implementation ErReportDataSource

@synthesize erReportArray;
@synthesize delegate;

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
                cellText = NSLocalizedString(@"Year", @"");
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
                cellText = NSLocalizedString(@"Tot. Q-1", @"");
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
                cellText = NSLocalizedString(@"Tot. Q-2", @"");
                break;
            case 9:
                cellText = NSLocalizedString(@"Jul", @"");
                break;
            case 10:
                cellText = NSLocalizedString(@"Aug", @"");
                break;
            case 11:
                cellText = NSLocalizedString(@"Sep", @"");
                break;
            case 12:
                cellText = NSLocalizedString(@"Tot. Q-3", @"");
                break;
            case 13:
                cellText = NSLocalizedString(@"Oct", @"");
                break;
            case 14:
                cellText = NSLocalizedString(@"Nov", @"");
                break;
            case 15:
                cellText = NSLocalizedString(@"Dec", @"");
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
        ErReportAggrPerBrand *aggrPerBrand = [erReportArray objectAtIndex:gridCoord.section - 1];
        ErReportAggrPerYear *aggrPerYear = [aggrPerBrand.aggrPerYears objectAtIndex:gridCoord.rowIndex];
        
        switch (gridCoord.column)
        {
            case 0:
                cellText = aggrPerYear.year;
                break;
            case 1:
                cellText = aggrPerYear.janString;
                break;
            case 2:
                cellText = aggrPerYear.febString;
                break;
            case 3:
                cellText = aggrPerYear.marString;
                break;
            case 4:
                cellText = aggrPerYear.totq1;
                break;
            case 5:
                cellText = aggrPerYear.aprString;
                break;
            case 6:
                cellText = aggrPerYear.mayString;
                break;
            case 7:
                cellText = aggrPerYear.junString;
                break;
            case 8:
                cellText = aggrPerYear.totq2;
                break;
            case 9:
                cellText = aggrPerYear.julString;
                break;
            case 10:
                cellText = aggrPerYear.augString;
                break;
            case 11:
                cellText = aggrPerYear.sepString;
                break;
            case 12:
                cellText = aggrPerYear.totq3;
                break;
            case 13:
                cellText = aggrPerYear.octString;
                break;
            case 14:
                cellText = aggrPerYear.novString;
                break;
            case 15:
                cellText = aggrPerYear.decString;
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
    return [erReportArray count] + 1;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    if (sectionIndex == 0)
        return 1;
    
    ErReportAggrPerBrand *aggrPerBrand = [erReportArray objectAtIndex:sectionIndex - 1];
    return [aggrPerBrand.aggrPerYears count];
}

//Return the titles for the sections
- (NSString *)shinobiGrid:(ShinobiGrid *)grid titleForHeaderInSection:(int)section
{
    if (section == 0)
        return nil;
    
    ErReportAggrPerBrand *aggrPerBrand = [erReportArray objectAtIndex:section - 1];
    return aggrPerBrand.brand;
}

- (UIView *)shinobiGrid:(ShinobiGrid *)grid viewForHeaderInSection:(int)section inFrame:(CGRect)frame
{
    NSString *title = [self shinobiGrid:grid titleForHeaderInSection:section];
    if (!title)
        return nil;
    
    ErReportAggrPerBrand *aggrPerBrand = [erReportArray objectAtIndex:section - 1];

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
    ErReportAggrPerBrand *aggrPerBrand = [erReportArray objectAtIndex:[sender tag] - 1];
    
    [delegate performSelector:@selector(brandSelected:) withObject:aggrPerBrand];
}

@end
