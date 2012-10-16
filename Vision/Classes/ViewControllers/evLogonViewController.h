//
//  evLogonViewController.h
//  Vision
//
//  Created by Ian Molesworth on 30/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface evLogonViewController : UIViewController <NSURLConnectionDelegate, UITextFieldDelegate>
{
    MBProgressHUD *HUDNetworkAvailable;
    NSTimer *checkNetTimer;
    BOOL isNetworkAvailable;
    
    MBProgressHUD *HUDDownload;
    MBProgressHUD *HUDProcessing;
    NSURLConnection *conn;
    NSString *downloadPath;
}

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (void)checkNetworkAvailability;

- (IBAction)CheckCredentials:(id)sender;

@end
