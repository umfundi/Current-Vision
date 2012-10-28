//
//  SalesTrendsReportDataSource.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SalesTrendsReportDataSource.h"

#import "SalesTrendAggrPerBrand.h"

@implementation SalesTrendsReportDataSource

@synthesize figureTitle;
@synthesize reportArray;

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
        
        cell.textField.font = [UIFont fontWithName:@"Verdana-Bold" size:12.f];
        
        NSString *cellText;
        switch (gridCoord.column)
            {
            case 0:
                cellText = figureTitle;
                break;
            case 1:
                cellText = NSLocalizedString(@"Jan", @"");
                break;
            case 2:
                cellText = NSLocalizedString(@"Feb", @"");
                break;
            case 3:
                cellText = NSLocalizedString(@"Mar", @"");
                break;
            case 4:
                cellText = NSLocalizedString(@"Apr", @"");
                break;
            case 5:
                cellText = NSLocalizedString(@"May", @"");
                break;
            case 6:
                cellText = NSLocalizedString(@"Jun", @"");
                break;
            case 7:
                cellText = NSLocalizedString(@"Jul", @"");
                break;
            case 8:
                cellText = NSLocalizedString(@"Aug", @"");
                break;
            case 9:
                cellText = NSLocalizedString(@"Sep", @"");
                break;
            case 10:
                cellText = NSLocalizedString(@"Oct", @"");
                break;
            case 11:
                cellText = NSLocalizedString(@"Nov", @"");
                break;
            case 12:
                cellText = NSLocalizedString(@"Dec", @"");
                break;
            case 13:
                cellText = NSLocalizedString(@"Growth%", @"");
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
        
        if (gridCoord.column==0)
            cell.textField.textAlignment = UITextAlignmentCenter;
        else
            cell.textField.textAlignment = UITextAlignmentRight;
            
        cell.textField.font = [UIFont fontWithName:@"Arial" size:8.0f];
        cell.textField.textColor = [UIColor blackColor];
        cell.textField.backgroundColor = [UIColor whiteColor];
            
        cell.backgroundColor = [UIColor whiteColor];
            
            
        // Create formatter
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSString *cellText;
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
/*        if (gridCoord.rowIndex%2 == 0)
            cell.backgroundColor = [UIColor lightGrayColor];
        else
            cell.backgroundColor = [UIColor whiteColor];    */
            
        SalesTrendAggrPerBrand *aggr = [reportArray objectAtIndex:gridCoord.rowIndex - 1];
        
        switch (gridCoord.column)
            {
            case 0:
                cellText = aggr.brand;
                break;
            case 1:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggr.jan]];
//                cellText = aggr.janString;
                break;
            case 2:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggr.feb]];
//                cellText = aggr.febString;
                break;
            case 3:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggr.mar]];
//                cellText = aggr.marString;
                break;
            case 4:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggr.apr]];
//                cellText = aggr.aprString;
                break;
            case 5:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggr.may]];
//                cellText = aggr.mayString;
                break;
            case 6:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggr.jun]];
//                cellText = aggr.junString;
                break;
            case 7:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggr.jul]];
//                cellText = aggr.julString;
                break;
            case 8:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggr.aug]];
//                cellText = aggr.augString;
                break;
            case 9:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggr.sep]];
//                cellText = aggr.sepString;
                break;
            case 10:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggr.oct]];
//                cellText = aggr.octString;
                break;
            case 11:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggr.nov]];
//                cellText = aggr.novString;
                break;
            case 12:
                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggr.dec]];
//                cellText = aggr.decString;
                break;
            case 13:
//                cellText = [formatter stringFromNumber:[NSNumber numberWithInteger:aggr.jan]];
                cellText = aggr.growthString;
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
    return 14;
}

- (NSUInteger)shinobiGrid:(ShinobiGrid *)grid numberOfRowsInSection:(int) sectionIndex
{
    return [reportArray count] + 1;
}

@end
