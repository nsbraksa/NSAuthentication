//
//  SignupViewController.m
//  app
//
//  Created by zakaria on 2/11/14.
//  Copyright (c) 2014 Zakaria Braksa. All rights reserved.
//

#import "SignupViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <SSKeychain.h>
#import "constants.h"
#import "AppDelegate.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signupAction:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* url = [[NSString alloc] initWithFormat:@"%@/users/register",kBaseAPI];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //NSString* userToken = [SSKeychain passwordForService:@"UserService" account:@"UserAccount"];
    //[manager.requestSerializer setValue:userToken forHTTPHeaderField:@"token"];
    NSDictionary *parameters = @{ @"user[name]" : self.nameField.text,
                                  @"user[email]"   : self.emailField.text,
                                  @"user[password]": self.passwordField.text
                                  };
    
    [SVProgressHUD showWithStatus:@"Processing ..."];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [manager POST:url
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON %@",responseObject);
              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
              
              if([[responseObject objectForKey:@"success"] boolValue] == true){
                  //NSLog(@"JSON %@",responseObject);
                  [defaults setObject:[responseObject objectForKey:@"token"] forKey:@"sessionToken"];
                  [defaults setObject:[responseObject objectForKey:@"name"] forKey:@"userName"];
                  [defaults setObject:[responseObject objectForKey:@"email"] forKey:@"userEmail"];
                  [defaults setObject:[responseObject objectForKey:@"id"] forKey:@"userId"];
                  
                  [SVProgressHUD dismiss];                  
                  
                  //switch to the main view
                  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                  UIWindow* window = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
                  UIViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
                  window.rootViewController = viewController;
                  
              }else{
                  [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
              [SVProgressHUD showErrorWithStatus:@"Make sure you're connected to the internet"];
          }];
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
