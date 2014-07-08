//
//  MainViewController.h
//  Messenger
//
//  Created by Keegan Mendonca on 7/1/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
@interface MainViewController :  UITabBarController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end
