//
//  ImageReceiveViewController.m
//  Messenger
//
//  Created by Jose de Jesus Hernandez on 7/8/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "ImageReceiveViewController.h"
#import "ImageMessageViewCell.h"
#import "Parse/Parse.h"

@interface ImageReceiveViewController ()

@end

@implementation ImageReceiveViewController

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
    
    [self.tableView registerClass:[ImageMessageViewCell class]
           forCellReuseIdentifier:@"ImageMessageViewCell"];
    
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
    // Return the number of rows in the section.
    return [PFUser.currentUser[@"messages"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageMessageViewCell"
                                                                 forIndexPath:indexPath];
    if (!cell) {
        cell = [[ImageMessageViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:@"ImageMessageViewCell"];
    }
    
    NSArray *imageMessages = PFUser.currentUser[@"images"];
    UIImage *cellImage = (imageMessages && [imageMessages count] > 0) ? imageMessages[indexPath.row] : nil;
    cell.thumbnailView.image = cellImage;
    
    NSArray *imageSenders = PFUser.currentUser[@"senders"];
    NSString *imageSender = (imageSenders && [imageSenders count] > 0) ? imageSenders[indexPath.row] : nil;
    cell.imageSender.text = imageSender;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *imageMessages = PFUser.currentUser[@"images"];
    return !(!imageMessages || [imageMessages count] == 0);
}

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
