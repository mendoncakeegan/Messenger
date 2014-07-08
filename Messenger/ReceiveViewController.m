//
//  ReceiveViewController.m
//  Messenger
//
//  Created by Keegan Mendonca on 7/1/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "ReceiveViewController.h"
#import "Parse/Parse.h"
@interface ReceiveViewController ()

@end

@implementation ReceiveViewController

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
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL edit = (indexPath.row != 0);
    _msgs = PFUser.currentUser[@"messages"];
    if(!_msgs|| [_msgs count] == 0)
        edit = NO;
    return edit;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!_msgs|| [_msgs count] == 0)
        return 2;
    return [_msgs count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get a new or recycled cell
    _msgs =PFUser.currentUser[@"messages"];
    UITableViewCell *cell =
    [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                           reuseIdentifier:@"UITableViewCell"];
    if(indexPath.row == 0)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(180,20,150,20);
        [btn setTitle:@"Send Message" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnPressed) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    else if(_msgs && [_msgs count] != 0)
        cell.textLabel.text = _msgs[indexPath.row - 1];
    else if(indexPath.row == 1)
        cell.textLabel.text = @"You have no messages";
    return cell;
}
-(void)btnPressed
{
    self.tabBarController.selectedViewController
    = [self.tabBarController.viewControllers objectAtIndex:0];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFUser * current = [PFUser currentUser];
        if(current[@"messages"] || [current[@"messages"]count] <= 1)
        {
            current[@"messages"] = @[];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Deleting message" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            alert.alertViewStyle = UIAlertViewStyleDefault;
            [alert show];
            self.tabBarController.selectedViewController
            = [self.tabBarController.viewControllers objectAtIndex:0];
            [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                _msgs = current[@"messages"];
                [alert dismissWithClickedButtonIndex:0 animated:YES];
            }];
            return;
        }
        NSString *input = (current[@"messages"])[indexPath.row - 1];
        NSMutableArray * fri = current[@"messages"];
        [fri removeObject:input];
        current[@"messages"] = [fri copy];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Deleting message" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        self.tabBarController.selectedViewController
        = [self.tabBarController.viewControllers objectAtIndex:1];
        [current saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            _msgs = current[@"messages"];
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        }];
        self.tabBarController.selectedViewController
        = [self.tabBarController.viewControllers objectAtIndex:0];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
