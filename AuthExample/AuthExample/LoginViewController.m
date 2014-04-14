//
//  LoginViewController.m
//  app
//
//  Created by zakaria on 1/30/14.
//  Copyright (c) 2014 Zakaria Braksa. All rights reserved.
//

#import "LoginViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <SSKeychain.h>
#import "constants.h"
#import "AppDelegate.h"


@interface LoginViewController ()


@end

@implementation LoginViewController

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
 
}


- (IBAction)signinAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* url = [[NSString alloc] initWithFormat:@"%@/users/auth",kBaseAPI];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //NSString* userToken = [SSKeychain passwordForService:@"UserService" account:@"UserAccount"];
    //[manager.requestSerializer setValue:userToken forHTTPHeaderField:@"token"];
    NSDictionary *parameters = @{ @"login" : self.emailField.text,
                                  @"password"   : self.passwordField.text
                                  };
    
    [SVProgressHUD showWithStatus:@"Processing ..."];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [manager POST:url
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON %@",responseObject);
              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
              
              if([[responseObject objectForKey:@"success"] boolValue] == true){
                  [SVProgressHUD dismiss];
                  NSLog(@"JSON %@",responseObject);
                  [defaults setObject:[responseObject objectForKey:@"deviceToken"] forKey:@"device_token"];
                  [defaults setObject:[responseObject objectForKey:@"name"] forKey:@"userName"];
                  [defaults setObject:[responseObject objectForKey:@"email"] forKey:@"userEmail"];
                  [defaults setObject:[responseObject objectForKey:@"id"] forKey:@"userId"];
                  
                  //switch to the main view
                  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                  UIWindow* window = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
                  UIViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
                  window.rootViewController = viewController;
                  
              }else{
                  [SVProgressHUD showErrorWithStatus:@"Incorrect email/password combination"];
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
              [SVProgressHUD showErrorWithStatus:@"Make sure you're connected to the internet"];
          }];
}

- (IBAction)backgroundTap:(id)sender {
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

@end
