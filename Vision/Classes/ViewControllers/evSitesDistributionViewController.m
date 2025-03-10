//
//  evSitesDistributionViewController.m
//  Vision
//
//  Created by Ian Molesworth on 23/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "evSitesDistributionViewController.h"

#import "SitesDistributionDataSource.h"
#import "BrandListDataSource.h"
#import "ProductListDataSource.h"
#import "Focused_brand.h"
#import "Product.h"
#import "SitesDistributionAggr.h"
#import "User.h"
#import "umfundiCommon.h"
#import "evSitesDistributionSubViewController.h"

@interface evSitesDistributionViewController ()

@end

@implementation evSitesDistributionViewController

@synthesize selectedUser;

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
    else if (grid == productListGrid)
    {
        NSNumber *selected = [productListDataSource.itemSelected objectAtIndex:gridCoord.rowIndex];
        [productListDataSource.itemSelected replaceObjectAtIndex:gridCoord.rowIndex withObject:[NSNumber numberWithBool:!selected.boolValue]];
        
        [productListGrid reload];
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
    
    selectedPeriod = CurYear;
    
    brandListDataSource = [[BrandListDataSource alloc] init];
    brandListDataSource.brandArray = [Focused_brand AllBrands];
    brandListDataSource.itemSelected = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0 ; i < brandListDataSource.brandArray.count ; i ++ )
        [brandListDataSource.itemSelected addObject:[NSNumber numberWithBool:NO]];

    sitesDistByBrandDataSource = [[SitesDistributionDataSource alloc] init];
    sitesDistByBrandDataSource.delegate = self;
    
    productListDataSource = [[ProductListDataSource alloc] init];
    productListDataSource.productArray = [Product AllProducts];
    productListDataSource.itemSelected = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0 ; i < productListDataSource.productArray.count ; i ++ )
        [productListDataSource.itemSelected addObject:[NSNumber numberWithBool:NO]];

    sitesDistByProductDataSource = [[SitesDistributionDataSource alloc] init];
    sitesDistByProductDataSource.delegate = self;
    
    NSString *licencekey = @"qgi64t6X5laUi6GMjAxMjExMTNpbmZvQHNoaW5vYmljb250cm9scy5jb20=UQ5WGyladC7SlbiYUt2BGUgxvt5ympt45rNMEzT1QST5KGlUA/v4WpV2NKh6yvMzqNQ/DmXZ0Uqya51NUqOn1m9u53sQpdOXKeJnkm127zUN6nOWKgY6wTEsh6vc71uYwcaVuB5lErG9+qDD9BZZdVQJ4Q7s=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+";
    
    //Create the grid
    brandListGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];
    sitesDistByBrandGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];
    productListGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];
    sitesDistByProductGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];
    
    brandListGrid.licenseKey = licencekey;
    sitesDistByBrandGrid.licenseKey = licencekey;
    productListGrid.licenseKey = licencekey;
    sitesDistByProductGrid.licenseKey = licencekey;
    
    brandListGrid.dataSource = brandListDataSource;
    brandListGrid.delegate = self;
    sitesDistByBrandGrid.dataSource = sitesDistByBrandDataSource;
    sitesDistByBrandGrid.delegate = self;
    productListGrid.dataSource = productListDataSource;
    productListGrid.delegate = self;
    sitesDistByProductGrid.dataSource = sitesDistByProductDataSource;
    sitesDistByProductGrid.delegate = self;
    
    //Freeze our top and left most rows
    [sitesDistByBrandGrid freezeRowsAboveAndIncludingRow:SGridRowMake(0, 0)];
    [sitesDistByProductGrid freezeRowsAboveAndIncludingRow:SGridRowMake(0, 0)];
    
    //Some basic grid styling
    brandListGrid.backgroundColor = [UIColor whiteColor];
    brandListGrid.rowStylesTakePriority = YES;
    brandListGrid.defaultGridLineStyle.width = 1.0f;
    brandListGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    brandListGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    brandListGrid.defaultBorderStyle.width = 1.0f;
    sitesDistByBrandGrid.backgroundColor = [UIColor whiteColor];
    sitesDistByBrandGrid.rowStylesTakePriority = YES;
    sitesDistByBrandGrid.defaultGridLineStyle.width = 1.0f;
    sitesDistByBrandGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    sitesDistByBrandGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    sitesDistByBrandGrid.defaultBorderStyle.width = 1.0f;
    productListGrid.backgroundColor = [UIColor whiteColor];
    productListGrid.rowStylesTakePriority = YES;
    productListGrid.defaultGridLineStyle.width = 1.0f;
    productListGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    productListGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    productListGrid.defaultBorderStyle.width = 1.0f;
    sitesDistByProductGrid.backgroundColor = [UIColor whiteColor];
    sitesDistByProductGrid.rowStylesTakePriority = YES;
    sitesDistByProductGrid.defaultGridLineStyle.width = 1.0f;
    sitesDistByProductGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    sitesDistByProductGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    sitesDistByProductGrid.defaultBorderStyle.width = 1.0f;
    
    //provide default row heights and col widths
    brandListGrid.defaultRowStyle.size = [NSNumber numberWithFloat:30];
    brandListGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:400];
    sitesDistByBrandGrid.defaultRowStyle.size = [NSNumber numberWithFloat:30];
    sitesDistByBrandGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:100];
    productListGrid.defaultRowStyle.size = [NSNumber numberWithFloat:30];
    productListGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:400];
    sitesDistByProductGrid.defaultRowStyle.size = [NSNumber numberWithFloat:30];
    sitesDistByProductGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:100];
    
    //ensure that section header is hidden (a grid has one section by default)
    brandListGrid.defaultSectionHeaderStyle.hidden = YES;
    brandListGrid.defaultSectionHeaderStyle.hidden = YES;
    sitesDistByBrandGrid.defaultSectionHeaderStyle.hidden = YES;
    sitesDistByBrandGrid.defaultSectionHeaderStyle.hidden = YES;
    productListGrid.defaultSectionHeaderStyle.hidden = YES;
    productListGrid.defaultSectionHeaderStyle.hidden = YES;
    sitesDistByProductGrid.defaultSectionHeaderStyle.hidden = YES;
    sitesDistByProductGrid.defaultSectionHeaderStyle.hidden = YES;
    
    //We dont want to be able to edit our cells
    brandListGrid.canEditCellsViaDoubleTap = NO;
    sitesDistByBrandGrid.canEditCellsViaDoubleTap = NO;
    productListGrid.canEditCellsViaDoubleTap = NO;
    sitesDistByProductGrid.canEditCellsViaDoubleTap = NO;
    
    //Enable dragging - we want to be able to reorder in any direction
    brandListGrid.canReorderColsViaLongPress = YES;
    brandListGrid.canReorderRowsViaLongPress = YES;
    sitesDistByBrandGrid.canReorderColsViaLongPress = YES;
    sitesDistByBrandGrid.canReorderRowsViaLongPress = YES;
    productListGrid.canReorderColsViaLongPress = YES;
    productListGrid.canReorderRowsViaLongPress = YES;
    sitesDistByProductGrid.canReorderColsViaLongPress = YES;
    sitesDistByProductGrid.canReorderRowsViaLongPress = YES;
    
    // this displays the grid
    [self.view addSubview:brandListGrid];
    [self.view addSubview:sitesDistByBrandGrid];
    [self.view addSubview:productListGrid];
    [self.view addSubview:sitesDistByProductGrid];

    HUDProcessing = [[MBProgressHUD alloc] initWithView:self.view];
    HUDProcessing.labelText = @"Processing tables ...";
    [self.view addSubview:HUDProcessing];
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
    
    brandListGrid.frame = CGRectMake(100, 150,
                                     self.view.bounds.size.width - 130,
                                     (self.view.bounds.size.height - 484) / 2);
    sitesDistByBrandGrid.frame = CGRectMake(10, 155 + brandListGrid.frame.size.height,
                                            self.view.bounds.size.width - 30, 157);
    productListGrid.frame = CGRectMake(100,
                                       sitesDistByBrandGrid.frame.origin.y + sitesDistByBrandGrid.frame.size.height + 10,
                                       self.view.bounds.size.width - 130,
                                       (self.view.bounds.size.height - 484) / 2);
    sitesDistByProductGrid.frame = CGRectMake(10,
                                              productListGrid.frame.origin.y + productListGrid.frame.size.height + 5,
                                            self.view.bounds.size.width - 30, 157);

    UIViewController *templateController = [self.storyboard instantiateViewControllerWithIdentifier:isPortrait ? @"SitesDistributionPortraitView" : @"SitesDistributionLandscapeView"];
    if (templateController)
    {
        for (UIView *eachView in SitesDistributionSubviews(templateController.view))
        {
 //           NSLog(@"Tag %d %@ %d", count++, eachView.accessibilityLabel  , eachView.tag);
            
            int tag = eachView.tag;
            if(tag < 10 ) continue;
            [self.view viewWithTag:tag].frame = eachView.frame;
        }
    }
}


NSArray *SitesDistributionSubviews(UIView *aView)
{
    NSArray *results = [aView subviews];
    for (UIView *eachView in [aView subviews])
    {
        NSArray *theSubviews = SitesDistributionSubviews(eachView);
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


- (IBAction)prevYearClicked:(id)sender
{
    selectedPeriod = PrevYear;
    btnPrevYear.selected = YES;
    btnCurYear.selected = NO;
    btnYTD.selected = NO;
}

- (IBAction)curYearClicked:(id)sender
{
    selectedPeriod = CurYear;
    btnPrevYear.selected = NO;
    btnCurYear.selected = YES;
    btnYTD.selected = NO;
}

- (IBAction)YTDClicked:(id)sender
{
    selectedPeriod = YTD;
    btnPrevYear.selected = NO;
    btnCurYear.selected = NO;
    btnYTD.selected = YES;
}


- (IBAction)filterbyBrandClicked:(id)sender
{
    [HUDProcessing show:YES];
    
    [NSThread detachNewThreadSelector:@selector(filterByBrand) toTarget:self withObject:nil];
}

- (void)filterByBrand
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
        
        sitesDistByBrandDataSource.sitesDistributionAggr = [SitesDistributionAggr AggrFilteredByBrands:brands period:selectedPeriod];
        [sitesDistByBrandGrid performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
        
        [HUDProcessing hide:YES];
    }
}

- (IBAction)filterbyProductClicked:(id)sender
{
    [HUDProcessing show:YES];
    
    [NSThread detachNewThreadSelector:@selector(filterByProduct) toTarget:self withObject:nil];
}

- (void)filterByProduct
{
    @autoreleasepool
    {
        NSMutableArray *products = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (NSInteger i = 0 ; i < productListDataSource.productArray.count ; i ++ )
        {
            NSNumber *selected = [productListDataSource.itemSelected objectAtIndex:i];
            if ([selected boolValue])
                [products addObject:[productListDataSource.productArray objectAtIndex:i]];
        }
        
        sitesDistByProductDataSource.sitesDistributionAggr = [SitesDistributionAggr AggrFilteredByProducts:products period:selectedPeriod];
        [sitesDistByProductGrid performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
        
        [HUDProcessing hide:YES];
    }
}

- (void)viewDidUnload {
    imgLogo = nil;
    [super viewDidUnload];
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
    
    [umfundiCommon applyColorToButton:btnDone withColor:titleColor];
    [umfundiCommon applyColorToButton:btnEmail withColor:titleColor];
    [umfundiCommon applyColorToButton:btnCharts withColor:titleColor];

    [umfundiCommon applyColorToButton:btnFilterByBrands withColor:titleColor];
    [umfundiCommon applyColorToButton:btnFilterByProducts withColor:titleColor];

    [umfundiCommon applyColorToButton:btnCurYear withColor:titleColor];
    [umfundiCommon applyColorToButton:btnPrevYear withColor:titleColor];
    [umfundiCommon applyColorToButton:btnYTD withColor:titleColor];
}


#pragma mark -
#pragma mark SitesDistributionDataSourceDelegate

- (void)aggrItemSelected:(SitesDistributionAggrItem *)selected dataSource:(SitesDistributionDataSource *)dataSource
{
    evSitesDistributionSubViewController *subViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"evSitesDistributionSubViewController"];
    
    subViewController.aggrItem = selected;
    if (dataSource == sitesDistByBrandDataSource)
    {
        NSMutableArray *brands = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (NSInteger i = 0 ; i < brandListDataSource.brandArray.count ; i ++ )
        {
            NSNumber *selected = [brandListDataSource.itemSelected objectAtIndex:i];
            if ([selected boolValue])
                [brands addObject:[brandListDataSource.brandArray objectAtIndex:i]];
        }
        
        subViewController.selectedBrands = brands;
    }
    else
    {
        NSMutableArray *products = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (NSInteger i = 0 ; i < productListDataSource.productArray.count ; i ++ )
        {
            NSNumber *selected = [productListDataSource.itemSelected objectAtIndex:i];
            if ([selected boolValue])
                [products addObject:[productListDataSource.productArray objectAtIndex:i]];
        }

        subViewController.selectedProducts = products;
    }
    
    [self presentViewController:subViewController animated:YES completion:nil];
}

@end
