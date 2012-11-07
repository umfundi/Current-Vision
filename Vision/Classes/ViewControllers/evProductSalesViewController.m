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
#import "ProductSalesAggr.h"
#import "ProductSalesAggrPerBrand.h"
#import "umfundiCommon.h"

#define FilterTypePractice          0
#define FilterTypeCustomer          1
#define FilterTypeCountry           2
#define FilterTypeKeyAccountManager 3
#define FilterTypeGroup             4
#define FilterTypeCounty            5

@interface evProductSalesViewController ()

@end

@implementation evProductSalesViewController

@synthesize selectedPractice;
@synthesize selectedUser;
@synthesize selectedCustomer;
@synthesize selectedFilterVal;

#pragma mark -SGridDelegate

- (SGridSectionHeaderStyle *)shinobiGrid:(ShinobiGrid *)grid styleForSectionHeaderAtIndex:(int) sectionIndex
{
    if (![grid.dataSource shinobiGrid:grid titleForHeaderInSection:sectionIndex])
        return nil;
    
    SGridSectionHeaderStyle *s = [[SGridSectionHeaderStyle alloc] initWithHeight:20 withBackgroundColor:[UIColor lightGrayColor]];
    return s;
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
    
//    NSLog(@"Sect %d row %d", secIndex, rowIndex);
    
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
    if(colIndex == 0) {
        style.size = [NSNumber numberWithFloat:75];
        return style;
    } else if (colIndex == 4 || colIndex == 8 || colIndex == 12 || colIndex == 16 ) {
        style.size = [NSNumber numberWithFloat:55];
        return style;
    } else if (colIndex < 16 || colIndex == 19) {
        style.size = [NSNumber numberWithFloat:40];
        return style;
    }
    else {
        style.size = [NSNumber numberWithFloat:55];
        return style;
    }
    return nil;
}


- (void) shinobiGrid:(ShinobiGrid *)grid willExpandSectionAtIndex: (NSUInteger)sectionIndex
{
    
}

- (void) shinobiGrid:(ShinobiGrid *)grid willCollapseSectionAtIndex:(NSUInteger)sectionIndex
{
    
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
    isFull = NO;
    
    productSalesDataSource = [[ProductSalesDataSource alloc] init];
    
//    NSNumberFormatter *nf = [NSNumberFormatter new];
//    [nf setGroupingSize:3];
//    [nf setGroupingSeparator: [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator]];
//    productSalesDataSource.numberFormat = nf;

    productSalesDataSource.delegate = self;
    
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
    
    productSalesGrid.defaultSectionHeaderStyle.hidden = YES;
    
    //provide default row heights and col widths
    productSalesGrid.defaultRowStyle.size = [NSNumber numberWithFloat:25];
    productSalesGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:43];
    
    //We dont want to be able to edit our cells
    productSalesGrid.canEditCellsViaDoubleTap = NO;
    
    //Enable dragging - we want to be able to reorder in any direction
    productSalesGrid.canReorderColsViaLongPress = YES;
    productSalesGrid.canReorderRowsViaLongPress = YES;
    
    productSalesGrid.frame = CGRectMake(1, 1, 2, 2);
    
    currentFilter = FilterTypePractice;
    [self displayHeaderinfoblock];
    
    btnAll.hidden = true;

    // this displays the grid
    [self.view addSubview:productSalesGrid];

    HUDProcessing = [[MBProgressHUD alloc] initWithView:self.view];
    HUDProcessing.labelText = @"Processing tables ...";
    [self.view addSubview:HUDProcessing];

    [self displayGrids];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self didRotateFromInterfaceOrientation:0];
    
    [self applyTheme:[[User loginUser].data isEqualToString:@"companion"]];
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
        for (UIView *eachView in ProductSalesSubviews(templateController.view))
        {
            NSLog(@"Tag %@ %d", eachView.accessibilityLabel  , eachView.tag);
            
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
    btnFull = nil;
    btnAll = nil;
    [super viewDidUnload];
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
        lblAccmgrHdr.hidden = false;
        lblIDUser.hidden = false;
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
        
        lblIDUser.text = [User loginUser].login;
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
        lblPracticeName.text = selectedCustomer.practice.practiceName;
        
        lblAddress1.text = selectedCustomer.practice.add1;
        lblAddress2.text = selectedCustomer.practice.city;
        lblAddress3.text = selectedCustomer.practice.province;
        lblPostcode.text = selectedCustomer.practice.postcode;
        
        lblPracticeCode.text = selectedCustomer.practice.practiceCode;
        
        lblIDUser.text = selectedCustomer.customerName;
        
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
        if ([selectedFilterVal isEqualToString:@"-"])
            lblPracticeName.text = @"No Group";
        else
            lblPracticeName.text = selectedFilterVal;
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
        lblIDUser.text = selectedUser.login;
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
        lblPracticeName.text = selectedFilterVal;
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
        lblPracticeName.text = selectedFilterVal;
    }
}


- (IBAction)doneClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)customerClicked:(id)sender
{
    [HUDProcessing show:YES];
    
    [NSThread detachNewThreadSelector:@selector(loadAllCustomers:) toTarget:self withObject:sender];
}

- (void)loadAllCustomers:(id)sender
{
    @autoreleasepool
    {
        allCustomers = [Customer allCustomers];
        [self performSelectorOnMainThread:@selector(showAllCustomers:) withObject:sender waitUntilDone:YES];
        [HUDProcessing hide:YES];
    }
}

- (void)showAllCustomers:(id)sender
{
    AllCustomersViewController *resultViewController = [[AllCustomersViewController alloc] init];
    resultViewController.searchResult = allCustomers;
    resultViewController.delegate = self;
    
    searchPopoverController = [[UIPopoverController alloc] initWithContentViewController:resultViewController];
    [searchPopoverController presentPopoverFromRect:[sender frame]
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionUp
                                           animated:YES];
}


- (IBAction)practiceClicked:(id)sender
{
    [HUDProcessing show:YES];
    
    [NSThread detachNewThreadSelector:@selector(loadAllPractices:) toTarget:self withObject:sender];
}

- (void)loadAllPractices:(id)sender
{
    @autoreleasepool
    {
        allPractices = [Practice allPractices];
        [self performSelectorOnMainThread:@selector(showAllPractices:) withObject:sender waitUntilDone:YES];
        [HUDProcessing hide:YES];
    }
}

- (void)showAllPractices:(id)sender
{
    AllPracticesViewController *resultViewController = [[AllPracticesViewController alloc] init];
    resultViewController.searchResult = allPractices;
    resultViewController.delegate = self;
    
    searchPopoverController = [[UIPopoverController alloc] initWithContentViewController:resultViewController];
    [searchPopoverController presentPopoverFromRect:[sender frame]
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionUp
                                           animated:YES];
}

- (IBAction)countyClicked:(id)sender
{
    [HUDProcessing show:YES];
    
    [NSThread detachNewThreadSelector:@selector(loadAllCounties:) toTarget:self withObject:sender];
}

- (void)loadAllCounties:(id)sender
{
    @autoreleasepool
    {
        allCounties = [Customer allCounties];
        [self performSelectorOnMainThread:@selector(showAllCounties:) withObject:sender waitUntilDone:YES];
        [HUDProcessing hide:YES];
    }
}

- (void)showAllCounties:(id)sender
{
    AllCountiesViewController *resultViewController = [[AllCountiesViewController alloc] init];
    resultViewController.searchResult = allCounties;
    resultViewController.delegate = self;
    
    searchPopoverController = [[UIPopoverController alloc] initWithContentViewController:resultViewController];
    [searchPopoverController presentPopoverFromRect:[sender frame]
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionUp
                                           animated:YES];
}

- (IBAction)keyAccountManagerClicked:(id)sender
{
    [HUDProcessing show:YES];
    
    [NSThread detachNewThreadSelector:@selector(loadAllKeyAccountManagers:) toTarget:self withObject:sender];
}

- (void)loadAllKeyAccountManagers:(id)sender
{
    @autoreleasepool
    {
        allKeyAccountManagers = [User allUsers];
        [self performSelectorOnMainThread:@selector(showAllKeyAccountManagers:) withObject:sender waitUntilDone:YES];
        [HUDProcessing hide:YES];
    }
}

- (void)showAllKeyAccountManagers:(id)sender
{
    AllKeyAccountManagersViewController *resultViewController = [[AllKeyAccountManagersViewController alloc] init];
    resultViewController.searchResult = allKeyAccountManagers;
    resultViewController.delegate = self;
    
    searchPopoverController = [[UIPopoverController alloc] initWithContentViewController:resultViewController];
    [searchPopoverController presentPopoverFromRect:[sender frame]
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionUp
                                           animated:YES];
}

- (IBAction)groupClicked:(id)sender
{
    [HUDProcessing show:YES];
    
    [NSThread detachNewThreadSelector:@selector(loadAllGroups:) toTarget:self withObject:sender];
}

- (void)loadAllGroups:(id)sender
{
    @autoreleasepool
    {
        allGroups = [Customer allGroups];
        [self performSelectorOnMainThread:@selector(showAllGroups:) withObject:sender waitUntilDone:YES];
        [HUDProcessing hide:YES];
    }
}

- (void)showAllGroups:(id)sender
{
    AllGroupsViewController *resultViewController = [[AllGroupsViewController alloc] init];
    resultViewController.searchResult = allGroups;
    resultViewController.delegate = self;
    
    searchPopoverController = [[UIPopoverController alloc] initWithContentViewController:resultViewController];
    [searchPopoverController presentPopoverFromRect:[sender frame]
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionUp
                                           animated:YES];
}

- (IBAction)countryClicked:(id)sender
{
    [HUDProcessing show:YES];
    
    [NSThread detachNewThreadSelector:@selector(loadAllCountries:) toTarget:self withObject:sender];
}

- (void)loadAllCountries:(id)sender
{
    @autoreleasepool
    {
        allCountries = [Customer allCountries];
        [self performSelectorOnMainThread:@selector(showAllCountries:) withObject:sender waitUntilDone:YES];
        [HUDProcessing hide:YES];
    }
}

- (void)showAllCountries:(id)sender
{
    AllCountriesViewController *resultViewController = [[AllCountriesViewController alloc] init];
    resultViewController.searchResult = allCountries;
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
    isFull = NO;
    
    [self displayGrids];
}

- (IBAction)matClicked:(id)sender
{
    isYTD = NO;
    isFull = NO;
    
    [self displayGrids];
}

- (IBAction)fullClicked:(id)sender
{
    isYTD = NO;
    isFull = YES;
    
    [self displayGrids];
}

- (IBAction)findClicked:(id)sender
{
    [findText resignFirstResponder];
    if ([findText.text length] == 0)
        return;
    
    last_col = -1;
    last_row = 0;
    
    [self nextClicked:sender];
}

- (IBAction)nextClicked:(id)sender
{
    [findText resignFirstResponder];
    if ([findText.text length] == 0)
        return;
    
    NSInteger col_count = productSalesGrid.numberOfColumns;
    NSInteger section_count = productSalesGrid.numberOfSections;
    NSInteger row_count = 0;
    for (NSInteger section = 0 ; section < section_count ; section ++ )
        row_count += [productSalesGrid numberOfRowsForSection:section];
    
    NSInteger total_cell_count = col_count * row_count;
    NSInteger last_cell = last_row * col_count + last_col;
    
    for (NSInteger cell = last_cell + 1; cell < last_cell + 1 + total_cell_count ; cell ++ )
    {
        NSInteger cell_in_grid = cell % total_cell_count;
        
        NSInteger col = cell_in_grid % col_count;
        NSInteger row = cell_in_grid / col_count;
        
        CGRect cell_rect = CGRectMake(1, 1, 0, 0);
        for (NSInteger i = 0 ; i < col ; i ++ )
        {
            SGridColRowStyle *style = [self shinobiGrid:productSalesGrid styleForColAtIndex:i];
            if (style)
                cell_rect.origin.x += [style.size doubleValue] + 1;
            else
                cell_rect.origin.x += [productSalesGrid.defaultColumnStyle.size doubleValue] + 1;
        }
        
        SGridColRowStyle *col_style = [self shinobiGrid:productSalesGrid styleForColAtIndex:col];
        if (col_style)
            cell_rect.size.width = [col_style.size doubleValue] + 1;
        else
            cell_rect.size.width = [productSalesGrid.defaultColumnStyle.size doubleValue] + 1;
        
        
        BOOL broken;
        NSInteger j = 0;
        for (NSInteger section = 0 ; section < section_count ; section ++ )
        {
            broken = NO;
            NSInteger rows = [productSalesGrid numberOfRowsForSection:section];
            for (NSInteger row_no = 0 ; row_no < rows ; row_no ++ )
            {
                SGridColRowStyle *style = [self shinobiGrid:productSalesGrid styleForRowAtIndex:row_no inSection:section];
                double height;
                if (style)
                    height = [style.size doubleValue];
                else
                    height = [productSalesGrid.defaultRowStyle.size doubleValue] + 1;

                if (j < row)
                    cell_rect.origin.y += height;
                else if (j == row)
                {
                    cell_rect.size.height = height;

                    NSString *text = [productSalesDataSource shinobiGrid:productSalesGrid textForGridCoord:[[SGridCoord alloc] initWithColumn:col withRow:SGridRowMake(row_no, section)]];
                    if (text && [text rangeOfString:findText.text].location != NSNotFound)
                    {
                        [productSalesGrid scrollRectToVisible:cell_rect animated:NO];
                        [self performSelector:@selector(cellFound) withObject:nil afterDelay:0.1];
                        
                        last_col = col;
                        last_row = row;
                        
                        return;
                    }

                    broken = YES;
                    break;
                }

                j ++ ;
            }
            
            if (broken)
                break;
        }
    }
}


- (IBAction)allClicked:(id)sender {
    
    // Switch back to the brand view of the data here
    productSalesDataSource.productSalesAggr = productSalesAggr;
    
    btnAll.hidden = YES;
    [productSalesGrid reload];
}

- (void)cellFound
{
    NSInteger row_no = last_row;
    NSInteger section_count = productSalesGrid.numberOfSections;
    for (NSInteger section = 0 ; section < section_count ; section ++ )
    {
        NSInteger rows = [productSalesGrid numberOfRowsForSection:section];
        if (row_no < rows)
        {
            SGridCell *grid_cell = [productSalesGrid visibleCellAtCol:last_col andRow:SGridRowMake(row_no, section)];
            if (!grid_cell)
            {
                [self performSelector:@selector(cellFound) withObject:nil afterDelay:0.1];
                return;
            }
            [grid_cell setSelected:YES animated:YES];
            
            return;
        }
        
        row_no -= rows;
    }
}


#pragma mark -
#pragma mark Filter Delegates

- (void)countrySelected:(NSString *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;
    
    currentFilter = FilterTypeCountry;
    self.selectedFilterVal = selected;
    
    [self displayHeaderinfoblock];
    [self displayGrids];
}

- (void)countySelected:(NSString *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;
    
    currentFilter = FilterTypeCounty;
    self.selectedFilterVal = selected;
    
    [self displayHeaderinfoblock];
    [self displayGrids];
}

- (void)customerSelected:(Customer *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;
    
    currentFilter = FilterTypeCustomer;
    self.selectedCustomer = selected;
    
    [self displayHeaderinfoblock];
    [self displayGrids];
}

- (void)groupSelected:(NSString *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;
    
    currentFilter = FilterTypeGroup;
    self.selectedFilterVal = selected;
    
    [self displayHeaderinfoblock];
    [self displayGrids];
}

- (void)keyAccountManagerSelected:(User *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;
    
    currentFilter = FilterTypeKeyAccountManager;
    self.selectedUser = selected;
    
    [self displayHeaderinfoblock];    
    [self displayGrids];
}

- (void)practiceSelected:(Practice *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;
    
    currentFilter = FilterTypePractice;
    self.selectedPractice = selected;
    
    [self displayHeaderinfoblock];
    [self displayGrids];
}


- (void)displayGrids
{
    [HUDProcessing show:YES];
    
    [NSThread detachNewThreadSelector:@selector(loadValues) toTarget:self withObject:nil];
}

- (void)loadValues
{
    @autoreleasepool
    {
        if (currentFilter == FilterTypePractice)
        {
            productSalesDataSource.productSalesAggr = [ProductSalesAggr ProductSalesGroupByBrandFrom:@"id_practice" andValue:selectedPractice.practiceCode YTDorMAT:isYTD isFull:isFull];
        }
        else if (currentFilter == FilterTypeCustomer)
        {
            productSalesDataSource.productSalesAggr = [ProductSalesAggr ProductSalesGroupByBrandFrom:@"id_customer" andValue:selectedCustomer.id_customer YTDorMAT:isYTD isFull:isFull];
        }
        else if (currentFilter == FilterTypeGroup)
        {
            productSalesDataSource.productSalesAggr = [ProductSalesAggr ProductSalesGroupByBrandFrom:@"groupName" andValue:selectedFilterVal YTDorMAT:isYTD isFull:isFull];
        }
        else if (currentFilter == FilterTypeKeyAccountManager)
        {
            productSalesDataSource.productSalesAggr = [ProductSalesAggr ProductSalesGroupByBrandFrom:@"id_user" andValue:selectedUser.id_user YTDorMAT:isYTD isFull:isFull];
        }
        else if (currentFilter == FilterTypeCountry)
        {
            productSalesDataSource.productSalesAggr = [ProductSalesAggr ProductSalesGroupByBrandFromCustomers:@"country" andValue:selectedFilterVal YTDorMAT:isYTD isFull:isFull];
        }
        else if (currentFilter == FilterTypeCounty)
        {
            productSalesDataSource.productSalesAggr = [ProductSalesAggr ProductSalesGroupByBrandFromCustomers:@"province" andValue:selectedFilterVal YTDorMAT:isYTD isFull:isFull];
        }
        
        productSalesDataSource.isYTD = isYTD;
        productSalesDataSource.isFull = isFull;
        [productSalesGrid performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
        [HUDProcessing hide:YES];

        last_col = -1;
        last_row = 0;
    }
}

- (void)applyTheme:(BOOL)redTheme
{
    // About Button Background Image
    NSString *logo = redTheme ? @"Companion_HC.png" : @"Ruminant_HB.png";
    [imgLogo setImage:[UIImage imageNamed:logo]];
    
    // Select Label Background Color
    UIColor *backColor = redTheme ? [UIColor colorWithRed:220.0 / 255 green:0 blue:0 alpha:1] :
    [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
    [lblThemeBox setBackgroundColor:backColor];
    
    // Buttons Title Color
    UIColor *titleColor = redTheme ? [UIColor colorWithRed:180.0 / 255 green:0 blue:0 alpha:1] :
    [UIColor colorWithRed:50.0 / 255 green:79.0 / 255 blue:133.0 / 255 alpha:1];
    
    [umfundiCommon applyColorToButton:btnMAT withColor:titleColor];
    [umfundiCommon applyColorToButton:btmYTD withColor:titleColor];
    [umfundiCommon applyColorToButton:btnFull withColor:titleColor];
    [umfundiCommon applyColorToButton:btnAll withColor:titleColor];
    
    [umfundiCommon applyColorToButton:btnCustomer withColor:titleColor];
    [umfundiCommon applyColorToButton:btnBGroup withColor:titleColor];
    [umfundiCommon applyColorToButton:btnKAM withColor:titleColor];
    [umfundiCommon applyColorToButton:btnPractice withColor:titleColor];
    [umfundiCommon applyColorToButton:btnCounty withColor:titleColor];
    [umfundiCommon applyColorToButton:btnCountry withColor:titleColor];
    
    [umfundiCommon applyColorToButton:btnFind withColor:titleColor];
    [umfundiCommon applyColorToButton:btnNext withColor:titleColor];
    
    [umfundiCommon applyColorToButton:btnDone withColor:titleColor];
}

#pragma mark -
#pragma mark ProductSalesDataSourceDelegate

- (void)brandSelected:(ProductSalesAggrPerBrand *)brand
{
    productSalesAggr = productSalesDataSource.productSalesAggr;
    productSalesDataSource.productSalesAggr = [ProductSalesAggr aggrFromAggrPerBrandsArray:brand.aggrPerProducts YTDorMAT:isYTD isFull:isFull];
    [productSalesGrid reload];
    btnAll.hidden = NO;
}

@end
