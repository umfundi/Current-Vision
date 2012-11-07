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
#import "PracticeAggr.h"

#import "PracticeSearchResultViewController.h"
//#import "
#import "umfundiCommon.h"
#import "SitesDataSource.h"
#import "SalesDataSource.h"
#import "umfundiAppDelegate.h"


@interface umfundiViewController ()

@end

@implementation umfundiViewController

//@synthesize currentCustomer;
@synthesize currentPractice;

#pragma mark Grid Delegate methods
// Column and Row Styling
- (SGridColRowStyle *)shinobiGrid:(ShinobiGrid *)grid styleForRowAtIndex:(int)rowIndex inSection:(int) sectionIndex
{
    SGridColRowStyle *style = [[SGridColRowStyle alloc] init];
    if (grid == sitesGrid )
        {
        //Set the size and text colour of the first row
        if (rowIndex == 0)
            {
            style.size = [NSNumber numberWithInt:30];
            }
        else
            {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                style.size = [NSNumber numberWithInt:25];
                }
            else
                {
                style.size = [NSNumber numberWithInt:26];
                }
            }
        }
    else
    {
        if (sectionIndex ==0 && rowIndex == 0)
            {
            style.size = [NSNumber numberWithInt:30];
        }
        else        {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
            style.size = [NSNumber numberWithInt:18];
            }
        else
            {
            style.size = [NSNumber numberWithInt:16];
            }
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
            style.size = [NSNumber numberWithFloat:175];
            return style;
        } else if (colIndex == 2) {
            style.size = [NSNumber numberWithFloat:100];
            return style;
        } else if (colIndex == 3) {
            style.size = [NSNumber numberWithFloat:80];
            return style;
        } else {
            style.size = [NSNumber numberWithFloat:65];
            return style;
        }

    }
    if (grid == salesGrid )
    {
        //Set fixed width for certain columns
        if(colIndex == 0) {
            style.size = [NSNumber numberWithFloat:50];
            return style;
        } else if(colIndex == 1) {
            style.size = [NSNumber numberWithFloat:80];
            return style;
        } else if (colIndex == 2) {
            style.size = [NSNumber numberWithFloat:80];
            return style;
        } else if (colIndex == 4) {
            style.size = [NSNumber numberWithFloat:50];
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

    HUDDownload = [[MBProgressHUD alloc] initWithView:self.view];
    HUDDownload.labelText = @"Downloading Territory Data";
    [self.view addSubview:HUDDownload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self didRotateFromInterfaceOrientation:0];
    
//    [self displayCustomer];    
    [self displayPractice];
    [self applyTheme:[[User loginUser].data isEqualToString:@"companion"]];
    

    NSInteger month = [[User loginUser] monthForData];
    NSInteger day = [[User loginUser] dayForData];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSMonthCalendarUnit | NSDayCalendarUnit
                                                fromDate:[NSDate date]];
    NSInteger curmonth = [components month];
    NSInteger curday = [components day];
    
    NSInteger month_diff = (curmonth - month + 12) % 12;
    if (month_diff > 1 || (month_diff == 1 && curday > day))
    {
        // Need to update.
        syncButton.enabled = YES;
    }
    else
        syncButton.enabled = NO;
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

    [HUDDownload show:YES];
    
    downloadPath = [User sqliteFilepathForData];
    conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[User sqliteDownloadURLForData]]] delegate:self startImmediately:YES];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%d Bytes Downloaded", [data length]);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[downloadPath stringByAppendingString:@".tmp"]])
        [[NSFileManager defaultManager] createFileAtPath:[downloadPath stringByAppendingString:@".tmp"] contents:data attributes:nil];
    else
    {
        NSFileHandle *file = [NSFileHandle fileHandleForWritingAtPath:[downloadPath stringByAppendingString:@".tmp"]];
        
        [file seekToFileOffset:[file seekToEndOfFile]];
        [file writeData:data];
        
        [file closeFile];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [HUDDownload hide:YES];
    HUDDownload = nil;
    
    [[NSFileManager defaultManager] removeItemAtPath:downloadPath error:nil];
    [[NSFileManager defaultManager] moveItemAtPath:[downloadPath stringByAppendingString:@".tmp"] toPath:downloadPath error:nil];

    self.currentPractice = nil;
    
    [self viewWillAppear:NO];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[NSFileManager defaultManager] removeItemAtPath:[downloadPath stringByAppendingString:@".tmp"] error:nil];
    
    [HUDDownload hide:YES];
    HUDDownload = nil;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"")
                                                        message:NSLocalizedString(@"Failed to connect to server. Please try again.", @"")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
    [alertView show];
}

//- (void)displayCustomer
//{
//    if (!currentCustomer)
//    {
//        self.currentCustomer = [Customer firstCustomer];
//        if (!currentCustomer)
//            return;
//        
//        [currentCustomer loadPracticeAndValues];
//    }
//    
//    // Practice code into field 1 
// //   accountNoField.text = currentCustomer.id_customer;
//    accountNoField.text = currentPractice.practiceCode;
//    nameField.text = currentCustomer.customerName;
//    addressField.text = currentCustomer.address1;
//    townField.text = currentCustomer.city;
//    countryField.text = currentCustomer.province;
//    postcodeField.text = currentCustomer.postcode;
//    brickField.text = currentCustomer.brick;
//    SAPCodeField.text = currentCustomer.sap_no;
//    MonthField.text = currentCustomer.aggrValue.monthString;
//    YTDField.text = currentCustomer.aggrValue.ytdString;
//    MATField.text = currentCustomer.aggrValue.matString;
//    
//    if (currentCustomer.practice)
//    {
//        practiceField.text = currentCustomer.practice.practiceName;
//        
//        NSLog(@"practiceCode = %@", currentCustomer.practice.practiceCode);
//        [currentCustomer.practice loadCustomers];
//        for (Customer *customer in currentCustomer.practice.customers)
//            [customer loadPracticeAndValues];
//        
//        sitesDataSource.sitesArray = [currentCustomer.practice.customers allObjects];
//        [sitesGrid reload];
//        
//        salesDataSource.salesArray = currentCustomer.aggrValue.aggrPerBrands;
//        [salesGrid reload];
//    }
//    else
//    {
//        practiceField.text = @"-";
//        
//        sitesDataSource.sitesArray = nil;
//        [sitesGrid reload];
//        
//        salesDataSource.salesArray = nil;
//        [salesGrid reload];
//    }
//}

- (void)displayPractice
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    if (!self.currentPractice)
    {
        if (!HUDProcessing)
        {
            HUDProcessing = [[MBProgressHUD alloc] initWithView:self.view];
            HUDProcessing.labelText = @"Processing tables ...";
            [self.view addSubview:HUDProcessing];
        }
        
        [HUDProcessing show:YES];
        
        [NSThread detachNewThreadSelector:@selector(loadValuesThread) toTarget:self withObject:nil];
        
        return;
    }
    
    accountNoField.text = currentPractice.practiceCode;
    nameField.text = currentPractice.practiceName;
    addressField.text = currentPractice.add1;
    townField.text = currentPractice.city;
    countryField.text = currentPractice.country;
    postcodeField.text = currentPractice.postcode;
    brickField.text = currentPractice.brick;
    SAPCodeField.text = currentPractice.sap_no;
 
    MonthField.text = [formatter stringFromNumber:[NSNumber numberWithInteger:currentPractice.aggrValue.month]];    
//    MonthField.text = currentPractice.aggrValue.monthString;
    YTDField.text = [formatter stringFromNumber:[NSNumber numberWithInteger:currentPractice.aggrValue.ytd]];
//    YTDField.text = currentPractice.aggrValue.ytdString;
    MATField.text = [formatter stringFromNumber:[NSNumber numberWithInteger:currentPractice.aggrValue.mat]];
//    MATField.text = currentPractice.aggrValue.matString;
    
    if (currentPractice)
    {
        practiceField.text = currentPractice.practiceName;
        
        sitesDataSource.sitesArray = [currentPractice.customers allObjects];
        [sitesGrid reload];
        
        salesDataSource.salesArray = currentPractice.aggrValue.aggrPerBrands;
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
            keyField = @"practiceCode";
            break;
        case 211:
            keyField = @"practiceName";
            break;
        case 212:
            keyField = @"city";
            break;
        case 213:
            keyField = @"postcode";
            break;
        default:
            return;
    }
    
    NSString *searchKey = searchField.text;
    
    // Fetch Practices
    NSArray *practices = [Practice searchPracticesWithField:keyField andKey:searchKey];
    searchResults = [practices mutableCopy];
    
/*
    // Fetch Customers from Practices
    NSMutableArray *resultCustomers = [[NSMutableArray alloc] initWithCapacity:0];
    for (Practice *practice in practices)
        {
        [practice loadCustomers];
        [resultCustomers addObjectsFromArray:[practice.customers allObjects]];
        }
    
    searchResults = resultCustomers;
*/
    
    
    [self performSelectorOnMainThread:@selector(searchFinished:) withObject:sender waitUntilDone:YES];
}

- (void)searchFinished:(id)sender
{
    [HUDSearch hide:YES];
    
    PracticeSearchResultViewController *resultViewController = [[PracticeSearchResultViewController alloc] init];
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

//- (void)customerSelected:(Customer *)selected
//{
//    [searchPopoverController dismissPopoverAnimated:YES];
//    searchPopoverController = nil;
//    
//    self.currentCustomer = selected;
//    [currentCustomer loadPracticeAndValues];
//    
//    [self displayCustomer];
//}

- (void)practiceSelected:(Practice *)selected
{
    [searchPopoverController dismissPopoverAnimated:YES];
    searchPopoverController = nil;
    
    if (!HUDProcessing)
    {
        HUDProcessing = [[MBProgressHUD alloc] initWithView:self.view];
        HUDProcessing.labelText = @"Processing tables ...";
        [self.view addSubview:HUDProcessing];
    }
    
    [HUDProcessing show:YES];
    
    self.currentPractice = selected;
    [NSThread detachNewThreadSelector:@selector(loadValuesThread) toTarget:self withObject:nil];
    
    [self displayPractice];
}


- (void)loadValuesThread
{
    @autoreleasepool
    {
        if (!self.currentPractice)
            self.currentPractice = [Practice firstPractice];
        
        [currentPractice loadCustomers];
        for (Customer *customer in currentPractice.customers)
            [customer loadPracticeAndValues];
        
        [currentPractice loadAggrValues];
        
        [self performSelectorOnMainThread:@selector(displayPractice) withObject:nil waitUntilDone:YES];
        
        [HUDProcessing hide:YES];
    }
}

@end