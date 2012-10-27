//
//  evCustomerSalesViewController.m
//  Vision
//
//  Created by Ian Molesworth on 23/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "evCustomerSalesViewController.h"

#import "User.h"
#import "Customer.h"
#import "Practice.h"
#import "umfundiAppDelegate.h"
#import "umfundiViewController.h"
#import "CustomerSalesDataSource.h"
#import "CustomerSalesAggrPerCustomer.h"

#define FilterTypePractice          0
#define FilterTypeCustomer          1
#define FilterTypeCountry           2
#define FilterTypeKeyAccountManager 3
#define FilterTypeGroup             4
#define FilterTypeCounty            5

@interface evCustomerSalesViewController ()

@end

@implementation evCustomerSalesViewController

@synthesize selectedPractice;
@synthesize selectedUser;
@synthesize selectedCustomer;
@synthesize selectedFilterVal;

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
    self.selectedUser = [User loginUser];
    
    currentFilter = FilterTypePractice;
    isYTD = YES;
    
    customerSalesDataSource = [[CustomerSalesDataSource alloc] init];
    
    NSString *licencekey = @"qgi64t6X5laUi6GMjAxMjExMTNpbmZvQHNoaW5vYmljb250cm9scy5jb20=UQ5WGyladC7SlbiYUt2BGUgxvt5ympt45rNMEzT1QST5KGlUA/v4WpV2NKh6yvMzqNQ/DmXZ0Uqya51NUqOn1m9u53sQpdOXKeJnkm127zUN6nOWKgY6wTEsh6vc71uYwcaVuB5lErG9+qDD9BZZdVQJ4Q7s=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+";
    
    //Create the grid
    customerSalesGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];
    
    customerSalesGrid.licenseKey = licencekey;
    
    customerSalesGrid.dataSource = customerSalesDataSource;
    customerSalesGrid.delegate = self;
    
    //Freeze our top and left most rows
    [customerSalesGrid freezeRowsAboveAndIncludingRow:SGridRowMake(0, 0)];
    
    //Some basic grid styling
    customerSalesGrid.backgroundColor = [UIColor whiteColor];
    customerSalesGrid.rowStylesTakePriority = YES;
    customerSalesGrid.defaultGridLineStyle.width = 1.0f;
    customerSalesGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    customerSalesGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    customerSalesGrid.defaultBorderStyle.width = 1.0f;
    
    //provide default row heights and col widths
    customerSalesGrid.defaultRowStyle.size = [NSNumber numberWithFloat:30];
    customerSalesGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:100];
    
    //ensure that section header is hidden (a grid has one section by default)
    customerSalesGrid.defaultSectionHeaderStyle.hidden = YES;
    customerSalesGrid.defaultSectionHeaderStyle.hidden = YES;
    
    //We dont want to be able to edit our cells
    customerSalesGrid.canEditCellsViaDoubleTap = NO;
    
 
    //Enable dragging - we want to be able to reorder in any direction
    customerSalesGrid.canReorderColsViaLongPress = YES;
    customerSalesGrid.canReorderRowsViaLongPress = YES;
    
    customerSalesGrid.frame = CGRectMake(1, 1, 2, 2);

    [self displayGrids];

    // this displays the grid
    [self.view addSubview:customerSalesGrid];
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
    
    customerSalesGrid.frame = CGRectMake(9, 300, self.view.bounds.size.width-20, self.view.bounds.size.height-300);

    UIViewController *templateController = [self.storyboard instantiateViewControllerWithIdentifier:isPortrait ? @"CustomerSalesPortraitView" : @"CustomerSalesLandscapeView"];
    if (templateController)
    {
        int count = 0;
        for (UIView *eachView in CustomerSalesSubviews(templateController.view))
        {
            NSLog(@"Tag %d %@ %d", count++, eachView.accessibilityLabel  , eachView.tag);
            
            int tag = eachView.tag;
            if(tag < 10 ) continue;
            [self.view viewWithTag:tag].frame = eachView.frame;
        }
    }
}


NSArray *CustomerSalesSubviews(UIView *aView)
{
    NSArray *results = [aView subviews];
    for (UIView *eachView in [aView subviews])
    {
        NSArray *theSubviews = CustomerSalesSubviews(eachView);
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


- (void)displayPractice
{
    lblPracticeName.text = selectedPractice.practiceName;
    lblPracticeCode.text = selectedPractice.practiceCode;
    lblAddress1.text = selectedPractice.add1;
    lblAddress2.text = selectedPractice.city;
    lblAddress3.text = selectedPractice.province;
    lblPostcode.text = selectedPractice.postcode;
    
    lblIDUser.text = selectedUser.login;
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


- (IBAction)ytdClicked:(id)sender
{
    isYTD = YES;
    
    [self displayGrids];
}

- (IBAction)matClicked:(id)sender
{
    isYTD = NO;
    
    [self displayGrids];
}


#pragma mark -
#pragma mark Filter Delegates

- (void)countrySelected:(NSString *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;
    
    currentFilter = FilterTypeCountry;
    self.selectedFilterVal = selected;
    
    [self displayGrids];
}

- (void)countySelected:(NSString *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;
    
    currentFilter = FilterTypeCounty;
    self.selectedFilterVal = selected;
    
    [self displayGrids];
}

- (void)customerSelected:(Customer *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;
    
    currentFilter = FilterTypeCustomer;
    self.selectedCustomer = selected;
    
    [self displayGrids];
}

- (void)groupSelected:(NSString *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;
    
    currentFilter = FilterTypeGroup;
    self.selectedFilterVal = selected;
    
    [self displayGrids];
}

- (void)keyAccountManagerSelected:(User *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;
    
    currentFilter = FilterTypeKeyAccountManager;
    self.selectedUser = selected;
    [self displayPractice];
    
    [self displayGrids];
}

- (void)practiceSelected:(Practice *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;
    
    currentFilter = FilterTypePractice;
    self.selectedPractice = selected;
    [self displayPractice];
    
    [self displayGrids];
}


- (void)displayGrids
{
    if (currentFilter == FilterTypePractice)
    {
        customerSalesDataSource.customerSalesArray = [CustomerSalesAggrPerCustomer CustomerSalesGroupByGroupFrom:@"id_practice" andValue:selectedPractice.practiceCode YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeCustomer)
    {
        customerSalesDataSource.customerSalesArray = [CustomerSalesAggrPerCustomer CustomerSalesGroupByGroupFrom:@"id_customer" andValue:selectedCustomer.id_customer YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeGroup)
    {
        customerSalesDataSource.customerSalesArray = [CustomerSalesAggrPerCustomer CustomerSalesGroupByGroupFrom:@"groupName" andValue:selectedFilterVal YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeKeyAccountManager)
    {
        customerSalesDataSource.customerSalesArray = [CustomerSalesAggrPerCustomer CustomerSalesGroupByGroupFrom:@"id_user" andValue:selectedUser.id_user YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeCountry)
    {
        customerSalesDataSource.customerSalesArray = [CustomerSalesAggrPerCustomer CustomerSalesGroupByGroupFromCustomers:@"country" andValue:selectedFilterVal YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeCounty)
    {
        customerSalesDataSource.customerSalesArray = [CustomerSalesAggrPerCustomer CustomerSalesGroupByGroupFromCustomers:@"province" andValue:selectedFilterVal YTDorMAT:isYTD];
    }
    
    [customerSalesGrid reload];
}

@end
