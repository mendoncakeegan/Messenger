//
//  SendViewController.m
//  Messenger
//
//  Created by Keegan Mendonca on 7/1/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "SendViewController.h"
#import "Parse/Parse.h"
@interface SendViewController ()

@end

@implementation SendViewController

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PFUser *user = [PFUser currentUser];
    _users = user[@"friends"];
    if(!_users|| [_users count] == 0)
        return 2;
    return [_users count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser *user = [PFUser currentUser];
    _users = user[@"friends"];
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
        cell.textLabel.text = @"You have no friends";
    return cell;
}
-(void)btnPressed
{
    self.tabBarController.selectedViewController
    = [self.tabBarController.viewControllers objectAtIndex:2];
}
-(void)userPressed:(UIButton *) button
{
    _receiver = [[button titleLabel] text];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Send Message" message:@"Type sentence" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        NSString * input = [[alertView textFieldAtIndex:0] text];
        NSDictionary * params = @{@"username": _receiver, @"message": input};
        [PFCloud callFunctionInBackground:@"sendMessage" withParameters:params block:^(NSArray *results, NSError *error)
         {
             if(!error)
             {
                 [[[UIAlertView alloc] initWithTitle:@"Message Sent"
                                             message:@"Message has been sent"
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil] show];
             }
             else
             {
                 [[[UIAlertView alloc] initWithTitle:@"Error"
                                             message:error.localizedDescription
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil] show];
             }
         }];
        
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    PFUser *user = [PFUser currentUser];
    [self.tableView reloadData];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
