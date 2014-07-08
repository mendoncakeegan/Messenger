//
//  PeopleViewController.m
//  Messenger
//
//  Created by Keegan Mendonca on 7/1/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "PeopleViewController.h"
#import "Parse/Parse.h"
@interface PeopleViewController ()
@end

@implementation PeopleViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    PFUser *user = [PFUser currentUser];
    [self.tableView setEditing:YES animated:YES];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL edit = (indexPath.row != 0);
    _users = PFUser.currentUser[@"requests"];
    if(!_users|| [_users count] == 0)
        edit = NO;
    return edit;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _users = PFUser.currentUser[@"requests"];
    if(!_users|| [_users count] == 0)
        return 2;
    return [_users count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _users = PFUser.currentUser[@"requests"];
    // Get a new or recycled cell
    UITableViewCell *cell =
    [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                           reuseIdentifier:@"UITableViewCell"];
    if(indexPath.row == 0)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(180,20,100,20);
        [btn setTitle:@"Add Friends" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnPressed) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    else if(_users && [_users count] != 0)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(0,20,200,20);
        [btn setTitle:_users[indexPath.row - 1] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(userPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    else if(indexPath.row == 1)
        cell.textLabel.text = @"You have no friend requests";
    return cell;
}
-(void)userPressed:(UIButton *) button
{
    NSString * input = [[button titleLabel] text];
    NSDictionary * params = @{@"username": [[PFUser currentUser] username], @"user": input};
    [PFCloud callFunctionInBackground:@"acceptFriend" withParameters:params block:^(NSArray *results, NSError *error)
     {
         if(error)
         {
             [[[UIAlertView alloc] initWithTitle:@"Error"
                                         message:error.localizedDescription
                                        delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil] show];
         }
     }];
    params = @{@"username": input, @"user": [[PFUser currentUser] username]};
    [PFCloud callFunctionInBackground:@"acceptFriend" withParameters:params block:^(NSArray *results, NSError *error)
     {
         if(error)
         {
             [[[UIAlertView alloc] initWithTitle:@"Error"
                                         message:error.localizedDescription
                                        delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil] show];
         }
     }];
    PFUser * current = [PFUser currentUser];
    NSMutableArray * fri = current[@"requests"];
    [fri removeObject:input];
    current[@"requests"] = [fri copy];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Saving update" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
    self.tabBarController.selectedViewController
    = [self.tabBarController.viewControllers objectAtIndex:1];
    [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        _users = current[@"requests"];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }];
}
-(void)btnPressed
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add Friend" message:@"Enter Username" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Search", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        NSString * input = [[alertView textFieldAtIndex:0] text];
        if([input isEqualToString:[[PFUser currentUser] username]])
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"You cannot add yourself" message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                alert.alertViewStyle = UIAlertViewStyleDefault;
                [alert show];
                return;
            }
        for(NSString *person in ([PFUser currentUser])[@"friends"])
        {
            if([input isEqualToString:person])
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"You cannot add current friends" message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                alert.alertViewStyle = UIAlertViewStyleDefault;
                [alert show];
                return;
            }
        }
        NSDictionary * params = @{@"username": input, @"user": [[PFUser currentUser] username]};
        [PFCloud callFunctionInBackground:@"modifyUser" withParameters:params block:^(NSArray *results, NSError *error)
         {
             if(!error)
             {
                 [[[UIAlertView alloc] initWithTitle:@"Request Sent"
                                             message:@"Friend Request Sent"
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil] show];
             }
             else
             {
                 [[[UIAlertView alloc] initWithTitle:@"Error"
                                             message:@"User not found"
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil] show];
             }
         }];

    }
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFUser * current = [PFUser currentUser];
        NSString *input = (current[@"requests"])[indexPath.row - 1];
        NSMutableArray * fri = current[@"requests"];
        [fri removeObject:input];
        current[@"requests"] = [fri copy];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Saving update" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        self.tabBarController.selectedViewController
        = [self.tabBarController.viewControllers objectAtIndex:1];
        [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            _users = current[@"requests"];
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        }];
         } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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
