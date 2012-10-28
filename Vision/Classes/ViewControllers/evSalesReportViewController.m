//
//  evSalesReportViewController.m
//  Vision
//
//  Created by Ian Molesworth on 22/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "evSalesReportViewController.h"

#import "User.h"
#import "Customer.h"
#import "Practice.h"
#import "umfundiAppDelegate.h"
#import "umfundiViewController.h"
#import "SalesTrendsReportDataSource.h"
#import "SalesTrendAggrPerBrand.h"

#define FilterTypePractice          0
#define FilterTypeCustomer          1
#define FilterTypeCountry           2
#define FilterTypeKeyAccountManager 3
#define FilterTypeGroup             4
#define FilterTypeCounty            5

@interface evSalesReportViewController ()

@end

@implementation evSalesReportViewController

@synthesize selectedPractice;
@synthesize selectedUser;
@synthesize selectedCustomer;
@synthesize selectedFilterVal;

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
    yearReportGrid.frame = CGRectMake(9, 280 + (self.view.bounds.size.height-320) / 2,
                                     self.view.bounds.size.width - 20, (self.view.bounds.size.height-324) / 2);
    
    // We are using templated views. This segment loads the artefacts from the relative templates using
    // their tags as references and the visual layouts for positioning
    UIViewController *templateController = [self.storyboard instantiateViewControllerWithIdentifier:isPortrait ? @"SalesReportPortraitView" : @"SalesReportLandscapeView"];
    if (templateController)
    {
//        int count = 0;
        for (UIView *eachView in SalesReportSubviews(templateController.view))
        {
//            NSLog(@"Tag %d %@ %d", count++, eachView.accessibilityLabel  , eachView.tag);
            
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
        style.size = [NSNumber numberWithFloat:160];
        return style;
    } else if (colIndex < 13) {
        style.size = [NSNumber numberWithFloat:60];
        return style;
    }
    
    return nil;
}


- (SGridColRowStyle *)shinobiGrid:(ShinobiGrid *)grid styleForRowAtIndex:(int)rowIndex inSection:(int)secIndex{
    SGridColRowStyle *style = [[SGridColRowStyle alloc] init];
    
    //Set Height of rows
    if(rowIndex == 0)
        {
        style.size = [NSNumber numberWithFloat:25];
        return style;
        }
    else
        {
        style.size = [NSNumber numberWithFloat:18];
        return style;
        }
    
    return nil;
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
    
    // The datasource for the Monthly data grid
    monthReportDataSource = [[SalesTrendsReportDataSource alloc] init];
    monthReportDataSource.figureTitle = NSLocalizedString(@"Month. Figures", @"");

    // The datasource for the MAT data grid
    yearReportDataSource = [[SalesTrendsReportDataSource alloc] init];
    
    NSString *licencekey = @"qgi64t6X5laUi6GMjAxMjExMTNpbmZvQHNoaW5vYmljb250cm9scy5jb20=UQ5WGyladC7SlbiYUt2BGUgxvt5ympt45rNMEzT1QST5KGlUA/v4WpV2NKh6yvMzqNQ/DmXZ0Uqya51NUqOn1m9u53sQpdOXKeJnkm127zUN6nOWKgY6wTEsh6vc71uYwcaVuB5lErG9+qDD9BZZdVQJ4Q7s=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+";
    
    //Create the grids
    monthReportGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];
    yearReportGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];
    
    monthReportGrid.licenseKey = licencekey;
    yearReportGrid.licenseKey = licencekey;
    
    monthReportGrid.dataSource = monthReportDataSource;
    monthReportGrid.delegate = self;

    yearReportGrid.dataSource = yearReportDataSource;
    yearReportGrid.delegate = self;
    

    //Freeze our top and left most rows
    [monthReportGrid freezeRowsAboveAndIncludingRow:SGridRowMake(0, 0)];
    [yearReportGrid freezeRowsAboveAndIncludingRow:SGridRowMake(0, 0)];
    
    //Some basic grid styling
    monthReportGrid.backgroundColor = [UIColor whiteColor];
    monthReportGrid.rowStylesTakePriority = YES;
    monthReportGrid.defaultGridLineStyle.width = 1.0f;
    monthReportGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    monthReportGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    monthReportGrid.defaultBorderStyle.width = 1.0f;
    yearReportGrid.backgroundColor = [UIColor whiteColor];
    yearReportGrid.rowStylesTakePriority = YES;
    yearReportGrid.defaultGridLineStyle.width = 1.0f;
    yearReportGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    yearReportGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    yearReportGrid.defaultBorderStyle.width = 1.0f;
    
    //provide default row heights and col widths
    monthReportGrid.defaultRowStyle.size = [NSNumber numberWithFloat:18];
    monthReportGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:100];
    yearReportGrid.defaultRowStyle.size = [NSNumber numberWithFloat:18];
    yearReportGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:100];
    
    //ensure that section header is hidden (a grid has one section by default)
    monthReportGrid.defaultSectionHeaderStyle.hidden = YES;
    monthReportGrid.defaultSectionHeaderStyle.hidden = YES;
    yearReportGrid.defaultSectionHeaderStyle.hidden = YES;
    yearReportGrid.defaultSectionHeaderStyle.hidden = YES;
    
    //We dont want to be able to edit our cells
    monthReportGrid.canEditCellsViaDoubleTap = NO;
    yearReportGrid.canEditCellsViaDoubleTap = NO;
    
    //Enable dragging - we want to be able to reorder in any direction
    monthReportGrid.canReorderColsViaLongPress = YES;
    monthReportGrid.canReorderRowsViaLongPress = YES;
    yearReportGrid.canReorderColsViaLongPress = YES;
    yearReportGrid.canReorderRowsViaLongPress = YES;
    
    currentFilter = FilterTypePractice;
    [self displayHeaderinfoblock];
    [self displayGrids];
    
    // this displays the grid
    [self.view addSubview:monthReportGrid];
    [self.view addSubview:yearReportGrid];
}

-(void) viewWillAppear:(BOOL)animated{
    [self didRotateFromInterfaceOrientation:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    lblPracticeHdr = nil;
    lblAccountHdr = nil;
    lblAccmgrHdr = nil;
    lblCountryHdr = nil;
    lblCountyHdr = nil;
    lblBGroupHdr = nil;
    lblThemeBox = nil;
    findText = nil;
    btnMAT = nil;
    btmYTD = nil;
    btnCustomer = nil;
    btnKAM = nil;
    btnBGroup = nil;
    btnPractice = nil;
    btnCounty = nil;
    btnCountry = nil;
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


- (IBAction)ytdClicked:(id)sender
{
    isYTD = YES;
    
    [self displayGrids];
}

- (IBAction)matClicked:(id)sender
{
    isYTD = NO;
    
    [self displayGrids];
    
    lblIDUser.text = selectedUser.login;    
}

- (IBAction)findClicked:(id)sender
{
    [findText resignFirstResponder];
    if ([findText.text length] == 0)
        return;
    
    posInMonth = YES;
    last_col = -1;
    last_row = 0;
    temp_cell = -1;

    [self nextClicked:sender];
}

- (IBAction)nextClicked:(id)sender
{
    [findText resignFirstResponder];
    if ([findText.text length] == 0)
        return;
 
    NSInteger month_col_count = monthReportGrid.numberOfColumns;
    NSInteger month_row_count = [monthReportGrid numberOfRowsForSection:0];
    NSInteger year_col_count = yearReportGrid.numberOfColumns;
    NSInteger year_row_count = [yearReportGrid numberOfRowsForSection:0];
    
    NSInteger total_cell_count = month_col_count * month_row_count + year_col_count * year_row_count;
    NSInteger last_cell = posInMonth ? (last_row * month_col_count + last_col) : (month_col_count * month_row_count + last_row * year_col_count + last_col);
    
    for (NSInteger cell = (temp_cell == -1) ? (last_cell + 1) : temp_cell; cell < last_cell + 1 + total_cell_count ; cell ++ )
    {
        NSInteger cell_in_grid = cell % total_cell_count;
        
        ShinobiGrid *grid;
        SalesTrendsReportDataSource *datasource;
        NSInteger col;
        NSInteger row;
        
        if (cell_in_grid < month_col_count * month_row_count)
        {
            // Month Grid
            col = cell_in_grid % month_col_count;
            row = cell_in_grid / month_col_count;
            
            grid = monthReportGrid;
            datasource = monthReportDataSource;
        }
        else
        {
            // Year Grid
            cell_in_grid -= month_col_count * month_row_count;
            
            col = cell_in_grid % year_col_count;
            row = cell_in_grid / year_col_count;
            
            grid = yearReportGrid;
            datasource = yearReportDataSource;
        }
        
        CGRect cell_rect = CGRectMake(1, 1, 0, 0);
        for (NSInteger i = 0 ; i < col ; i ++ )
        {
            SGridColRowStyle *style = [self shinobiGrid:grid styleForColAtIndex:i];
            if (style)
                cell_rect.origin.x += [style.size doubleValue] + 1;
            else
                cell_rect.origin.x += [grid.defaultColumnStyle.size doubleValue] + 1;
        }
        
        SGridColRowStyle *col_style = [self shinobiGrid:grid styleForColAtIndex:col];
        if (col_style)
            cell_rect.size.width = [col_style.size doubleValue] + 1;
        else
            cell_rect.size.width = [grid.defaultColumnStyle.size doubleValue] + 1;
        
        for (NSInteger j = 0 ; j < row ; j ++ )
        {
            SGridColRowStyle *style = [self shinobiGrid:grid styleForRowAtIndex:j inSection:0];
            if (style)
                cell_rect.origin.y += [style.size doubleValue];
            else
                cell_rect.origin.y += [grid.defaultRowStyle.size doubleValue] + 1;
        }
        
        SGridColRowStyle *row_style = [self shinobiGrid:grid styleForRowAtIndex:row inSection:0];
        if (row_style)
            cell_rect.size.height = [row_style.size doubleValue];
        else
            cell_rect.size.height = [grid.defaultRowStyle.size doubleValue] + 1;
        
        NSString *text = [datasource shinobiGrid:grid textForGridCoord:[[SGridCoord alloc] initWithColumn:col withRow:SGridRowMake(row, 0)]];
        if ([text rangeOfString:findText.text].location != NSNotFound)
        {
            if (grid == monthReportGrid)
                [yearReportGrid reload];
            else
                [monthReportGrid reload];
            
            [grid scrollRectToVisible:cell_rect animated:NO];
            [self performSelector:@selector(cellFound) withObject:nil afterDelay:0.1];
            
            last_col = col;
            last_row = row;
            posInMonth = (grid == monthReportGrid);
            temp_cell = -1;
            
            return;
        }
    }
}

- (void)cellFound
{
    SGridCell *grid_cell;
    if (posInMonth)
        grid_cell = [monthReportGrid visibleCellAtCol:last_col andRow:SGridRowMake(last_row, 0)];
    else
        grid_cell = [yearReportGrid visibleCellAtCol:last_col andRow:SGridRowMake(last_row, 0)];
    [grid_cell setSelected:YES animated:YES];
}


#pragma mark -
#pragma mark Filter Delegates

- (void)countrySelected:(NSString *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;
    self.selectedFilterVal = selected;
   
    currentFilter = FilterTypeCountry;
    [self displayHeaderinfoblock];
    [self displayGrids];
}

- (void)countySelected:(NSString *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;   
    self.selectedFilterVal = selected;
    
    currentFilter = FilterTypeCounty;
    [self displayHeaderinfoblock];
    [self displayGrids];
}

- (void)customerSelected:(Customer *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;
    self.selectedCustomer = selected;
    
    currentFilter = FilterTypeCustomer;
    [self displayHeaderinfoblock];
    [self displayGrids];
}

- (void)groupSelected:(NSString *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;
    self.selectedFilterVal = selected;
    
    currentFilter = FilterTypeGroup;
    [self displayHeaderinfoblock];    
    [self displayGrids];
}

- (void)keyAccountManagerSelected:(User *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;
    self.selectedUser = selectedUser;
  
    currentFilter = FilterTypeKeyAccountManager;
    [self displayHeaderinfoblock];    
    [self displayGrids];
}

- (void)practiceSelected:(Practice *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;
    self.selectedPractice = selected;
   
    currentFilter = FilterTypePractice;
    [self displayHeaderinfoblock];
    [self displayGrids];
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
            
        lblIDUser.text = selectedUser.login;
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
            
        lblIDUser.text = selectedUser.login;            
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

- (void)displayGrids
{
    if (currentFilter == FilterTypePractice)
    {
        monthReportDataSource.reportArray = [SalesTrendAggrPerBrand SalesTrendsGroupByBrandFrom:@"id_practice" andValue:selectedPractice.practiceCode YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeCustomer)
    {
        monthReportDataSource.reportArray = [SalesTrendAggrPerBrand SalesTrendsGroupByBrandFrom:@"id_customer" andValue:selectedCustomer.id_customer YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeGroup)
    {
        monthReportDataSource.reportArray = [SalesTrendAggrPerBrand SalesTrendsGroupByBrandFrom:@"groupName" andValue:selectedFilterVal YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeKeyAccountManager)
    {
        monthReportDataSource.reportArray = [SalesTrendAggrPerBrand SalesTrendsGroupByBrandFrom:@"id_user" andValue:selectedUser.id_user YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeCountry)
    {
        monthReportDataSource.reportArray = [SalesTrendAggrPerBrand SalesTrendsGroupByBrandFromCustomers:@"country" andValue:selectedFilterVal YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeCounty)
    {
        monthReportDataSource.reportArray = [SalesTrendAggrPerBrand SalesTrendsGroupByBrandFromCustomers:@"province" andValue:selectedFilterVal YTDorMAT:isYTD];
    }
    
    [monthReportGrid reload];

    yearReportDataSource.reportArray = [SalesTrendAggrPerBrand yearReportsFrom:monthReportDataSource.reportArray];
    yearReportDataSource.figureTitle = NSLocalizedString(isYTD ? @"YTD. Figures" : @"MAT. Figures", @"");
    [yearReportGrid reload];
    
    posInMonth = YES;
    last_col = -1;
    last_row = 0;
    temp_cell = -1;
}

@end
