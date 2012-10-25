//
//  Counties.m
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "AllCountiesDataSource.h"

@implementation AllCountiesDataSource

@synthesize countyArray;

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
    
    cell.textField.text = [countyArray objectAtIndex:gridCoord.rowIndex];
    
    return cell;
}

- (NSUInteger)numberOfColsForShinobiGrid:(ShinobiGrid *)grid
{
    return 1;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    return [countyArray count];
}

@end
