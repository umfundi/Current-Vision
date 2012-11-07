//
//  ProductSalesDataSource.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ProductSalesDataSource.h"

#import "ProductSalesAggr.h"
#import "ProductSalesAggrPerYear.h"
#import "ProductSalesAggrPerBrand.h"
#import "UIUnderlinedButton.h"

@implementation ProductSalesDataSource

@synthesize productSalesAggr;
@synthesize numberFormat;
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
                cellText = productSalesAggr.monthArray[0];
                break;
            case 2:
                cellText = productSalesAggr.monthArray[1];
                break;
            case 3:
                cellText = productSalesAggr.monthArray[2];
                break;
            case 4:
                cellText = NSLocalizedString(@"Tot. Q-1", @"");
                break;
            case 5:
                cellText = productSalesAggr.monthArray[3];
                break;
            case 6:
                cellText = productSalesAggr.monthArray[4];
                break;
            case 7:
                cellText = productSalesAggr.monthArray[5];
                break;
            case 8:
                cellText = NSLocalizedString(@"Tot Q-2", @"");
                break;
            case 9:
                cellText = productSalesAggr.monthArray[6];
                break;
            case 10:
                cellText = productSalesAggr.monthArray[7];
                break;
            case 11:
                cellText = productSalesAggr.monthArray[8];
                break;
            case 12:
                cellText = NSLocalizedString(@"Tot Q-3", @"");
                break;
            case 13:
                cellText = productSalesAggr.monthArray[9];
                break;
            case 14:
                cellText = productSalesAggr.monthArray[10];
                break;
            case 15:
                cellText = productSalesAggr.monthArray[11];
                break;
            case 16:
                cellText = NSLocalizedString(@"Tot Q-4", @"");
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
        ProductSalesAggrPerBrand *aggrPerBrand = [productSalesAggr.aggrPerBrands objectAtIndex:gridCoord.section - 1];
        ProductSalesAggrPerYear *aggrPerYear = [aggrPerBrand.aggrPerYears objectAtIndex:gridCoord.rowIndex];
        // Create formatter
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        switch (gridCoord.column)
        {
            case 0:
                cellText = aggrPerYear.year;
                break;
            case 1:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.monthValArray[0]]];
                break;
            case 2:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.monthValArray[1]]];
                break;
            case 3:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.monthValArray[2]]];
                break;
            case 4:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.totq1]];
                break;
            case 5:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.monthValArray[3]]];
                break;
            case 6:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.monthValArray[4]]];
                break;
            case 7:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.monthValArray[5]]];
                break;
            case 8:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.totq2]];
                break;
            case 9:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.monthValArray[6]]];
                break;
            case 10:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.monthValArray[7]]];
                break;
            case 11:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.monthValArray[8]]];
                break;
            case 12:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.totq3]];
                break;
            case 13:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.monthValArray[9]]];
                break;
            case 14:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.monthValArray[10]]];
                break;
            case 15:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.monthValArray[11]]];
                break;
            case 16:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.totq4]];
                break;
            case 17:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.value]];
                break;
            case 18:
                cellText = [[formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.growth]] stringByAppendingString:@"%"];
                break;
            case 19:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.qty]];
                break;
            case 20:
                cellText = [[formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerYear.qtygrowth]] stringByAppendingString:@"%"];
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
    return [productSalesAggr.aggrPerBrands count] + 1;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    if (sectionIndex == 0)
        return 1;
    
    ProductSalesAggrPerBrand *aggrPerBrand = [productSalesAggr.aggrPerBrands objectAtIndex:sectionIndex - 1];
    return [aggrPerBrand.aggrPerYears count];
}

//Return the titles for the sections
- (NSString *)shinobiGrid:(ShinobiGrid *)grid titleForHeaderInSection:(int)section
{
    if (section == 0)
        return nil;

    ProductSalesAggrPerBrand *aggrPerBrand = [productSalesAggr.aggrPerBrands objectAtIndex:section - 1];
    return aggrPerBrand.brand;
}

- (UIView *)shinobiGrid:(ShinobiGrid *)grid viewForHeaderInSection:(int)section inFrame:(CGRect)frame
{
    NSString *title = [self shinobiGrid:grid titleForHeaderInSection:section];
    if (!title)
        return nil;
    
    ProductSalesAggrPerBrand *aggrPerBrand = [productSalesAggr.aggrPerBrands objectAtIndex:section - 1];

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
    
    ProductSalesAggrPerBrand *aggrPerBrand = [productSalesAggr.aggrPerBrands objectAtIndex:tag - 1];

    [delegate performSelector:@selector(brandSelected:) withObject:aggrPerBrand];
}

@end
