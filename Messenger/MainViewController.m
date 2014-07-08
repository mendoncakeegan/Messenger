//
//  MainViewController.m
//  Messenger
//
//  Created by Keegan Mendonca on 7/1/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "MainViewController.h"
#import "CustomLoginViewController.h"
#import "CustomSignupViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

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
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[CustomLoginViewController alloc] init];
        logInViewController.fields = PFLogInFieldsLogInButton|PFLogInFieldsUsernameAndPassword|PFLogInFieldsSignUpButton;
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[CustomSignupViewController alloc] init];
        signUpViewController.fields = PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsSignUpButton | PFSignUpFieldsDismissButton;
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (!username || username.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Enter in username"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
        return NO;
    }
    if(!password || password.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Enter in password"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
        return NO;
    }
    return YES; // Interrupt login process
}
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpViewController shouldBeginSignUp:(NSDictionary *)info{
    // Check if both fields are completed
    NSString * username = info[@"username"];
    NSString * password = info[@"password"];
    if (!username || username.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Enter in username"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
        return NO;
    }
    if(!password || password.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Enter in password"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
        return NO;
    }
    return YES;
}
-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    user[@"friends"] = @[];
    user[@"messages"] = @[];
    user[@"requests"] = @[];
    [user save];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
