//
//  evLogonViewController.m
//  Vision
//
//  Created by Ian Molesworth on 30/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "evLogonViewController.h"

#import "User.h"
#import "Product.h"
#import "Practice.h"
#import "Focused_brand.h"
#import "Customer.h"

#import "umfundiAppDelegate.h"
#import "Reachability.h"


@interface evLogonViewController ()

@end

@implementation evLogonViewController

@synthesize userField;
@synthesize passwordField;

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
    
    NSString *user = [User lastLoginUser];
    if (user)
        [userField setText:user];

    HUDDownload = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUDDownload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![User existsSqliteFileForUsers:NO])
    {
        isNetworkAvailable = YES;
        
        // Check the Network Availability
        checkNetTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                       selector:@selector(checkNetworkAvailability)
                                                       userInfo:nil repeats:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([[userField text] length] == 0)
        [userField becomeFirstResponder];
    else
        [passwordField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (checkNetTimer)
    {
        [checkNetTimer invalidate];
        checkNetTimer = nil;
    }
}


- (void)checkNetworkAvailability
{
    // Check the network.
    umfundiAppDelegate *appDelegate = (umfundiAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.reachability.currentReachabilityStatus == NotReachable)
    {
        [userField resignFirstResponder];
        [passwordField resignFirstResponder];
        
        // Network unavailable
        isNetworkAvailable = NO;
        
        if (!HUDNetworkAvailable)
        {
            HUDNetworkAvailable = [[MBProgressHUD alloc] initWithView:self.view];
            HUDNetworkAvailable.labelText = @"Network is required for initial log in";
            [self.view addSubview:HUDNetworkAvailable];
            
            [HUDNetworkAvailable showWhileExecuting:@selector(loopUntilNetworkAvailable) onTarget:self withObject:nil animated:YES];
        }
    }
    else
    {
        // Network available
        isNetworkAvailable = YES;
    }
}

- (void)loopUntilNetworkAvailable
{
    while (!isNetworkAvailable)
        [NSThread sleepForTimeInterval:1];
    
    HUDNetworkAvailable = nil;
}

- (IBAction)CheckCredentials:(id)sender
{
    [userField resignFirstResponder];
    [passwordField resignFirstResponder];

    // Check if users.sqlite exists
    if ([User existsSqliteFileForUsers:YES])
    {
        // Check if user information is matched.
        User *user = [User checkCredentialsWithUser:userField.text andPassword:passwordField.text];
        if (user)
        {
            [User setLoginUser:user];
            
            // Check if <name>.sqlite database exists
            if (![User existsSqliteFileForData:YES])
            {
                // Start Download from the server - <name>.sqlite!
                HUDDownload.labelText = @"Downloading Territory Data";
                [HUDDownload show:YES];

                downloadPath = [User sqliteFilepathForData];
//                NSLog(@"Download territory file %@",downloadPath);
                conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[User sqliteDownloadURLForData]]] delegate:self startImmediately:YES];

                return;
            }
        }
        else
        {
            // Authentication failed.
            [passwordField setText:@""];
            [userField becomeFirstResponder];
            [userField selectAll:nil];

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"")
                                                                message:NSLocalizedString(@"Incorrect user or password. Please try again.", @"")
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    else
        {
        // Start Download from the server - users.sqlite
        HUDDownload.labelText = @"Validating User with server";
        [HUDDownload show:YES];

        downloadPath = [User sqliteFilepathForUsers];
        conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[User sqliteDownloadURLForUsers]]] delegate:self startImmediately:YES];
        
        return;
        }
    
    HUDProcessing = [[MBProgressHUD alloc] initWithView:self.view];
    HUDProcessing.labelText = @"Processing tables ...";
    [self.view addSubview:HUDProcessing];
    
    [HUDProcessing show:YES];
    
    // set logged in mode and quit back to main page
    [self performSegueWithIdentifier:@"exitLogOn" sender:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

// respond to interface re-orientation by updating the layout
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    BOOL isPortrait = UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    
    UIViewController *templateController = [self.storyboard instantiateViewControllerWithIdentifier:isPortrait ? @"LogonPortraitView" : @"LogonLandscapeView"];
    if (templateController)
    {
        for (UIView *eachView in LogonSubviews(templateController.view))
        {
//            NSLog(@"Tag %d %@ %d", count++, eachView.accessibilityLabel  , eachView.tag);
            
            int tag = eachView.tag;
            if(tag < 10 ) continue;
            [self.view viewWithTag:tag].frame = eachView.frame;
        }
    }
}

NSArray *LogonSubviews(UIView *aView)
{
    NSArray *results = [aView subviews];
    for (UIView *eachView in [aView subviews])
    {
        NSArray *theSubviews = LogonSubviews(eachView);
        if (theSubviews)
            results = [results arrayByAddingObjectsFromArray:theSubviews];
    }
    return results;
}


- (void)viewDidUnload
{
    [self setUserField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
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
    
    if (![[NSFileManager defaultManager] moveItemAtPath:[downloadPath stringByAppendingString:@".tmp"] toPath:downloadPath error:nil])
    {
        [self connection:connection didFailWithError:nil];
        return;
    }

    if (![User existsSqliteFileForData:NO])
    {
        // Download users file.
        [self performSelector:@selector(CheckCredentials:) withObject:nil afterDelay:0.1];
    }
    else
        [self performSegueWithIdentifier:@"exitLogOn" sender:self];
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

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == userField)
        [passwordField becomeFirstResponder];
    else
        [self CheckCredentials:nil];
        
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField selectAll:nil];
}

@end
