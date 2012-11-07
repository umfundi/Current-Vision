//
//  PracticeSearchResultViewController.m
//  Vision
//
//  Created by Ian Molesworth on 21/10/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "PracticeSearchResultViewController.h"

#import "Practice.h"

@interface PracticeSearchResultViewController ()

@end

@implementation PracticeSearchResultViewController

@synthesize searchResult, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([searchResult count] == 0)
        {
        // No result
    
        UILabel *noresultLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    
        noresultLabel.autoresizingMask = ~UIViewAutoresizingNone;
        noresultLabel.textAlignment = UITextAlignmentCenter;
        noresultLabel.font = [UIFont boldSystemFontOfSize:16];
        noresultLabel.text = NSLocalizedString(@"No results!", @"");
    
        [self.view addSubview:noresultLabel];
        return;
        }

    dataSource = [[PracticeSearchResultDataSource alloc] initWithResults:searchResult];
    dataSource.delegate = self;

    NSString *licencekey = @"qgi64t6X5laUi6GMjAxMjExMTNpbmZvQHNoaW5vYmljb250cm9scy5jb20=UQ5WGyladC7SlbiYUt2BGUgxvt5ympt45rNMEzT1QST5KGlUA/v4WpV2NKh6yvMzqNQ/DmXZ0Uqya51NUqOn1m9u53sQpdOXKeJnkm127zUN6nOWKgY6wTEsh6vc71uYwcaVuB5lErG9+qDD9BZZdVQJ4Q7s=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+";

    practiceGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];

    practiceGrid.licenseKey = licencekey;
    practiceGrid.autoresizingMask = ~UIViewAutoresizingNone;
    practiceGrid.dataSource = dataSource;
    practiceGrid.delegate = self;

    //Freeze our top and left most rows
    [practiceGrid freezeRowsAboveAndIncludingRow:SGridRowMake(0, 0)];

    //Some basic grid styling
    practiceGrid.backgroundColor = [UIColor whiteColor];
    practiceGrid.rowStylesTakePriority = YES;
    practiceGrid.defaultGridLineStyle.width = 1.0f;
    practiceGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    practiceGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    practiceGrid.defaultBorderStyle.width = 1.0f;

    //provide default row heights and col widths
    practiceGrid.defaultRowStyle.size = [NSNumber numberWithFloat:30];
    practiceGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:100];

    //ensure that section header is hidden (a grid has one section by default)
    practiceGrid.defaultSectionHeaderStyle.hidden = YES;

    //We dont want to be able to edit our cells
    practiceGrid.canEditCellsViaDoubleTap = YES;

    //Enable dragging - we want to be able to reorder in any direction
    practiceGrid.canReorderColsViaLongPress = NO;
    practiceGrid.canReorderRowsViaLongPress = NO;

    [self.view addSubview:practiceGrid];
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)contentSizeForViewInPopover
{
    if ([searchResult count] == 0)
        return CGSizeMake(200, 30);
    
    CGFloat height = 30 * ([searchResult count] + 1);
    return CGSizeMake(700, height);
}


#pragma mark -
#pragma mark ShinobiGridDelegate

- (void) shinobiGrid:(ShinobiGrid *)grid willCommenceEditingAutoCell:(const SGridAutoCell *)cell
{
    practiceGrid.canEditCellsViaDoubleTap = NO;
    
    if (cell.gridCoord.rowIndex == 0)
    {
        practiceGrid.canEditCellsViaDoubleTap = YES;
        return;
    }
    
    // Selected
    Practice *selectedPractice = [dataSource.searchResult objectAtIndex:cell.gridCoord.rowIndex - 1];
    
    [delegate performSelector:@selector(practiceSelected:) withObject:selectedPractice];
}


- (SGridColRowStyle *)shinobiGrid:(ShinobiGrid *)grid styleForColAtIndex:(int)colIndex
{
    SGridColRowStyle *style = [[SGridColRowStyle alloc] init];
    
    //Set fixed width for certain columns
    if(colIndex == 1) {
        style.size = [NSNumber numberWithFloat:350];
        return style;
    } else if (colIndex == 2) {
        style.size = [NSNumber numberWithFloat:150];
        return style;
    }
    return nil;
}


#pragma mark -
#pragma mark PracticeSearchResultDataSourceDelegate

- (void)gridSorted
{
    [practiceGrid reload];
}

@end
