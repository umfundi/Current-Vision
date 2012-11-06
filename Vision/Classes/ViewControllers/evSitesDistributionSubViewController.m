//
//  evSitesDistributionSubViewController.m
//  Vision
//
//  Created by Jin on 11/2/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "evSitesDistributionSubViewController.h"

#import "umfundiCommon.h"
#import "User.h"
#import "SitesDistributionAggrItem.h"
#import "SitesDistributionSubDataSource.h"
#import "BrandListDataSource.h"
#import "ProductListDataSource.h"

@interface evSitesDistributionSubViewController ()

@end

@implementation evSitesDistributionSubViewController

@synthesize selectedBrands;
@synthesize selectedProducts;
@synthesize aggrItem;

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
    
    brandListDataSource = [[BrandListDataSource alloc] init];
    brandListDataSource.brandArray = selectedBrands;
    
    productListDataSource = [[ProductListDataSource alloc] init];
    productListDataSource.productArray = selectedProducts;
    
    sitesDistributionDataSource = [[SitesDistributionSubDataSource alloc] init];
    sitesDistributionDataSource.sitesDistributionAggrItem = aggrItem;

    NSString *licencekey = @"qgi64t6X5laUi6GMjAxMjExMTNpbmZvQHNoaW5vYmljb250cm9scy5jb20=UQ5WGyladC7SlbiYUt2BGUgxvt5ympt45rNMEzT1QST5KGlUA/v4WpV2NKh6yvMzqNQ/DmXZ0Uqya51NUqOn1m9u53sQpdOXKeJnkm127zUN6nOWKgY6wTEsh6vc71uYwcaVuB5lErG9+qDD9BZZdVQJ4Q7s=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+";
    
    //Create the grid
    filterListGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];
    sitesDistributionGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];
    
    filterListGrid.licenseKey = licencekey;
    sitesDistributionGrid.licenseKey = licencekey;
    
    filterListGrid.dataSource = (selectedBrands != nil) ? brandListDataSource : productListDataSource;
    filterListGrid.delegate = self;
    sitesDistributionGrid.dataSource = sitesDistributionDataSource;
    sitesDistributionGrid.delegate = self;
    
    //Freeze our top and left most rows
    [sitesDistributionGrid freezeRowsAboveAndIncludingRow:SGridRowMake(0, 0)];
    
    //Some basic grid styling
    filterListGrid.backgroundColor = [UIColor whiteColor];
    filterListGrid.rowStylesTakePriority = YES;
    filterListGrid.defaultGridLineStyle.width = 1.0f;
    filterListGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    filterListGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    filterListGrid.defaultBorderStyle.width = 1.0f;
    sitesDistributionGrid.backgroundColor = [UIColor whiteColor];
    sitesDistributionGrid.rowStylesTakePriority = YES;
    sitesDistributionGrid.defaultGridLineStyle.width = 1.0f;
    sitesDistributionGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    sitesDistributionGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    sitesDistributionGrid.defaultBorderStyle.width = 1.0f;
    
    //provide default row heights and col widths
    filterListGrid.defaultRowStyle.size = [NSNumber numberWithFloat:30];
    filterListGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:400];
    sitesDistributionGrid.defaultRowStyle.size = [NSNumber numberWithFloat:30];
    sitesDistributionGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:100];
    
    //ensure that section header is hidden (a grid has one section by default)
    filterListGrid.defaultSectionHeaderStyle.hidden = YES;
    filterListGrid.defaultSectionHeaderStyle.hidden = YES;
    sitesDistributionGrid.defaultSectionHeaderStyle.hidden = YES;
    sitesDistributionGrid.defaultSectionHeaderStyle.hidden = YES;
    
    //We dont want to be able to edit our cells
    filterListGrid.canEditCellsViaDoubleTap = NO;
    sitesDistributionGrid.canEditCellsViaDoubleTap = NO;
    
    //Enable dragging - we want to be able to reorder in any direction
    filterListGrid.canReorderColsViaLongPress = YES;
    filterListGrid.canReorderRowsViaLongPress = YES;
    sitesDistributionGrid.canReorderColsViaLongPress = YES;
    sitesDistributionGrid.canReorderRowsViaLongPress = YES;
    
    // this displays the grid
    [self.view addSubview:filterListGrid];
    [self.view addSubview:sitesDistributionGrid];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self didRotateFromInterfaceOrientation:0];
    [self applyTheme:[[User loginUser].data isEqualToString:@"companion"]];
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    BOOL isPortrait = UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    
    filterListGrid.frame = CGRectMake(10, 100,
                                     self.view.bounds.size.width - 30,
                                     200);
    sitesDistributionGrid.frame = CGRectMake(10, 305,
                                             self.view.bounds.size.width - 30,
                                             self.view.frame.size.height - 320);
    
    UIViewController *templateController = [self.storyboard instantiateViewControllerWithIdentifier:isPortrait ? @"SitesDistributionSubPortraitView" : @"SitesDistributionSubLandscapeView"];
    if (templateController)
    {
        for (UIView *eachView in SitesDistributionSubSubviews(templateController.view))
        {
            //           NSLog(@"Tag %d %@ %d", count++, eachView.accessibilityLabel  , eachView.tag);
            
            int tag = eachView.tag;
            if(tag < 10 ) continue;
            [self.view viewWithTag:tag].frame = eachView.frame;
        }
    }
}


NSArray *SitesDistributionSubSubviews(UIView *aView)
{
    NSArray *results = [aView subviews];
    for (UIView *eachView in [aView subviews])
    {
        NSArray *theSubviews = SitesDistributionSubSubviews(eachView);
        if (theSubviews)
            results = [results arrayByAddingObjectsFromArray:theSubviews];
    }
    return results;
}


- (IBAction)doneClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)applyTheme:(BOOL)redTheme
{
    // About Button Background Image
    NSString *logo = redTheme ? @"Companion_HC.png" : @"Ruminant_HB.png";
    [imgLogo setImage:[UIImage imageNamed:logo]];

    // Buttons Title Color
    UIColor *titleColor = redTheme ? [UIColor colorWithRed:180.0 / 255 green:0 blue:0 alpha:1] :
    [UIColor colorWithRed:50.0 / 255 green:79.0 / 255 blue:133.0 / 255 alpha:1];
    
    [umfundiCommon applyColorToButton:btnDone withColor:titleColor];
}

@end
