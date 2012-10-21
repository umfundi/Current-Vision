//
//  CustomerSearchResultDataSource.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "CustomerSearchResultDataSource.h"

#import "Customer.h"

@implementation CustomerSearchResultDataSource

@synthesize searchResult;

- (id)initWithResults:(NSArray *)resultArray
{
    self = [super init];
    if (self)
        {
        self.searchResult = resultArray;
        }    
    return self;
}

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
                // Account
                cellText = NSLocalizedString(@"Account", @"");
                break;
            case 1:
                cellText = NSLocalizedString(@"Name", @"");
                // Name
                break;
            case 2:
                cellText = NSLocalizedString(@"Town", @"");
                // Town
                break;
            case 3:
                cellText = NSLocalizedString(@"Postcode", @"");
                //Postcode
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
        
        Customer *customer = [searchResult objectAtIndex:gridCoord.rowIndex - 1];
        
        NSString *cellText;
        switch (gridCoord.column)
        {
            case 0:
                // Account
                cellText = customer.id_customer;
                break;
            case 1:
                cellText = customer.customerName;
                // Name
                break;
            case 2:
                cellText = customer.province;
                // Town
                break;
            case 3:
                cellText = customer.postcode;
                //Postcode
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
    return 4;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    return [searchResult count] + 1;
}

@end
