//
//  PeopleViewController.h
//  Messenger
//
//  Created by Keegan Mendonca on 7/1/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleViewController : UITableViewController <UIAlertViewDelegate>
@property (nonatomic, strong) NSArray *users;
@end
