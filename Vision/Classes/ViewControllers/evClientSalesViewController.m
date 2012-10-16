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

@interface evClientSalesViewController ()

@end

@implementation evClientSalesViewController

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
    clientSalesDataSource.clientSalesAggr = [ClientSalesAggr Aggr];
    
    NSString *licencekey = @"qgi64t6X5laUi6GMjAxMjExMTNpbmZvQHNoaW5vYmljb250cm9scy5jb20=UQ5WGyladC7SlbiYUt2BGUgxvt5ympt45rNMEzT1QST5KGlUA/v4WpV2NKh6yvMzqNQ/DmXZ0Uqya51NUqOn1m9u53sQpdOXKeJnkm127zUN6nOWKgY6wTEsh6vc71uYwcaVuB5lErG9+qDD9BZZdVQJ4Q7s=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+";
    
    //Create the grid
    clientSalesGrid = [[ShinobiGrid alloc] initWithFrame:self.view.bounds];
    
    clientSalesGrid.licenseKey = licencekey;
    
    clientSalesGrid.dataSource = clientSalesDataSource;
    clientSalesGrid.delegate = self;
    
    //Freeze our top and left most rows
    [clientSalesGrid freezeRowsAboveAndIncludingRow:SGridRowMake(0, 0)];
    
    //Some basic grid styling
    clientSalesGrid.backgroundColor = [UIColor whiteColor];
    clientSalesGrid.rowStylesTakePriority = YES;
    clientSalesGrid.defaultGridLineStyle.width = 1.0f;
    clientSalesGrid.defaultGridLineStyle.color = [UIColor lightGrayColor];
    clientSalesGrid.defaultBorderStyle.color = [UIColor darkGrayColor];
    clientSalesGrid.defaultBorderStyle.width = 1.0f;
    
    //provide default row heights and col widths
    clientSalesGrid.defaultRowStyle.size = [NSNumber numberWithFloat:25];
    clientSalesGrid.defaultColumnStyle.size = [NSNumber numberWithFloat:100];
    
    //ensure that section header is hidden (a grid has one section by default)
    clientSalesGrid.defaultSectionHeaderStyle.hidden = YES;
    clientSalesGrid.defaultSectionHeaderStyle.hidden = YES;
    
    //We dont want to be able to edit our cells
    clientSalesGrid.canEditCellsViaDoubleTap = NO;
    
    //Enable dragging - we want to be able to reorder in any direction
    clientSalesGrid.canReorderColsViaLongPress = YES;
    clientSalesGrid.canReorderRowsViaLongPress = YES;
    
    clientSalesGrid.frame = CGRectMake(1, 1, 2, 2);
    
    // this displays the grid
    [self.view addSubview:clientSalesGrid];
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
    
    clientSalesGrid.frame = CGRectMake(9, 350, self.view.bounds.size.width-20, self.view.bounds.size.height-390);

    UIViewController *templateController = [self.storyboard instantiateViewControllerWithIdentifier:isPortrait ? @"ClientSalesPortraitView" : @"ClientSalesLandscapeView"];
    if (templateController)
    {
        int count = 0;
        for (UIView *eachView in ClientSalesSubviews(templateController.view))
        {
            NSLog(@"Tag %d %@ %d", count++, eachView.accessibilityLabel  , eachView.tag);
            
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

@end
