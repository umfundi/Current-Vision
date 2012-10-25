//
//  AllPracticesDataSource.m
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "AllPracticesDataSource.h"

#import "Practice.h"

@implementation AllPracticesDataSource

@synthesize practiceArray;

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
        
        Practice *practice = [practiceArray objectAtIndex:gridCoord.rowIndex - 1];
        
        NSString *cellText;
        switch (gridCoord.column)
        {
            case 0:
                cellText = practice.practiceCode;
                break;
            case 1:
                cellText = practice.practiceName;
                break;
            case 2:
                cellText = practice.add1;
                break;
            case 3:
                cellText = practice.province;
                break;
            case 4:
                cellText = practice.city;
                break;
            case 5:
                cellText = practice.postcode;
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
    return 6;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    return [practiceArray count] + 1;
}

@end
