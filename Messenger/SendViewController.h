//
//  SendViewController.h
//  Messenger
//
//  Created by Keegan Mendonca on 7/1/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendViewController : UITableViewController
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSString *receiver;
@end
