//
//  evErReportViewController.m
//  Vision
//
//  Created by Ian Molesworth on 23/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "evErReportViewController.h"

#import "User.h"
#import "Customer.h"
#import "Practice.h"
#import "umfundiAppDelegate.h"
#import "umfundiViewController.h"
#import "ErReportDataSource.h"
#import "ErReportAggrPerBrand.h"

#define FilterTypePractice          0
#define FilterTypeCustomer          1
#define FilterTypeCountry           2
#define FilterTypeKeyAccountManager 3
#define FilterTypeGroup             4
#define FilterTypeCounty            5

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
    self.selectedPractice = appDelegate.frontViewController.currentPractice;
    
    lblPracticeName.text = selectedPractice.practiceName;
    lblPracticeCode.text = selectedPractice.practiceCode;
    lblAddress1.text = selectedPractice.add1;
    lblAddress2.text = selectedPractice.province;
    lblAddress3.text = selectedPractice.country;
    lblPostcode.text = selectedPractice.postcode;
    lblIDUser.text = [User loginUser].login;
    
    erReportDataSource = [[ErReportDataSource alloc] init];
    erReportDataSource.erReportArray = [ErReportAggrPerBrand ErReportGroupByBrandFrom:appDelegate.frontViewController.currentPractice.practiceCode];
    
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
    erReportGrid.defaultRowStyle.size = [NSNumber numberWithFloat:30];
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
    
    currentFilter = FilterTypePractice;
    [self displayHeaderinfoblock];
//    [self displayGrids];
    
    
    // this displays the grid
    [self.view addSubview:erReportGrid];
}

-(void) viewWillAppear:(BOOL)animated{
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
 //           NSLog(@"Tag %d %@ %d", count++, eachView.accessibilityLabel  , eachView.tag);
            
            int tag = eachView.tag;
            if(tag < 10 ) continue;
            [self.view viewWithTag:tag].frame = eachView.frame;
        }
    }
}

- (void)displayHeaderinfoblock
{
    if (currentFilter == FilterTypePractice)
    {
        // Displaying practice so show the practice related labels and titles
        lblPracticeHdr.hidden = false;
        lblPracticeName.hidden = false;
        lblAddress1.hidden = false;
        lblAddress2.hidden = false;
        lblAddress3.hidden = false;
        lblPostcode.hidden = false;
        lblAccountHdr.hidden = false;
        lblPracticeCode.hidden = false;
        lblIDUser.hidden = false;
        lblAccmgrHdr.hidden = false;
        // Hide all the other labels
        lblCountryHdr.hidden = true;
        lblCountyHdr.hidden = true;
        lblBGroupHdr.hidden = true;
        
        // And populate the practice related labels
        lblPracticeName.text = selectedPractice.practiceName;
        
        lblAddress1.text = selectedPractice.add1;
        lblAddress2.text = selectedPractice.city;
        lblAddress3.text = selectedPractice.province;
        lblPostcode.text = selectedPractice.postcode;
        
        lblPracticeCode.text = selectedPractice.practiceCode;
        
        lblIDUser.text = @"KAM here";  // selectedUser.login;
    }
    else if (currentFilter == FilterTypeCustomer)
    {
        // Displaying customer so show the customer related labels
        lblPracticeHdr.hidden = false;
        lblPracticeName.hidden = false;
        lblAddress1.hidden = false;
        lblAddress2.hidden = false;
        lblAddress3.hidden = false;
        lblPostcode.hidden = false;
        lblAccountHdr.hidden = false;
        lblPracticeCode.hidden = false;
        lblAccmgrHdr.hidden = false;
        lblIDUser.hidden = false;
        
        // Hide all the other labels
        lblCountryHdr.hidden = true;
        lblCountyHdr.hidden = true;
        lblBGroupHdr.hidden = true;
        
        // And populate the Customer related labels
        lblPracticeName.text = selectedPractice.practiceName;
        
        lblAddress1.text = selectedPractice.add1;
        lblAddress2.text = selectedPractice.city;
        lblAddress3.text = selectedPractice.province;
        lblPostcode.text = selectedPractice.postcode;
        
        lblPracticeCode.text = selectedPractice.practiceCode;
        
        lblIDUser.text = @"KAM here";  //selectedUser.login;
    }
    else if (currentFilter == FilterTypeGroup)
    {
        // Displaying Buying group so show the group related labels and titles
        lblBGroupHdr.hidden = false;
        lblPracticeName.hidden = false;
        
        // Hide all the other labels
        lblPracticeHdr.hidden = true;
        lblAddress1.hidden = true;
        lblAddress2.hidden = true;
        lblAddress3.hidden = true;
        lblPostcode.hidden = true;
        lblAccountHdr.hidden = true;
        lblPracticeCode.hidden = true;
        lblAccmgrHdr.hidden = true;
        lblIDUser.hidden = true;
        lblCountryHdr.hidden = true;
        lblCountyHdr.hidden = true;
        
        // And populate the group label
        lblPracticeName.text = @"Group name here!";
    }
    else if (currentFilter == FilterTypeKeyAccountManager)
    {
        // Displaying County so show the Country related labels and titles
        lblAccmgrHdr.hidden = false;
        lblIDUser.hidden = false;
        
        // Hide all the other labels
        lblPracticeHdr.hidden = true;
        lblPracticeName.hidden = true;
        lblAddress1.hidden = true;
        lblAddress2.hidden = true;
        lblAddress3.hidden = true;
        lblPostcode.hidden = true;
        lblAccountHdr.hidden = true;
        lblPracticeCode.hidden = true;
        lblCountryHdr.hidden = true;
        lblCountyHdr.hidden = true;
        lblBGroupHdr.hidden = true;
        
        // And populate the Country label
        lblPracticeName.text = @"Account manager name here!";
    }
    else if (currentFilter == FilterTypeCountry)
    {
        // Displaying County so show the Country related labels and titles
        lblCountryHdr.hidden = false;
        lblPracticeName.hidden = false;
        
        // Hide all the other labels
        lblPracticeHdr.hidden = true;
        lblAddress1.hidden = true;
        lblAddress2.hidden = true;
        lblAddress3.hidden = true;
        lblPostcode.hidden = true;
        lblAccountHdr.hidden = true;
        lblPracticeCode.hidden = true;
        lblAccmgrHdr.hidden = true;
        lblIDUser.hidden = true;
        lblCountyHdr.hidden = true;
        lblBGroupHdr.hidden = true;
        
        // And populate the Country label
        lblPracticeName.text = selectedPractice.country;
    }
    else if (currentFilter == FilterTypeCounty)
    {
        // Displaying Country so show the County related labels and titles
        lblCountyHdr.hidden = false;
        lblPracticeName.hidden = false;
        
        // Hide all the other labels
        lblPracticeHdr.hidden = true;
        lblAddress1.hidden = true;
        lblAddress2.hidden = true;
        lblAddress3.hidden = true;
        lblPostcode.hidden = true;
        lblAccountHdr.hidden = true;
        lblPracticeCode.hidden = true;
        lblAccmgrHdr.hidden = true;
        lblIDUser.hidden = true;
        lblCountryHdr.hidden = true;
        lblBGroupHdr.hidden = true;
        
        // And populate the Country label
        lblPracticeName.text = selectedPractice.province;
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
    [super viewDidUnload];
}

- (IBAction)customerClicked:(id)sender
{
    AllCustomersViewController *resultViewController = [[AllCustomersViewController alloc] init];
    resultViewController.searchResult = [Customer allCustomers];
    resultViewController.delegate = self;
    
    searchPopoverController = [[UIPopoverController alloc] initWithContentViewController:resultViewController];
    [searchPopoverController presentPopoverFromRect:[sender frame]
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionUp
                                           animated:YES];
}

- (IBAction)practiceClicked:(id)sender
{
    AllPracticesViewController *resultViewController = [[AllPracticesViewController alloc] init];
    resultViewController.searchResult = [Practice allPractices];
    resultViewController.delegate = self;
    
    searchPopoverController = [[UIPopoverController alloc] initWithContentViewController:resultViewController];
    [searchPopoverController presentPopoverFromRect:[sender frame]
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionUp
                                           animated:YES];
}

- (IBAction)countyClicked:(id)sender
{
    AllCountiesViewController *resultViewController = [[AllCountiesViewController alloc] init];
    resultViewController.searchResult = [Customer allCounties];
    resultViewController.delegate = self;
    
    searchPopoverController = [[UIPopoverController alloc] initWithContentViewController:resultViewController];
    [searchPopoverController presentPopoverFromRect:[sender frame]
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionUp
                                           animated:YES];
}

- (IBAction)keyAccountManagerClicked:(id)sender
{
    AllKeyAccountManagersViewController *resultViewController = [[AllKeyAccountManagersViewController alloc] init];
    resultViewController.searchResult = [User allUsers];
    resultViewController.delegate = self;
    
    searchPopoverController = [[UIPopoverController alloc] initWithContentViewController:resultViewController];
    [searchPopoverController presentPopoverFromRect:[sender frame]
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionUp
                                           animated:YES];
}

- (IBAction)groupClicked:(id)sender
{
    AllGroupsViewController *resultViewController = [[AllGroupsViewController alloc] init];
    resultViewController.searchResult = [Customer allGroups];
    resultViewController.delegate = self;
    
    searchPopoverController = [[UIPopoverController alloc] initWithContentViewController:resultViewController];
    [searchPopoverController presentPopoverFromRect:[sender frame]
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionUp
                                           animated:YES];
}

- (IBAction)countryClicked:(id)sender
{
    AllCountriesViewController *resultViewController = [[AllCountriesViewController alloc] init];
    resultViewController.searchResult = [Customer allCountries];
    resultViewController.delegate = self;
    
    searchPopoverController = [[UIPopoverController alloc] initWithContentViewController:resultViewController];
    [searchPopoverController presentPopoverFromRect:[sender frame]
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionUp
                                           animated:YES];
}

- (void)displayGrids
{
    if (currentFilter == FilterTypePractice)
    {
//        monthReportDataSource.reportArray = [SalesTrendAggrPerBrand SalesTrendsGroupByBrandFrom:@"id_practice" andValue:selectedPractice.practiceCode YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeCustomer)
    {
//        monthReportDataSource.reportArray = [SalesTrendAggrPerBrand SalesTrendsGroupByBrandFrom:@"id_customer" andValue:selectedCustomer.id_customer YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeGroup)
    {
//        monthReportDataSource.reportArray = [SalesTrendAggrPerBrand SalesTrendsGroupByBrandFrom:@"groupName" andValue:selectedFilterVal YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeKeyAccountManager)
    {
//        monthReportDataSource.reportArray = [SalesTrendAggrPerBrand SalesTrendsGroupByBrandFrom:@"id_user" andValue:selectedUser.id_user YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeCountry)
    {
//        monthReportDataSource.reportArray = [SalesTrendAggrPerBrand SalesTrendsGroupByBrandFromCustomers:@"country" andValue:selectedFilterVal YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeCounty)
    {
//        monthReportDataSource.reportArray = [SalesTrendAggrPerBrand SalesTrendsGroupByBrandFromCustomers:@"province" andValue:selectedFilterVal YTDorMAT:isYTD];
    }
    
//    [monthReportGrid reload];
    
//  yearReportDataSource.reportArray = [SalesTrendAggrPerBrand yearReportsFrom:monthReportDataSource.reportArray];
//    yearReportDataSource.figureTitle = NSLocalizedString(isYTD ? @"YTD. Figures" : @"MAT. Figures", @"");
//    [yearReportGrid reload];
}


- (IBAction)ytdClicked:(id)sender
{
    isYTD = YES;
    
    [self displayGrids];
}

- (IBAction)matClicked:(id)sender
{
    isYTD = NO;
    
    [self displayGrids];
    
  //  lblIDUser.text = selectedUser.login;
}

- (IBAction)findClicked:(id)sender {
}

- (IBAction)nextClicked:(id)sender {
}

- (IBAction)fullClicked:(id)sender {
}

- (IBAction)btnPractice:(id)sender {
}




@end
