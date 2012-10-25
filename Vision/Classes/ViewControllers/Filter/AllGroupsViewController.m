//
//  AllGroupsViewController.m
//  Vision
//
//  Created by Jin on 10/25/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "AllGroupsViewController.h"

#import "AllGroupsDataSource.h"

@interface AllGroupsViewController ()

@end

@implementation AllGroupsViewController

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
    
    dataSource = [[AllGroupsDataSource alloc] init];
    dataSource.groupArray = searchResult;
    
    NSString *licencekey = @"qgi64t6X5laUi6GMjAxMjExMTNpbmZvQHNoaW5vYmljb250cm9scy5jb20=UQ5WGyladC7SlbiYUt2BGUgxvt5ympt45rNMEzT1QST5KGlUA/v4WpV2NKh6yvMzqNQ/DmXZ0Uqya51NUqOn1m9u53sQpdOXKeJnkm127zUN6nOWKgY6wTEsh6vc71uYwcaVuB5lErG9+qDD9BZZdVQJ4Q7s=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+";
    
    groupGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];
    
    groupGrid.licenseKey = licencekey;
    groupGrid.autoresizingMask = ~UIViewAutoresizingNone;
    groupGrid.dataSource = dataSource;
    groupGrid.delegate = self;
    
    //Freeze our top and left most rows
    [groupGrid freezeRowsAboveAndIncludingRow:SGridRowMake(0, 0)];
    
    //Some basic grid styling
    groupGrid.backgroundColor = [UIColor whiteColor];
    groupGrid.rowStylesTakePriority = YES;
    groupGrid.defaultGridLineStyle.width = 1.0f;
    groupGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    groupGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    groupGrid.defaultBorderStyle.width = 1.0f;
    
    //provide default row heights and col widths
    groupGrid.defaultRowStyle.size = [NSNumber numberWithFloat:30];
    groupGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:200];
    
    //ensure that section header is hidden (a grid has one section by default)
    groupGrid.defaultSectionHeaderStyle.hidden = YES;
    
    //We dont want to be able to edit our cells
    groupGrid.canEditCellsViaDoubleTap = YES;
    
    //Enable dragging - we want to be able to reorder in any direction
    groupGrid.canReorderColsViaLongPress = NO;
    groupGrid.canReorderRowsViaLongPress = NO;
    
    [self.view addSubview:groupGrid];
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
    groupGrid.canEditCellsViaDoubleTap = NO;
    
    // Selected
    NSString *selectedCounty = [searchResult objectAtIndex:cell.gridCoord.rowIndex];
    
    [delegate performSelector:@selector(groupSelected:) withObject:selectedCounty];
}


- (CGSize)contentSizeForViewInPopover
{
    if ([searchResult count] == 0)
        return CGSizeMake(200, 30);
    
    CGFloat height = 30 * [searchResult count];
    return CGSizeMake(200, height);
}

@end
