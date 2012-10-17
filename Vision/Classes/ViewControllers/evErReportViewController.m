//
//  evErReportViewController.m
//  Vision
//
//  Created by Ian Molesworth on 23/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "evErReportViewController.h"

#import "Customer.h"
#import "Practice.h"
#import "umfundiAppDelegate.h"
#import "umfundiViewController.h"
#import "ErReportDataSource.h"
#import "ErReportAggrPerBrand.h"

@interface evErReportViewController ()

@end

@implementation evErReportViewController

@synthesize selectedPractice;

#pragma mark -SGridDelegate

- (SGridSectionHeaderStyle *)shinobiGrid:(ShinobiGrid *)grid styleForSectionHeaderAtIndex:(int) sectionIndex
{
    if (sectionIndex != 0)
    {
        SGridSectionHeaderStyle *s = [[SGridSectionHeaderStyle alloc] initWithHeight:25.f withBackgroundColor:[UIColor grayColor]];
        return s;
    }
    
    return nil;
}

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
    
    umfundiAppDelegate *appDelegate = (umfundiAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.selectedPractice = appDelegate.frontViewController.currentCustomer.practice;
    
    lblPracticeName.text = selectedPractice.practicename;
    lblPracticeCode.text = selectedPractice.practicecode;
    lblAddress1.text = selectedPractice.add1;
    lblAddress2.text = selectedPractice.province;
    lblAddress3.text = selectedPractice.country;
    lblPostcode.text = selectedPractice.postcode;
    lblIDUser.text = appDelegate.frontViewController.currentCustomer.id_user;
    
    erReportDataSource = [[ErReportDataSource alloc] init];
    erReportDataSource.erReportArray = [ErReportAggrPerBrand ErReportGroupByBrandFrom:appDelegate.frontViewController.currentCustomer.id_customer];
    
    NSString *licencekey = @"qgi64t6X5laUi6GMjAxMjExMTNpbmZvQHNoaW5vYmljb250cm9scy5jb20=UQ5WGyladC7SlbiYUt2BGUgxvt5ympt45rNMEzT1QST5KGlUA/v4WpV2NKh6yvMzqNQ/DmXZ0Uqya51NUqOn1m9u53sQpdOXKeJnkm127zUN6nOWKgY6wTEsh6vc71uYwcaVuB5lErG9+qDD9BZZdVQJ4Q7s=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+";
    
    //Create the grid
    erReportGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];
    
    erReportGrid.licenseKey = licencekey;
    
    erReportGrid.dataSource = erReportDataSource;
    erReportGrid.delegate = self;
    
    //Freeze our top and left most rows
    [erReportGrid freezeRowsAboveAndIncludingRow:SGridRowMake(0, 0)];
    
    //Some basic grid styling
    erReportGrid.backgroundColor = [UIColor whiteColor];
    erReportGrid.rowStylesTakePriority = YES;
    erReportGrid.defaultGridLineStyle.width = 1.0f;
    erReportGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    erReportGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    erReportGrid.defaultBorderStyle.width = 1.0f;
    
    //provide default row heights and col widths
    erReportGrid.defaultRowStyle.size = [NSNumber numberWithFloat:25];
    erReportGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:100];
    
    //ensure that section header is hidden (a grid has one section by default)
    erReportGrid.defaultSectionHeaderStyle.hidden = YES;
    erReportGrid.defaultSectionHeaderStyle.hidden = YES;
    
    //We dont want to be able to edit our cells
    erReportGrid.canEditCellsViaDoubleTap = NO;
    
    //Enable dragging - we want to be able to reorder in any direction
    erReportGrid.canReorderColsViaLongPress = YES;
    erReportGrid.canReorderRowsViaLongPress = YES;
    
    erReportGrid.frame = CGRectMake(1, 1, 2, 2);
    
    // this displays the grid
    [self.view addSubview:erReportGrid];
}

-(void) viewDidAppear:(BOOL)animated{
    [self didRotateFromInterfaceOrientation:0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

// respond to interface re-orientation by updating the layout
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    BOOL isPortrait = UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    
    if (isPortrait)
        erReportGrid.frame = CGRectMake(9, 295, self.view.bounds.size.width-20, self.view.bounds.size.height-300);
    else
        erReportGrid.frame = CGRectMake(9, 270, self.view.bounds.size.width-20, self.view.bounds.size.height-300);
    
        
    UIViewController *templateController = [self.storyboard instantiateViewControllerWithIdentifier:isPortrait ? @"ErReportPortraitView" : @"ErReportLandscapeView"];
    if (templateController)
    {
        int count = 0;
        for (UIView *eachView in ErReportSubviews(templateController.view))
        {
            NSLog(@"Tag %d %@ %d", count++, eachView.accessibilityLabel  , eachView.tag);
            
            int tag = eachView.tag;
            if(tag < 10 ) continue;
            [self.view viewWithTag:tag].frame = eachView.frame;
        }
    }
}

NSArray *ErReportSubviews(UIView *aView)
{
    NSArray *results = [aView subviews];
    for (UIView *eachView in [aView subviews])
    {
        NSArray *theSubviews = ErReportSubviews(eachView);
        if (theSubviews)
            results = [results arrayByAddingObjectsFromArray:theSubviews];
    }
    return results;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    lblPostcode = nil;
    [super viewDidUnload];
}
@end
