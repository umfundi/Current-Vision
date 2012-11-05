//
//  AllPracticesDataSource.m
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "AllPracticesDataSource.h"

#import "Practice.h"
#import "UIUnderlinedButton.h"

@implementation AllPracticesDataSource

@synthesize practiceArray;
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


- (void)titleButtonClicked:(id)sender
{
    NSMutableArray *newResult = [NSMutableArray arrayWithArray:practiceArray];
    
    NSInteger count = [newResult count];
    NSComparisonResult result = ([sender tag] != sortedColumn) ? NSOrderedAscending :
    (sortedResult == NSOrderedAscending ? NSOrderedDescending : NSOrderedAscending);
    
    for (NSInteger i = 0 ; i < count - 1 ; i ++ )
    {
        for (NSInteger j = i + 1; j < count ; j ++ )
        {
            Practice *practice_i = [newResult objectAtIndex:i];
            Practice *practice_j = [newResult objectAtIndex:j];
            
            NSComparisonResult res;
            switch ([sender tag])
            {
                case 0:
                    res = [practice_i.practiceCode compare:practice_j.practiceCode];
                    break;
                case 1:
                    res = [practice_i.practiceName compare:practice_j.practiceName];
                    break;
                case 2:
                    res = [practice_i.add1 compare:practice_j.add1];
                    break;
                case 3:
                    res = [practice_i.province compare:practice_j.province];
                    break;
                case 4:
                    res = [practice_i.city compare:practice_j.city];
                    break;
                case 5:
                    res = [practice_i.postcode compare:practice_j.postcode];
                    break;
                default:
                    return;
            }
            
            if (res != result)
                [newResult exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }
    
    self.practiceArray = newResult;
    sortedColumn = [sender tag];
    sortedResult = result;
    
    [delegate performSelector:@selector(gridSorted)];
}

@end
