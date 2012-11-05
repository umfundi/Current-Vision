//
//  AllKeyAccountManagersDataSource.m
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "AllKeyAccountManagersDataSource.h"

#import "User.h"
#import "UIUnderlinedButton.h"

@implementation AllKeyAccountManagersDataSource

@synthesize keyAccountManagerArray;
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
        
        [titleButton setTitle:@"KAM" forState:UIControlStateNormal];
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
        
        cell.textField.font = [UIFont fontWithName:@"Arial" size:15.0f];
        cell.textField.textColor = [UIColor blackColor];
        cell.textField.textAlignment = UITextAlignmentLeft;
        cell.textField.font = [UIFont fontWithName:@"Arial" size:15.0f];
        cell.textField.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        
        User *user = [keyAccountManagerArray objectAtIndex:gridCoord.rowIndex - 1];
        
        cell.textField.text = user.login;
        
        return cell;
    }
}

- (NSUInteger)numberOfColsForShinobiGrid:(ShinobiGrid *)grid
{
    return 1;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    return [keyAccountManagerArray count] + 1;
}


- (void)titleButtonClicked:(id)sender
{
    NSMutableArray *newResult = [NSMutableArray arrayWithArray:keyAccountManagerArray];
    
    NSInteger count = [newResult count];
    NSComparisonResult result = ([sender tag] != sortedColumn) ? NSOrderedAscending :
    (sortedResult == NSOrderedAscending ? NSOrderedDescending : NSOrderedAscending);
    
    for (NSInteger i = 0 ; i < count - 1 ; i ++ )
    {
        for (NSInteger j = i + 1; j < count ; j ++ )
        {
            User *user_i = (User *)[newResult objectAtIndex:i];
            User *user_j = (User *)[newResult objectAtIndex:j];
            
            NSComparisonResult res = [user_i.login compare:user_j.login];
            if (res != result)
                [newResult exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }
    
    self.keyAccountManagerArray = newResult;
    sortedColumn = [sender tag];
    sortedResult = result;
    
    [delegate performSelector:@selector(gridSorted)];
}

@end
