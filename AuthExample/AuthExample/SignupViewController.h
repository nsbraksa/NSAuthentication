//
//  SignupViewController.h
//  app
//
//  Created by zakaria on 2/11/14.
//  Copyright (c) 2014 Zakaria Braksa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)signupAction:(id)sender;
- (IBAction)closeAction:(id)sender;

@end
