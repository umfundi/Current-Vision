//
//  SitesDataSource.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SitesDataSource.h"

#import "Customer.h"
#import "CustomerAggr.h"

@implementation SitesDataSource

@synthesize sitesArray;

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
                cellText = NSLocalizedString(@"Account", @"");
                break;
            case 1:
                cellText = NSLocalizedString(@"Name", @"");
                break;
            case 2:
                cellText = NSLocalizedString(@"Town", @"");
                break;
            case 3:
                cellText = NSLocalizedString(@"Postcode", @"");
                break;
            case 4:
                cellText = NSLocalizedString(@"Month", @"");
                break;
            case 5:
                cellText = NSLocalizedString(@"YTD", @"");
                break;
            case 6:
                cellText = NSLocalizedString(@"MAT", @"");
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
        SGridNumberCell *cell = (SGridNumberCell *)[grid dequeueReusableCellWithIdentifier:@"valueCell"];
            
        if (!cell)
            cell = [[SGridNumberCell alloc] initWithReuseIdentifier:@"valueCell"];
            
        if (gridCoord.column<4)
            cell.textField.textAlignment = UITextAlignmentLeft;
        else
            cell.textField.textAlignment = UITextAlignmentRight;
            
        cell.textField.font = [UIFont fontWithName:@"Arial" size:14.0f];
        cell.textField.textColor = [UIColor blackColor];
        cell.textField.backgroundColor = [UIColor whiteColor];
            
        cell.backgroundColor = [UIColor whiteColor];
            
        // Create formatter
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSString *cellText;
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
        Customer *customer = [sitesArray objectAtIndex:gridCoord.rowIndex - 1];
        
        switch (gridCoord.column)
        {
            case 0:
                cellText = customer.id_customer;
                break;
            case 1:
                cellText = customer.customerName;
                break;
            case 2:
                cellText = customer.city;
                break;
            case 3:
                cellText = customer.postcode;
                break;
            case 4:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:customer.aggrValue.month]];
//                cellText = customer.aggrValue.monthString;
                break;
            case 5:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:customer.aggrValue.ytd]];
//                cellText = customer.aggrValue.ytdString;
                break;
            case 6:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:customer.aggrValue.mat]];
//              cellText = customer.aggrValue.matString;
                break;
            default:
                cellText = @"";
                break;
        }
        
        if (gridCoord.column > 3)
            cell.textField.textAlignment = UITextAlignmentRight;
        cell.textField.text = cellText;
        
        return cell;
    }
}

- (NSUInteger)numberOfColsForShinobiGrid:(ShinobiGrid *)grid
{
    return 7;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    return [sitesArray count] + 1;
}

//Return the titles for the sections
- (NSString *)shinobiGrid:(ShinobiGrid *)grid titleForHeaderInSection:(int)section
{
    switch (section)
    {
        case 0:
            return @"Sites";
        default:
            break;
    }
    
    return nil;
}

- (UIView *)shinobiGrid:(ShinobiGrid *)grid viewForHeaderInSection:(int)section inFrame:(CGRect)frame
{
    NSString *title = [self shinobiGrid:grid titleForHeaderInSection:section];
    if (!title)
        return nil;
    
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 5, 0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:10];
    titleLabel.autoresizingMask = ~UIViewAutoresizingNone;
    [titleLabel setText:title];
    
    [headerView addSubview:titleLabel];
    
    return headerView;
}

@end
