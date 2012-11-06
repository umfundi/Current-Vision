//
//  SalesTrendsReportDataSource.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SalesTrendsReportDataSource.h"

#import "SalesTrendAggrPerBrand.h"
#import "SalesTrendAggr.h"

@implementation SalesTrendsReportDataSource

@synthesize figureTitle;
@synthesize salesTrendAggr;

#pragma mark -
#pragma mark ShinobiGridDataSource

- (NSString *)shinobiGrid:(ShinobiGrid *)grid textForGridCoord:(const SGridCoord *) gridCoord
{
    NSString *cellText;

    if (gridCoord.rowIndex == 0)
    {
        switch (gridCoord.column)
        {
            case 0:
                cellText = figureTitle;
                break;
            case 13:
                cellText = NSLocalizedString(@"Growth", @"");
                break;
            default:
                cellText = salesTrendAggr.monthArray[gridCoord.column - 1];
                break;
        }
    }
    else
    {
        // Create formatter
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        SalesTrendAggrPerBrand *aggrPerBrand = [salesTrendAggr.aggrPerBrands objectAtIndex:gridCoord.rowIndex - 1];

        switch (gridCoord.column)
        {
            case 0:
                cellText = aggrPerBrand.brand;
                break;
            case 13:
                cellText = aggrPerBrand.growthString;
                break;
            default:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggrPerBrand.monthValArray[gridCoord.column - 1]]];
                break;
        }
    }
    
    return cellText;
}

- (SGridCell *)shinobiGrid:(ShinobiGrid *)grid cellForGridCoord:(const SGridCoord *) gridCoord
{
    NSString *cellText = [self shinobiGrid:grid textForGridCoord:gridCoord];

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
        
        cell.textField.font = [UIFont fontWithName:@"Verdana-Bold" size:12.f];
        cell.textField.text = cellText;
        return cell;
        }
    else
        {
        SGridTextCell *cell = (SGridTextCell *)[grid dequeueReusableCellWithIdentifier:@"valueCell"];
        if (!cell)
            cell = [[SGridTextCell alloc] initWithReuseIdentifier:@"valueCell"];
        
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
    return 14;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    return [salesTrendAggr.aggrPerBrands count] + 1;
}

@end
