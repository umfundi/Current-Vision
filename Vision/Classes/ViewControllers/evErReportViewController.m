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
#import "umfundiCommon.h"

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
@synthesize selectedUser;
@synthesize selectedCustomer;
@synthesize selectedFilterVal;

#pragma mark -SGridDelegate

- (SGridSectionHeaderStyle *)shinobiGrid:(ShinobiGrid *)grid styleForSectionHeaderAtIndex:(int) sectionIndex
{
    if (![grid.dataSource shinobiGrid:grid titleForHeaderInSection:sectionIndex])
        return nil;
    
    SGridSectionHeaderStyle *s = [[SGridSectionHeaderStyle alloc] initWithHeight:15.f withBackgroundColor:[UIColor lightGrayColor]];
    s.font = [UIFont fontWithName:@"Arial" size:10.0f];
    return s;
}

- (SGridColRowStyle *)shinobiGrid:(ShinobiGrid *)grid styleForRowAtIndex:(int)rowIndex inSection:(int)secIndex
{
    return nil;
}

- (SGridColRowStyle *)shinobiGrid:(ShinobiGrid *)grid styleForColAtIndex:(int)colIndex
{
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
    
    erReportDataSource = [[ErReportDataSource alloc] init];

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
    [self displayGrids];
    
    
    // this displays the grid
    [self.view addSubview:erReportGrid];
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
    
    if (isPortrait)
        erReportGrid.frame = CGRectMake(9, 295, self.view.bounds.size.width-20, self.view.bounds.size.height-300);
    else
        erReportGrid.frame = CGRectMake(9, 270, self.view.bounds.size.width-20, self.view.bounds.size.height-300);
    
        
    UIViewController *templateController = [self.storyboard instantiateViewControllerWithIdentifier:isPortrait ? @"ErReportPortraitView" : @"ErReportLandscapeView"];
    if (templateController)
    {
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
    
    NSInteger col_count = erReportGrid.numberOfColumns;
    NSInteger section_count = erReportGrid.numberOfSections;
    NSInteger row_count = 0;
    for (NSInteger section = 0 ; section < section_count ; section ++ )
        row_count += [erReportGrid numberOfRowsForSection:section];
    
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
            SGridColRowStyle *style = [self shinobiGrid:erReportGrid styleForColAtIndex:i];
            if (style)
                cell_rect.origin.x += [style.size doubleValue] + 1;
            else
                cell_rect.origin.x += [erReportGrid.defaultColumnStyle.size doubleValue] + 1;
        }
        
        SGridColRowStyle *col_style = [self shinobiGrid:erReportGrid styleForColAtIndex:col];
        if (col_style)
            cell_rect.size.width = [col_style.size doubleValue] + 1;
        else
            cell_rect.size.width = [erReportGrid.defaultColumnStyle.size doubleValue] + 1;
        
        
        BOOL broken;
        NSInteger j = 0;
        for (NSInteger section = 0 ; section < section_count ; section ++ )
        {
            broken = NO;
            NSInteger rows = [erReportGrid numberOfRowsForSection:section];
            for (NSInteger row_no = 0 ; row_no < rows ; row_no ++ )
            {
                SGridColRowStyle *style = [self shinobiGrid:erReportGrid styleForRowAtIndex:row_no inSection:section];
                double height;
                if (style)
                    height = [style.size doubleValue];
                else
                    height = [erReportGrid.defaultRowStyle.size doubleValue] + 1;
                
                if (j < row)
                    cell_rect.origin.y += height;
                else if (j == row)
                {
                    cell_rect.size.height = height;
                    
                    NSString *text = [erReportDataSource shinobiGrid:erReportGrid textForGridCoord:[[SGridCoord alloc] initWithColumn:col withRow:SGridRowMake(row_no, section)]];
                    if (text && [text rangeOfString:findText.text].location != NSNotFound)
                    {
                        [erReportGrid scrollRectToVisible:cell_rect animated:NO];
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

- (void)cellFound
{
    NSInteger row_no = last_row;
    NSInteger section_count = erReportGrid.numberOfSections;
    for (NSInteger section = 0 ; section < section_count ; section ++ )
    {
        NSInteger rows = [erReportGrid numberOfRowsForSection:section];
        if (row_no < rows)
        {
            SGridCell *grid_cell = [erReportGrid visibleCellAtCol:last_col andRow:SGridRowMake(row_no, section)];
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


- (IBAction)fullClicked:(id)sender {
}

- (IBAction)btnPractice:(id)sender {
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
    if (currentFilter == FilterTypePractice)
    {
        erReportDataSource.erReportArray = [ErReportAggrPerBrand ErReportGroupByBrandFrom:@"id_practice" andValue:selectedPractice.practiceCode YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeCustomer)
    {
        erReportDataSource.erReportArray = [ErReportAggrPerBrand ErReportGroupByBrandFrom:@"id_customer" andValue:selectedCustomer.id_customer YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeGroup)
    {
        erReportDataSource.erReportArray = [ErReportAggrPerBrand ErReportGroupByBrandFrom:@"groupName" andValue:selectedFilterVal YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeKeyAccountManager)
    {
        erReportDataSource.erReportArray = [ErReportAggrPerBrand ErReportGroupByBrandFrom:@"id_user" andValue:selectedUser.id_user YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeCountry)
    {
        erReportDataSource.erReportArray = [ErReportAggrPerBrand ErReportGroupByBrandFrom:@"country" andValue:selectedFilterVal YTDorMAT:isYTD];
    }
    else if (currentFilter == FilterTypeCounty)
    {
        erReportDataSource.erReportArray = [ErReportAggrPerBrand ErReportGroupByBrandFrom:@"province" andValue:selectedFilterVal YTDorMAT:isYTD];
    }
    
    [erReportGrid reload];

    last_col = -1;
    last_row = 0;
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
    [umfundiCommon applyColorToButton:btnYTD withColor:titleColor];
    [umfundiCommon applyColorToButton:btnFull withColor:titleColor];
    
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

@end
