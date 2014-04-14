//
//  LoginViewController.h
//  app
//
//  Created by zakaria on 1/30/14.
//  Copyright (c) 2014 Zakaria Braksa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)signinAction:(id)sender;

- (IBAction)backgroundTap:(id)sender;


@end
