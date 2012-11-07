//
//  AllCustomersDataSource.m
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "AllCustomersDataSource.h"

#import "Customer.h"
#import "CustomerAggr.h"
#import "UIUnderlinedButton.h"

@implementation AllCustomersDataSource

@synthesize customerArray;
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self)
    {
        sortedColumn = -1;
        sortedResult = NSOrderedAscending;
    }
    
    return self;
}

#pragma mark -
#pragma mark ShinobiGridDataSource

- (SGridCell *)shinobiGrid:(ShinobiGrid *)grid cellForGridCoord:(const SGridCoord *) gridCoord
{
    if (gridCoord.rowIndex == 0)
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
        
        UIUnderlinedButton *titleButton = [UIUnderlinedButton underlinedButtonWithOrder:(sortedColumn == gridCoord.column) ? sortedResult : NSOrderedSame];
        [titleButton setBackgroundColor:[UIColor darkGrayColor]];
        titleButton.autoresizingMask = ~UIViewAutoresizingNone;
        [titleButton addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [titleButton setShowsTouchWhenHighlighted:YES];
        [titleButton setFrame:cell.bounds];
        [titleButton.titleLabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:14.f]];
        [titleButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        titleButton.tag = gridCoord.column;
        
        NSString *cellText;
        switch (gridCoord.column)
        {
            case 0:
                cellText = NSLocalizedString(@"id_customer", @"");
                break;
            case 1:
                cellText = NSLocalizedString(@"Name", @"");
                break;
            case 2:
                cellText = NSLocalizedString(@"Address", @"");
                break;
            case 3:
                cellText = NSLocalizedString(@"Town", @"");
                break;
            case 4:
                cellText = NSLocalizedString(@"County", @"");
                break;
            case 5:
                cellText = NSLocalizedString(@"Postcode", @"");
                break;
            case 6:
                cellText = NSLocalizedString(@"MthValue", @"");
                break;
            case 7:
                cellText = NSLocalizedString(@"YTDValue", @"");
                break;
            case 8:
                cellText = NSLocalizedString(@"MATValue", @"");
                break;
            default:
                cellText = @"";
                break;
        }
        
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
        
        cell.textField.font = [UIFont fontWithName:@"Courier" size:15.0f];
        cell.textField.textColor = [UIColor blackColor];
        cell.textField.textAlignment = UITextAlignmentLeft;
        cell.textField.font = [UIFont fontWithName:@"Courier" size:15.0f];
        
        cell.textField.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        
        Customer *customer = [customerArray objectAtIndex:gridCoord.rowIndex - 1];
        
        NSString *cellText;
        switch (gridCoord.column)
        {
            case 0:
                cellText = customer.id_customer;
                break;
            case 1:
                cellText = customer.customerName;
                break;
            case 2:
                cellText = customer.address1;
                break;
            case 3:
                cellText = customer.city;
                break;
            case 4:
                cellText = customer.province;
                break;
            case 5:
                cellText = customer.postcode;
                break;
            case 6:
                cellText = customer.aggrValue.monthString;
                break;
            case 7:
                cellText = customer.aggrValue.ytdString;
                break;
            case 8:
                cellText = customer.aggrValue.matString;
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
    return 9;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    return [customerArray count] + 1;
}


- (void)titleButtonClicked:(id)sender
{
    NSMutableArray *newResult = [NSMutableArray arrayWithArray:customerArray];
    
    NSInteger count = [newResult count];
    NSComparisonResult result = ([sender tag] != sortedColumn) ? NSOrderedAscending :
    (sortedResult == NSOrderedAscending ? NSOrderedDescending : NSOrderedAscending);
    
    for (NSInteger i = 0 ; i < count - 1 ; i ++ )
    {
        for (NSInteger j = i + 1; j < count ; j ++ )
        {
            Customer *customer_i = [newResult objectAtIndex:i];
            Customer *customer_j = [newResult objectAtIndex:j];

            NSComparisonResult res;
            switch ([sender tag])
            {
                case 0:
                    res = [customer_i.id_customer compare:customer_j.id_customer];
                    break;
                case 1:
                    res = [customer_i.customerName compare:customer_j.customerName];
                    break;
                case 2:
                    res = [customer_i.address1 compare:customer_j.address1];
                    break;
                case 3:
                    res = [customer_i.city compare:customer_j.city];
                    break;
                case 4:
                    res = [customer_i.province compare:customer_j.province];
                    break;
                case 5:
                    res = [customer_i.postcode compare:customer_j.postcode];
                    break;
                case 6:
                    if (customer_i.aggrValue.month > customer_j.aggrValue.month)
                        res = NSOrderedDescending;
                    else if (customer_i.aggrValue.month == customer_j.aggrValue.month)
                        res = NSOrderedSame;
                    else
                        res = NSOrderedAscending;
                    break;
                case 7:
                    if (customer_i.aggrValue.ytd > customer_j.aggrValue.ytd)
                        res = NSOrderedDescending;
                    else if (customer_i.aggrValue.ytd == customer_j.aggrValue.ytd)
                        res = NSOrderedSame;
                    else
                        res = NSOrderedAscending;
                    break;
                case 8:
                    if (customer_i.aggrValue.mat > customer_j.aggrValue.mat)
                        res = NSOrderedDescending;
                    else if (customer_i.aggrValue.mat == customer_j.aggrValue.mat)
                        res = NSOrderedSame;
                    else
                        res = NSOrderedAscending;
                    break;
                default:
                    return;
            }
            
            if (res != result)
                [newResult exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }
    
    self.customerArray = newResult;
    sortedColumn = [sender tag];
    sortedResult = result;
    
    [delegate performSelector:@selector(gridSorted)];
}

@end
