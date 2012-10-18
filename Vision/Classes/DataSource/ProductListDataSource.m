//
//  ProductListDataSource.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ProductListDataSource.h"

#import "Product.h"

@implementation ProductListDataSource

@synthesize productArray;
@synthesize itemSelected;

#pragma mark -
#pragma mark ShinobiGridDataSource

- (SGridCell *)shinobiGrid:(ShinobiGrid *)grid cellForGridCoord:(const SGridCoord *) gridCoord
{
    SGridTextCell *cell = (SGridTextCell *)[grid dequeueReusableCellWithIdentifier:@"valueCell"];
    if (!cell)
        cell = [[SGridTextCell alloc] initWithReuseIdentifier:@"valueCell"];
    
    cell.textField.font = [UIFont fontWithName:@"Ariel" size:15.0f];
    cell.textField.textColor = [UIColor blackColor];
    cell.textField.textAlignment = UITextAlignmentLeft;
    cell.textField.font = [UIFont fontWithName:@"Ariel" size:15.0f];
    cell.textField.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSNumber *selected = [itemSelected objectAtIndex:gridCoord.rowIndex];
    if ([selected boolValue])
    {
        cell.textField.textColor = [UIColor whiteColor];
        cell.textField.backgroundColor = [UIColor orangeColor];
        cell.backgroundColor = [UIColor orangeColor];
    }

    Product *product = [productArray objectAtIndex:gridCoord.rowIndex];
    
    NSString *cellText = product.pname;
    cell.textField.text = cellText;
    
    return cell;
}

- (NSUInteger)numberOfColsForShinobiGrid:(ShinobiGrid *)grid
{
    return 1;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    return [productArray count];
}

@end
