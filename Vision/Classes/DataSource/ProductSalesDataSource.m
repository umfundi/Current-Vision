//
//  ProductSalesDataSource.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ProductSalesDataSource.h"

#import "ProductSalesAggrPerYear.h"
#import "ProductSalesAggrPerBrand.h"
#import "UIUnderlinedButton.h"

@implementation ProductSalesDataSource

@synthesize productSalesArray;
@synthesize numberFormat;
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
        ProductSalesAggrPerBrand *aggrPerBrand = [productSalesArray objectAtIndex:gridCoord.section - 1];
        ProductSalesAggrPerYear *aggrPerYear = [aggrPerBrand.aggrPerYears objectAtIndex:gridCoord.rowIndex];
        
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

    // Set the column headers - Row zero are the normal titles.
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
        
        cell.textField.font = [UIFont fontWithName:@"Verdana-Bold" size:10.f];
        cell.textField.text = cellText;
        return cell;
        }
    else
        {
        SGridNumberCell *cell = (SGridNumberCell *)[grid dequeueReusableCellWithIdentifier:@"valueCell"];
            
        if (!cell)
              cell = [[SGridNumberCell alloc] initWithReuseIdentifier:@"valueCell"];
            
        if (gridCoord.column==0)
            cell.textField.textAlignment = UITextAlignmentCenter;
        else
            cell.textField.textAlignment = UITextAlignmentRight;
                        
        cell.textField.font = [UIFont fontWithName:@"Arial" size:8.0f];
        cell.textField.textColor = [UIColor blackColor];
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
    return [productSalesArray count] + 1;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    if (sectionIndex == 0)
        return 1;
    
    ProductSalesAggrPerBrand *aggrPerBrand = [productSalesArray objectAtIndex:sectionIndex - 1];
    return [aggrPerBrand.aggrPerYears count];
}

//Return the titles for the sections
- (NSString *)shinobiGrid:(ShinobiGrid *)grid titleForHeaderInSection:(int)section
{
    if (section == 0)
        return nil;

    ProductSalesAggrPerBrand *aggrPerBrand = [productSalesArray objectAtIndex:section - 1];
    return aggrPerBrand.brand;
}

- (UIView *)shinobiGrid:(ShinobiGrid *)grid viewForHeaderInSection:(int)section inFrame:(CGRect)frame
{
    NSString *title = [self shinobiGrid:grid titleForHeaderInSection:section];
    if (!title)
        return nil;
    
    ProductSalesAggrPerBrand *aggrPerBrand = [productSalesArray objectAtIndex:section - 1];

    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    headerView.backgroundColor = [UIColor clearColor];

    UIUnderlinedButton *titleButton = [UIUnderlinedButton underlinedButtonWithOrder:NSOrderedSame];
    titleButton.tag = section;
    titleButton.underline = (aggrPerBrand.aggrPerProducts != nil);
    titleButton.backgroundColor = [UIColor clearColor];
    titleButton.autoresizingMask = ~UIViewAutoresizingNone;
    if (titleButton.underline)
    {
        [titleButton addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [titleButton setShowsTouchWhenHighlighted:YES];
        [self performSelector:@selector(enableButton:) withObject:headerView afterDelay:0.1];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleButtonClicked:)];
        [titleButton addGestureRecognizer:gesture];
        
    }
    [titleButton setFrame:CGRectInset(headerView.bounds, 5, 0)];
    [titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [titleButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton setTitle:title forState:UIControlStateNormal];
    [titleButton setFrame:CGRectMake(titleButton.frame.origin.x, titleButton.frame.origin.y,
                                     titleButton.titleLabel.frame.size.width, titleButton.frame.size.height)];
    
    [headerView addSubview:titleButton];
    
    return headerView;
}

- (void)enableButton:(id)sender
{
    [[sender superview] setUserInteractionEnabled:YES];
}

- (void)titleButtonClicked:(id)sender
{
    UITapGestureRecognizer *gesture = sender;
    NSInteger tag = [gesture.view tag];
    
    ProductSalesAggrPerBrand *aggrPerBrand = [productSalesArray objectAtIndex:tag - 1];

    [delegate performSelector:@selector(brandSelected:) withObject:aggrPerBrand];
}

@end
