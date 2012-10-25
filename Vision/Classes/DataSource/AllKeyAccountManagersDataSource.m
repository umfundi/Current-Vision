//
//  AllKeyAccountManagersDataSource.m
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "AllKeyAccountManagersDataSource.h"

#import "User.h"

@implementation AllKeyAccountManagersDataSource

@synthesize keyAccountManagerArray;

#pragma mark -
#pragma mark ShinobiGridDataSource

- (SGridCell *)shinobiGrid:(ShinobiGrid *)grid cellForGridCoord:(const SGridCoord *) gridCoord
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
    
    User *user = [keyAccountManagerArray objectAtIndex:gridCoord.rowIndex];
    
    cell.textField.text = user.login;
    
    return cell;
}

- (NSUInteger)numberOfColsForShinobiGrid:(ShinobiGrid *)grid
{
    return 1;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    return [keyAccountManagerArray count];
}

@end
