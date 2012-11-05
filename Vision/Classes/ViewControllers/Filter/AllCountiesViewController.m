//
//  CountiesViewController.m
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "AllCountiesViewController.h"

@interface AllCountiesViewController ()

@end

@implementation AllCountiesViewController

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
	// Do any additional setup after loading the view.

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
    
    dataSource = [[AllCountiesDataSource alloc] init];
    dataSource.countyArray = searchResult;
    dataSource.delegate = self;
    
    NSString *licencekey = @"qgi64t6X5laUi6GMjAxMjExMTNpbmZvQHNoaW5vYmljb250cm9scy5jb20=UQ5WGyladC7SlbiYUt2BGUgxvt5ympt45rNMEzT1QST5KGlUA/v4WpV2NKh6yvMzqNQ/DmXZ0Uqya51NUqOn1m9u53sQpdOXKeJnkm127zUN6nOWKgY6wTEsh6vc71uYwcaVuB5lErG9+qDD9BZZdVQJ4Q7s=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+";
    
    countyGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];
    
    countyGrid.licenseKey = licencekey;
    countyGrid.autoresizingMask = ~UIViewAutoresizingNone;
    countyGrid.dataSource = dataSource;
    countyGrid.delegate = self;
    
    //Freeze our top and left most rows
    [countyGrid freezeRowsAboveAndIncludingRow:SGridRowMake(0, 0)];
    
    //Some basic grid styling
    countyGrid.backgroundColor = [UIColor whiteColor];
    countyGrid.rowStylesTakePriority = YES;
    countyGrid.defaultGridLineStyle.width = 1.0f;
    countyGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    countyGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    countyGrid.defaultBorderStyle.width = 1.0f;
    
    //provide default row heights and col widths
    countyGrid.defaultRowStyle.size = [NSNumber numberWithFloat:30];
    countyGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:200];
    
    //ensure that section header is hidden (a grid has one section by default)
    countyGrid.defaultSectionHeaderStyle.hidden = YES;
    
    //We dont want to be able to edit our cells
    countyGrid.canEditCellsViaDoubleTap = YES;
    
    //Enable dragging - we want to be able to reorder in any direction
    countyGrid.canReorderColsViaLongPress = NO;
    countyGrid.canReorderRowsViaLongPress = NO;
    
    [self.view addSubview:countyGrid];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ShinobiGridDelegate

- (void) shinobiGrid:(ShinobiGrid *)grid willCommenceEditingAutoCell:(const SGridAutoCell *)cell
{
    countyGrid.canEditCellsViaDoubleTap = NO;
    
    // Selected
    NSString *selectedCounty = [searchResult objectAtIndex:cell.gridCoord.rowIndex - 1];
    
    [delegate performSelector:@selector(countySelected:) withObject:selectedCounty];
}


- (CGSize)contentSizeForViewInPopover
{
    if ([searchResult count] == 0)
        return CGSizeMake(200, 30);
    
    CGFloat height = 30 * ([searchResult count] + 1);
    return CGSizeMake(200, height);
}


#pragma mark -
#pragma mark AllCountiesDataSourceDelegate

- (void)gridSorted
{
    [countyGrid reload];
}

@end
