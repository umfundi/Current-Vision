//
//  evProductSalesViewController.m
//  Vision
//
//  Created by Ian Molesworth on 23/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "evProductSalesViewController.h"

#import "User.h"
#import "Customer.h"
#import "Practice.h"
#import "umfundiAppDelegate.h"
#import "umfundiViewController.h"
#import "ProductSalesDataSource.h"
#import "ProductSalesAggrPerBrand.h"

@interface evProductSalesViewController ()

@end

@implementation evProductSalesViewController

@synthesize selectedPractice;

#pragma mark -SGridDelegate

- (SGridSectionHeaderStyle *)shinobiGrid:(ShinobiGrid *)grid styleForSectionHeaderAtIndex:(int) sectionIndex
{
    if (sectionIndex != 0)
    {
        SGridSectionHeaderStyle *s = [[SGridSectionHeaderStyle alloc] initWithHeight:15.f withBackgroundColor:[UIColor lightGrayColor]];
        s.font = [UIFont fontWithName:@"Arial" size:10.0f];
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


- (SGridColRowStyle *)shinobiGrid:(ShinobiGrid *)grid styleForRowAtIndex:(int)rowIndex inSection:(int)secIndex{
    SGridColRowStyle *style = [[SGridColRowStyle alloc] init];
    
    NSLog(@"Sect %d row %d", secIndex, rowIndex);
    
    //Set Height of rows
    if(rowIndex == 0 && secIndex == 0)
        {
        style.size = [NSNumber numberWithFloat:23];
        return style;
        }
    else
        {
        style.size = [NSNumber numberWithFloat:18];
        return style;
        }
    
    return nil;
}


- (SGridColRowStyle *)shinobiGrid:(ShinobiGrid *)grid styleForColAtIndex:(int)colIndex
{
    SGridColRowStyle *style = [[SGridColRowStyle alloc] init];
    
    //Set fixed width for certain columns
    if(colIndex == 4 || colIndex == 8 || colIndex == 12 || colIndex == 16 || colIndex == 18 || colIndex == 20) {
        style.size = [NSNumber numberWithFloat:56];
        return style;
    }
/*    else if (colIndex == 2) {
        style.size = [NSNumber numberWithFloat:150];
        return style;
    }  */
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    umfundiAppDelegate *appDelegate = (umfundiAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.selectedPractice = appDelegate.frontViewController.currentPractice;
    
    lblPracticeName.text = selectedPractice.practiceName;
    lblPracticeCode.text = selectedPractice.practiceCode;
    lblAddress1.text = selectedPractice.add1;
    lblAddress2.text = selectedPractice.province;
    lblAddress3.text = selectedPractice.country;
    lblPostcode.text = selectedPractice.postcode;
    lblIDUser.text = [User loginUser].login;
    
    productSalesDataSource = [[ProductSalesDataSource alloc] init];
    
    productSalesDataSource.productSalesArray = [ProductSalesAggrPerBrand ProductSalesGroupByBrandFrom:appDelegate.frontViewController.currentPractice.practiceCode];
    
    
    NSNumberFormatter *nf = [NSNumberFormatter new];
    [nf setGroupingSize:3];
    [nf setGroupingSeparator: [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator]];
    productSalesDataSource.numberFormat = nf;
    
    NSString *licencekey = @"qgi64t6X5laUi6GMjAxMjExMTNpbmZvQHNoaW5vYmljb250cm9scy5jb20=UQ5WGyladC7SlbiYUt2BGUgxvt5ympt45rNMEzT1QST5KGlUA/v4WpV2NKh6yvMzqNQ/DmXZ0Uqya51NUqOn1m9u53sQpdOXKeJnkm127zUN6nOWKgY6wTEsh6vc71uYwcaVuB5lErG9+qDD9BZZdVQJ4Q7s=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+";
    
    //Create the grid
    productSalesGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];
    
    productSalesGrid.licenseKey = licencekey;
    
    productSalesGrid.dataSource = productSalesDataSource;
    productSalesGrid.delegate = self;
    
    //Freeze our top and left most rows
    [productSalesGrid freezeRowsAboveAndIncludingRow:SGridRowMake(0, 0)];
    
    //Some basic grid styling
    productSalesGrid.backgroundColor = [UIColor whiteColor];
    productSalesGrid.rowStylesTakePriority = YES;
    productSalesGrid.defaultGridLineStyle.width = 1.0f;
    productSalesGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    productSalesGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    productSalesGrid.defaultBorderStyle.width = 1.0f;
    
    productSalesGrid.defaultSectionHeaderStyle.font = [UIFont fontWithName:@"Arial" size:10.0f];
    
    //provide default row heights and col widths
    productSalesGrid.defaultRowStyle.size = [NSNumber numberWithFloat:25];
    productSalesGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:43];
    
    //ensure that section header is hidden (a grid has one section by default)
    productSalesGrid.defaultSectionHeaderStyle.hidden = YES;
    productSalesGrid.defaultSectionHeaderStyle.hidden = YES;
    
    //We dont want to be able to edit our cells
    productSalesGrid.canEditCellsViaDoubleTap = NO;
    
    //Enable dragging - we want to be able to reorder in any direction
    productSalesGrid.canReorderColsViaLongPress = YES;
    productSalesGrid.canReorderRowsViaLongPress = YES;
    
    productSalesGrid.frame = CGRectMake(1, 1, 2, 2);
    
    // this displays the grid
    [self.view addSubview:productSalesGrid];
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
    
    productSalesGrid.frame = CGRectMake(9, 280, self.view.bounds.size.width-20, self.view.bounds.size.height-300);

    UIViewController *templateController = [self.storyboard instantiateViewControllerWithIdentifier:isPortrait ? @"ProductSalesPortraitView" : @"ProductSalesLandscapeView"];
    if (templateController)
    {
        int count = 0;
        for (UIView *eachView in ProductSalesSubviews(templateController.view))
        {
            NSLog(@"Tag %d %@ %d", count++, eachView.accessibilityLabel  , eachView.tag);
            
            int tag = eachView.tag;
            if(tag < 10 ) continue;
            [self.view viewWithTag:tag].frame = eachView.frame;
        }
    }
}

NSArray *ProductSalesSubviews(UIView *aView)
{
    NSArray *results = [aView subviews];
    for (UIView *eachView in [aView subviews])
    {
        NSArray *theSubviews = ProductSalesSubviews(eachView);
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
