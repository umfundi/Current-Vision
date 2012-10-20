//  Vision
//
//  umfundiViewController.m
//
//  Created by Ian Molesworth on 02/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "umfundiViewController.h"
#import "ShinobiGrids/ShinobiGrid.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"

#import "Customer.h"
#import "Practice.h"
#import "User.h"
#import "CustomerAggr.h"

#import "SearchResultViewController.h"
#import "umfundiCommon.h"
#import "SitesDataSource.h"
#import "SalesDataSource.h"
#import "umfundiAppDelegate.h"

@interface umfundiViewController ()

@end

@implementation umfundiViewController

@synthesize currentCustomer;

#pragma mark Grid Delegate methods
// Column and Row Styling
- (SGridColRowStyle *)shinobiGrid:(ShinobiGrid *)grid styleForRowAtIndex:(int)rowIndex inSection:(int) sectionIndex
{
    SGridColRowStyle *style = [[SGridColRowStyle alloc] init];
    //Set the size and text colour of the first row
    if (rowIndex == 0)
    {
        style.size = [NSNumber numberWithInt:40];
    } else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            style.size = [NSNumber numberWithInt:36];
        } else {
            style.size = [NSNumber numberWithInt:26];
        }
    }
    
    style.backgroundColor = [UIColor whiteColor];
    return style;
}

- (SGridSectionHeaderStyle *)shinobiGrid:(ShinobiGrid *)grid styleForSectionHeaderAtIndex:(int) sectionIndex
{
    if (grid == salesGrid && sectionIndex != 0)
    {
        SGridSectionHeaderStyle *s = [[SGridSectionHeaderStyle alloc] initWithHeight:25.f withBackgroundColor:[UIColor grayColor]];
        return s;
    }
    
    return nil;
}


- (SGridColRowStyle *)shinobiGrid:(ShinobiGrid *)grid styleForColAtIndex:(int)colIndex
{
    SGridColRowStyle *style = [[SGridColRowStyle alloc] init];

    if (grid == sitesGrid )
    {
    //Set fixed width for certain columns
    if(colIndex == 0) {
        style.size = [NSNumber numberWithFloat:80];
            return style;
    } else if(colIndex == 1) {
        style.size = [NSNumber numberWithFloat:250];
        return style;
    } else if (colIndex == 2) {
        style.size = [NSNumber numberWithFloat:150];
        return style;
    } else if (colIndex > 3) {
        style.size = [NSNumber numberWithFloat:70];
        return style;
    }
    }
        
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];	
    // Do any additional setup after loading the view, typically from a nib.
    
    umfundiAppDelegate *appDelegate = (umfundiAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.frontViewController = self;
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.view.bounds];
    iv.autoresizingMask = ~UIViewAutoresizingNone;
    [self.view addSubview:iv];
    
    sitesDataSource = [[SitesDataSource alloc] init];
    salesDataSource = [[SalesDataSource alloc] init];
        
    NSString *licencekey = @"qgi64t6X5laUi6GMjAxMjExMTNpbmZvQHNoaW5vYmljb250cm9scy5jb20=UQ5WGyladC7SlbiYUt2BGUgxvt5ympt45rNMEzT1QST5KGlUA/v4WpV2NKh6yvMzqNQ/DmXZ0Uqya51NUqOn1m9u53sQpdOXKeJnkm127zUN6nOWKgY6wTEsh6vc71uYwcaVuB5lErG9+qDD9BZZdVQJ4Q7s=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+";

    //Create the grid
    sitesGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];  
    salesGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];
    
    sitesGrid.licenseKey = licencekey;
    salesGrid.licenseKey = licencekey;
    
    sitesGrid.dataSource = sitesDataSource;
    sitesGrid.delegate = self;
    salesGrid.dataSource = salesDataSource;
    salesGrid.delegate = self;

    //Freeze our top and left most rows
    [sitesGrid freezeRowsAboveAndIncludingRow:SGridRowMake(0, 0)];
    [salesGrid freezeRowsAboveAndIncludingRow:SGridRowMake(0, 0)];
    
    //Some basic grid styling
    sitesGrid.backgroundColor = [UIColor whiteColor];
    sitesGrid.rowStylesTakePriority = YES;
    sitesGrid.defaultGridLineStyle.width = 1.0f;
    sitesGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    sitesGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    sitesGrid.defaultBorderStyle.width = 1.0f;

    salesGrid.backgroundColor = [UIColor whiteColor];
    salesGrid.rowStylesTakePriority = YES;
    salesGrid.defaultGridLineStyle.width = 1.0f;
    salesGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    salesGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    salesGrid.defaultBorderStyle.width = 1.0f;
    
    //provide default row heights and col widths
    sitesGrid.defaultRowStyle.size = [NSNumber numberWithFloat:25];
    sitesGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:100];
        
    salesGrid.defaultRowStyle.size = [NSNumber numberWithFloat:25];
    salesGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:125];
    
    //ensure that section header is hidden (a grid has one section by default)
    sitesGrid.defaultSectionHeaderStyle.hidden = YES;
    salesGrid.defaultSectionHeaderStyle.hidden = YES;
    
    //We dont want to be able to edit our cells
    sitesGrid.canEditCellsViaDoubleTap = NO;
    salesGrid.canEditCellsViaDoubleTap = NO;
    
    //Enable dragging - we want to be able to reorder in any direction
    sitesGrid.canReorderColsViaLongPress = YES;
    sitesGrid.canReorderRowsViaLongPress = YES;
    salesGrid.canReorderColsViaLongPress = YES;
    salesGrid.canReorderRowsViaLongPress = NO;
    
    salesGrid.frame = CGRectMake(1, 1, 2, 2);
    sitesGrid.frame = CGRectMake(1, 1, 2, 2);
    
    // this displays the first grid
    [self.view addSubview:sitesGrid];
    [self.view addSubview:salesGrid];
    [salesGrid setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self didRotateFromInterfaceOrientation:0];
    
    [self displayCustomer];
    [self applyTheme:[[User loginUser].data isEqualToString:@"companion"]];    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [searchField resignFirstResponder];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

// respond to interface re-orientation by updating the layout
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    BOOL isPortrait = UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    
    if (isPortrait){
        sitesGrid.frame = CGRectMake(9, 448, self.view.bounds.size.width-20, self.view.bounds.size.height-600);
        salesGrid.frame = CGRectMake(9, 448, self.view.bounds.size.width-20, self.view.bounds.size.height-600);

    } else {
        sitesGrid.frame = CGRectMake(520, 137, 502, 540);
        salesGrid.frame = CGRectMake(520, 137, 502, 540);
    }
    
    UIViewController *templateController = [self.storyboard instantiateViewControllerWithIdentifier:isPortrait ? @"MainPortraitView" : @"MainLandscapeView"];
    if (templateController)
        {
        for (UIView *eachView in allSubviews(templateController.view))
            {
            int tag = eachView.tag;
            if(tag < 10 ) continue;
            [self.view viewWithTag:tag].frame = eachView.frame;
            }
        }    
}

NSArray *allSubviews(UIView *aView)
{
    NSArray *results = [aView subviews];
    for (UIView *eachView in [aView subviews])
        {
        NSArray *theSubviews = allSubviews(eachView);
        if (theSubviews)
            results = [results arrayByAddingObjectsFromArray:theSubviews];
        }
    return results;
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark User Interface Action Handler

- (IBAction)searchClicked:(id)sender
{
    [searchField resignFirstResponder];
    
    if (!HUDSearch)
    {
        HUDSearch = [[MBProgressHUD alloc] initWithView:self.view];
        HUDSearch.labelText = NSLocalizedString(@"Searching...", @"");
        [self.view addSubview:HUDSearch];
    }
    
    [HUDSearch show:YES];
    
    [NSThread detachNewThreadSelector:@selector(searchThread:) toTarget:self withObject:sender];
}


- (IBAction)setSites:(UIButton *)sender
{
    [searchField resignFirstResponder];

    [sitesGrid setHidden:NO];
    [salesGrid setHidden:YES];
    
    sitesButton.selected = YES;
    salesButton.selected = NO;
}

- (IBAction)setSales:(UIButton *)sender
{
    [searchField resignFirstResponder];

    [sitesGrid setHidden:YES];
    [salesGrid setHidden:NO];
    
    salesButton.selected = YES;
    sitesButton.selected = NO;
}

- (IBAction)SyncData:(id)sender
{
    [searchField resignFirstResponder];
}


- (void)displayCustomer
{
    if (!currentCustomer)
    {
        self.currentCustomer = [Customer firstCustomer];
        if (!currentCustomer)
            return;
        
        [currentCustomer loadPracticeAndValues];
    }
    
    accountNoField.text = currentCustomer.id_customer;
    nameField.text = currentCustomer.customerName;
    addressField.text = currentCustomer.address1;
    townField.text = currentCustomer.city;
    countryField.text = currentCustomer.province;
    postcodeField.text = currentCustomer.postcode;
    brickField.text = currentCustomer.brick;
    SAPCodeField.text = currentCustomer.sap_no;
    MonthField.text = currentCustomer.aggrValue.monthString;
    YTDField.text = currentCustomer.aggrValue.ytdString;
    MATField.text = currentCustomer.aggrValue.matString;

    if (currentCustomer.practice)
    {
        practiceField.text = currentCustomer.practice.practiceName;
        
        NSLog(@"practiceCode = %@", currentCustomer.practice.practiceCode);
        [currentCustomer.practice loadCustomers];
        
        sitesDataSource.sitesArray = [currentCustomer.practice.customers allObjects];
        for (Customer *customer in sitesDataSource.sitesArray)
            [customer loadPracticeAndValues];
        [sitesGrid reload];
        
        salesDataSource.salesArray = currentCustomer.aggrValue.aggrPerBrands;
        [salesGrid reload];
    }
    else
    {
        practiceField.text = @"-";
        
        sitesDataSource.sitesArray = nil;
        [sitesGrid reload];

        salesDataSource.salesArray = nil;
        [salesGrid reload];
    }
}

- (void)applyTheme:(BOOL)redTheme
{
    // About Button Background Image
    NSString *logo = redTheme ? @"companion_logo.png" : @"logo.png";
    [aboutButton setImage:[UIImage imageNamed:logo] forState:UIControlStateNormal];
    
    // Select Label Background Color
    UIColor *backColor = redTheme ? [UIColor colorWithRed:220.0 / 255 green:0 blue:0 alpha:1] :
                                    [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
    [selectLabel setBackgroundColor:backColor];
    
    // Buttons Title Color
    UIColor *titleColor = redTheme ? [UIColor colorWithRed:180.0 / 255 green:0 blue:0 alpha:1] :
                                    [UIColor colorWithRed:50.0 / 255 green:79.0 / 255 blue:133.0 / 255 alpha:1];
    
    [umfundiCommon applyColorToButton:accountButton withColor:titleColor];
    [umfundiCommon applyColorToButton:nameButton withColor:titleColor];
    [umfundiCommon applyColorToButton:townButton withColor:titleColor];
    [umfundiCommon applyColorToButton:postcodeButton withColor:titleColor];

    [umfundiCommon applyColorToButton:salesButton withColor:titleColor];
    [umfundiCommon applyColorToButton:sitesButton withColor:titleColor];
    
    [umfundiCommon applyColorToButton:salesTrendButton withColor:titleColor];
    [umfundiCommon applyColorToButton:productSalesButton withColor:titleColor];
    [umfundiCommon applyColorToButton:erReportButton withColor:titleColor];
    [umfundiCommon applyColorToButton:clientSalesButton withColor:titleColor];
    [umfundiCommon applyColorToButton:sitesDistributionButton withColor:titleColor];
    [umfundiCommon applyColorToButton:customerSalesButton withColor:titleColor];
}

- (void)searchThread:(id)sender
{
    NSString *keyField;
    switch ([sender tag])
    {
        case 210:
            keyField = @"id_customer";
            break;
        case 211:
            keyField = @"customerName";
            break;
        case 212:
            keyField = @"province";
            break;
        case 213:
            keyField = @"postcode";
            break;
        default:
            return;
    }
    
    NSString *searchKey = searchField.text;

//    // Fetch Practices
//    NSArray *practices = [Practice searchPracticesWithField:keyField andKey:searchKey];
//
//    // Fetch Customers from Practices
//    NSMutableArray *resultCustomers = [[NSMutableArray alloc] initWithCapacity:0];
//    for (Practice *practice in practices)
//    {
//        [practice loadCustomers];
//        [resultCustomers addObjectsFromArray:[practice.customers allObjects]];
//    }
//    
//    searchResults = resultCustomers;
    
    searchResults = [Customer searchCustomersWithField:keyField andKey:searchKey];

    [self performSelectorOnMainThread:@selector(searchFinished:) withObject:sender waitUntilDone:YES];
}

- (void)searchFinished:(id)sender
{
    [HUDSearch hide:YES];
    
    SearchResultViewController *resultViewController = [[SearchResultViewController alloc] init];
    resultViewController.searchResult = searchResults;
    resultViewController.delegate = self;
    
    searchPopoverController = [[UIPopoverController alloc] initWithContentViewController:resultViewController];
    [searchPopoverController presentPopoverFromRect:[sender frame]
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionUp
                                           animated:YES];
}

#pragma mark -
#pragma mark SearchSelectDelegate

- (void)customerSelected:(Customer *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;
    
    self.currentCustomer = selected;
    [currentCustomer loadPracticeAndValues];

    [self displayCustomer];
}

@end
