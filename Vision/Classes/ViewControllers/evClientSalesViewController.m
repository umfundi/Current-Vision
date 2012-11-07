//
//  evClientSalesViewController.m
//  Vision
//
//  Created by Ian Molesworth on 23/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "evClientSalesViewController.h"

#import "ClientSalesDataSource.h"
#import "ClientSalesAggr.h"
#import "BrandListDataSource.h"
#import "Focused_brand.h"
#import "User.h"
#import "umfundiCommon.h"
#import "ClientSalesAggrPerGroup.h"

#define FilterTypePractice          0
#define FilterTypeCustomer          1
#define FilterTypeCountry           2
#define FilterTypeKeyAccountManager 3
#define FilterTypeGroup             4
#define FilterTypeCounty            5

@interface evClientSalesViewController ()

@end

@implementation evClientSalesViewController

#pragma mark -
#pragma mark SGridDelegate

- (void) shinobiGrid:(ShinobiGrid *)grid didSelectCellAtCoord: (const SGridCoord *) gridCoord
{
    if (grid == brandListGrid)
    {
        NSNumber *selected = [brandListDataSource.itemSelected objectAtIndex:gridCoord.rowIndex];
        [brandListDataSource.itemSelected replaceObjectAtIndex:gridCoord.rowIndex withObject:[NSNumber numberWithBool:!selected.boolValue]];
        
        [brandListGrid reload];
    }
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
    
    clientSalesDataSource = [[ClientSalesDataSource alloc] init];
    clientSalesDataSource.clientSalesAggr = nil;
    clientSalesDataSource.delegate = self;
    brandListDataSource = [[BrandListDataSource alloc] init];
    brandListDataSource.brandArray = [Focused_brand AllBrands];
    brandListDataSource.itemSelected = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0 ; i < brandListDataSource.brandArray.count ; i ++ )
        [brandListDataSource.itemSelected addObject:[NSNumber numberWithBool:NO]];
    
    NSString *licencekey = @"qgi64t6X5laUi6GMjAxMjExMTNpbmZvQHNoaW5vYmljb250cm9scy5jb20=UQ5WGyladC7SlbiYUt2BGUgxvt5ympt45rNMEzT1QST5KGlUA/v4WpV2NKh6yvMzqNQ/DmXZ0Uqya51NUqOn1m9u53sQpdOXKeJnkm127zUN6nOWKgY6wTEsh6vc71uYwcaVuB5lErG9+qDD9BZZdVQJ4Q7s=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+";
    
    //Create the grid
    clientSalesGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];
    brandListGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];
    
    clientSalesGrid.licenseKey = licencekey;
    brandListGrid.licenseKey = licencekey;
    
    clientSalesGrid.dataSource = clientSalesDataSource;
    clientSalesGrid.delegate = self;
    brandListGrid.dataSource = brandListDataSource;
    brandListGrid.delegate = self;
    
    //Freeze our top and left most rows
    [clientSalesGrid freezeRowsAboveAndIncludingRow:SGridRowMake(0, 0)];
    
    //Some basic grid styling
    clientSalesGrid.backgroundColor = [UIColor whiteColor];
    clientSalesGrid.rowStylesTakePriority = YES;
    clientSalesGrid.defaultGridLineStyle.width = 1.0f;
    clientSalesGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    clientSalesGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    clientSalesGrid.defaultBorderStyle.width = 1.0f;
    brandListGrid.backgroundColor = [UIColor whiteColor];
    brandListGrid.rowStylesTakePriority = YES;
    brandListGrid.defaultGridLineStyle.width = 1.0f;
    brandListGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    brandListGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    brandListGrid.defaultBorderStyle.width = 1.0f;

    //provide default row heights and col widths
    clientSalesGrid.defaultRowStyle.size = [NSNumber numberWithFloat:30];
    clientSalesGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:100];
    brandListGrid.defaultRowStyle.size = [NSNumber numberWithFloat:30];
    brandListGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:400];
    
    //ensure that section header is hidden (a grid has one section by default)
    clientSalesGrid.defaultSectionHeaderStyle.hidden = YES;
    brandListGrid.defaultSectionHeaderStyle.hidden = YES;
    
    //We dont want to be able to edit our cells
    clientSalesGrid.canEditCellsViaDoubleTap = NO;
    brandListGrid.canEditCellsViaDoubleTap = NO;
    
    //Enable dragging - we want to be able to reorder in any direction
    clientSalesGrid.canReorderColsViaLongPress = YES;
    clientSalesGrid.canReorderRowsViaLongPress = YES;
    brandListGrid.canReorderColsViaLongPress = YES;
    brandListGrid.canReorderRowsViaLongPress = YES;

    btnAll.hidden = YES;

    isYTD = YES;
    
    // this displays the grid
    [self.view addSubview:clientSalesGrid];
    [self.view addSubview:brandListGrid];

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
    
    clientSalesGrid.frame = CGRectMake(9, 350, self.view.bounds.size.width-20, self.view.bounds.size.height-390);
    brandListGrid.frame = CGRectMake(9, 165, self.view.bounds.size.width-130, 170);

    UIViewController *templateController = [self.storyboard instantiateViewControllerWithIdentifier:isPortrait ? @"ClientSalesPortraitView" : @"ClientSalesLandscapeView"];
    if (templateController)
    {
        for (UIView *eachView in ClientSalesSubviews(templateController.view))
        {
//            NSLog(@"Tag %d %@ %d", count++, eachView.accessibilityLabel  , eachView.tag);
            
            int tag = eachView.tag;
            if(tag < 10 ) continue;
            [self.view viewWithTag:tag].frame = eachView.frame;
        }
    }
}

NSArray *ClientSalesSubviews(UIView *aView)
{
    NSArray *results = [aView subviews];
    for (UIView *eachView in [aView subviews])
    {
        NSArray *theSubviews = ClientSalesSubviews(eachView);
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


- (IBAction)doneClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)clearButtonClicked:(id)sender
{
    brandListDataSource.itemSelected = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0 ; i < brandListDataSource.brandArray.count ; i ++ )
        [brandListDataSource.itemSelected addObject:[NSNumber numberWithBool:NO]];

    [brandListGrid reload];
}

- (IBAction)selectButtonClicked:(id)sender
{
    [self displayGrids];
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

- (IBAction)allClicked:(id)sender
{
    btnAll.hidden = YES;

    clientSalesDataSource.clientSalesAggr = clientSalesAggr;
    [clientSalesGrid reload];
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
        NSMutableArray *brands = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (NSInteger i = 0 ; i < brandListDataSource.brandArray.count ; i ++ )
        {
            NSNumber *selected = [brandListDataSource.itemSelected objectAtIndex:i];
            if ([selected boolValue])
                [brands addObject:[brandListDataSource.brandArray objectAtIndex:i]];
        }
        
        if ([brands count] == 0)
            clientSalesDataSource.clientSalesAggr = [ClientSalesAggr AggrWithYTDorMAT:isYTD];
        else
            clientSalesDataSource.clientSalesAggr = [ClientSalesAggr AggrByBrands:brands YTDorMAT:isYTD];

        [clientSalesGrid performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
        [HUDProcessing hide:YES];
    }
}

- (void)applyTheme:(BOOL)redTheme
{
    // About Button Background Image
    NSString *logo = redTheme ? @"Companion_HC.png" : @"Ruminant_HB.png";
    [imgLogo setImage:[UIImage imageNamed:logo]];
    
    // Buttons Title Color
    UIColor *titleColor = redTheme ? [UIColor colorWithRed:180.0 / 255 green:0 blue:0 alpha:1] :
    [UIColor colorWithRed:50.0 / 255 green:79.0 / 255 blue:133.0 / 255 alpha:1];
    
    [umfundiCommon applyColorToButton:btnMAT withColor:titleColor];
    [umfundiCommon applyColorToButton:btnYTD withColor:titleColor];
    
    [umfundiCommon applyColorToButton:btnDone withColor:titleColor];

    [umfundiCommon applyColorToButton:btnClear withColor:titleColor];
    [umfundiCommon applyColorToButton:btnSelect withColor:titleColor];
    [umfundiCommon applyColorToButton:btnSelFocus withColor:titleColor];
    [umfundiCommon applyColorToButton:btnAll withColor:titleColor];
}


#pragma mark -
#pragma mark ClientSalesDataSourceDelegate

- (void)groupSelected:(ClientSalesAggrPerGroup *)group
{
    ClientSalesAggr *aggr = [[ClientSalesAggr alloc] initWithYTDorMAT:isYTD];
    aggr.year = clientSalesDataSource.clientSalesAggr.year;
    aggr.lastyear = clientSalesDataSource.clientSalesAggr.lastyear;
    aggr.aggrPerGroups = group.aggrPerPractices;

    clientSalesAggr = clientSalesDataSource.clientSalesAggr;
    clientSalesDataSource.clientSalesAggr = aggr;
    
    btnAll.hidden = NO;

    [clientSalesGrid reload];
}

@end
