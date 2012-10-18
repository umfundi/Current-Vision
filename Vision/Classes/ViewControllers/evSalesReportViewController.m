//
//  evSalesReportViewController.m
//  Vision
//
//  Created by Ian Molesworth on 22/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "evSalesReportViewController.h"

#import "Customer.h"
#import "Practice.h"
#import "umfundiAppDelegate.h"
#import "umfundiViewController.h"
#import "SalesTrendsReportDataSource.h"
#import "SalesTrendAggrPerBrand.h"

@interface evSalesReportViewController ()

@end

@implementation evSalesReportViewController

@synthesize selectedPractice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

// respond to interface re-orientation by updating the layout
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    BOOL isPortrait = UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    
    monthReportGrid.frame = CGRectMake(9, 290, self.view.bounds.size.width-20, (self.view.bounds.size.height-324) / 2);
    YTDReportGrid.frame = CGRectMake(9, 280 + (self.view.bounds.size.height-320) / 2,
                                     self.view.bounds.size.width - 20, (self.view.bounds.size.height-324) / 2);
    
    // We are using templated views. This segment loads the artefacts from the relative templates using
    // their tags as references and the visual layouts for positioning
    UIViewController *templateController = [self.storyboard instantiateViewControllerWithIdentifier:isPortrait ? @"SalesReportPortraitView" : @"SalesReportLandscapeView"];
    if (templateController)
    {
        int count = 0;
        for (UIView *eachView in SalesReportSubviews(templateController.view))
        {
            NSLog(@"Tag %d %@ %d", count++, eachView.accessibilityLabel  , eachView.tag);
            
            int tag = eachView.tag;
            if(tag < 10 ) continue;
            [self.view viewWithTag:tag].frame = eachView.frame;
        }
    }
}

NSArray *SalesReportSubviews(UIView *aView)
{
    NSArray *results = [aView subviews];
    for (UIView *eachView in [aView subviews])
    {
        NSArray *theSubviews = SalesReportSubviews(eachView);
        if (theSubviews)
            results = [results arrayByAddingObjectsFromArray:theSubviews];
    }
    return results;
}


- (SGridColRowStyle *)shinobiGrid:(ShinobiGrid *)grid styleForColAtIndex:(int)colIndex
{
    SGridColRowStyle *style = [[SGridColRowStyle alloc] init];
    
    //Set fixed width for certain columns
    if(colIndex == 0) {
        style.size = [NSNumber numberWithFloat:150];
        return style;
    } else if (colIndex < 13) {
        style.size = [NSNumber numberWithFloat:60];
        return style;
    }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    umfundiAppDelegate *appDelegate = (umfundiAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.selectedPractice = appDelegate.frontViewController.currentCustomer.practice;
    
    lblPracticeName.text = selectedPractice.practiceName;
    lblPracticeCode.text = selectedPractice.practiceCode;
    lblAddress1.text = selectedPractice.add1;
    lblAddress2.text = selectedPractice.province;
    lblAddress3.text = selectedPractice.country;
    lblPostcode.text = selectedPractice.postcode;
    lblIDUser.text = appDelegate.frontViewController.currentCustomer.id_user;
    
    monthReportDataSource = [[SalesTrendsReportDataSource alloc] init];
    monthReportDataSource.reportArray = [SalesTrendAggrPerBrand SalesTrendsGroupByBrandFrom:appDelegate.frontViewController.currentCustomer.id_customer];
    monthReportDataSource.isMonthReport = YES;

    YTDReportDataSource = [[SalesTrendsReportDataSource alloc] init];
    YTDReportDataSource.reportArray = [SalesTrendAggrPerBrand YTDReportsFrom:monthReportDataSource.reportArray];
    YTDReportDataSource.isMonthReport = NO;

    NSString *licencekey = @"qgi64t6X5laUi6GMjAxMjExMTNpbmZvQHNoaW5vYmljb250cm9scy5jb20=UQ5WGyladC7SlbiYUt2BGUgxvt5ympt45rNMEzT1QST5KGlUA/v4WpV2NKh6yvMzqNQ/DmXZ0Uqya51NUqOn1m9u53sQpdOXKeJnkm127zUN6nOWKgY6wTEsh6vc71uYwcaVuB5lErG9+qDD9BZZdVQJ4Q7s=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+";
    
    //Create the grid
    monthReportGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];
    YTDReportGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];
    
    monthReportGrid.licenseKey = licencekey;
    YTDReportGrid.licenseKey = licencekey;
    
    monthReportGrid.dataSource = monthReportDataSource;
    monthReportGrid.delegate = self;
    YTDReportGrid.dataSource = YTDReportDataSource;
    YTDReportGrid.delegate = self;
    
    //Freeze our top and left most rows
    [monthReportGrid freezeRowsAboveAndIncludingRow:SGridRowMake(0, 0)];
    [YTDReportGrid freezeRowsAboveAndIncludingRow:SGridRowMake(0, 0)];
    
    //Some basic grid styling
    monthReportGrid.backgroundColor = [UIColor whiteColor];
    monthReportGrid.rowStylesTakePriority = YES;
    monthReportGrid.defaultGridLineStyle.width = 1.0f;
    monthReportGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    monthReportGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    monthReportGrid.defaultBorderStyle.width = 1.0f;
    YTDReportGrid.backgroundColor = [UIColor whiteColor];
    YTDReportGrid.rowStylesTakePriority = YES;
    YTDReportGrid.defaultGridLineStyle.width = 1.0f;
    YTDReportGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    YTDReportGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    YTDReportGrid.defaultBorderStyle.width = 1.0f;
    
    //provide default row heights and col widths
    monthReportGrid.defaultRowStyle.size = [NSNumber numberWithFloat:30];
    monthReportGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:100];
    YTDReportGrid.defaultRowStyle.size = [NSNumber numberWithFloat:30];
    YTDReportGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:100];
    
    //ensure that section header is hidden (a grid has one section by default)
    monthReportGrid.defaultSectionHeaderStyle.hidden = YES;
    monthReportGrid.defaultSectionHeaderStyle.hidden = YES;
    YTDReportGrid.defaultSectionHeaderStyle.hidden = YES;
    YTDReportGrid.defaultSectionHeaderStyle.hidden = YES;
    
    //We dont want to be able to edit our cells
    monthReportGrid.canEditCellsViaDoubleTap = NO;
    YTDReportGrid.canEditCellsViaDoubleTap = NO;
    
    //Enable dragging - we want to be able to reorder in any direction
    monthReportGrid.canReorderColsViaLongPress = YES;
    monthReportGrid.canReorderRowsViaLongPress = YES;
    YTDReportGrid.canReorderColsViaLongPress = YES;
    YTDReportGrid.canReorderRowsViaLongPress = YES;
    
    monthReportGrid.frame = CGRectMake(1, 1, 2, 2);
    YTDReportGrid.frame = CGRectMake(1, 1, 2, 2);
    
    // this displays the grid
    [self.view addSubview:monthReportGrid];
    [self.view addSubview:YTDReportGrid];
}

-(void) viewDidAppear:(BOOL)animated{
    [self didRotateFromInterfaceOrientation:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    lblPostcode = nil;
    lblPostcode = nil;
    lblPostcode = nil;
    [super viewDidUnload];
}
@end
