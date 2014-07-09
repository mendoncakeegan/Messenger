//
//  ImageMessageViewCell.h
//  Messenger
//
//  Created by Jose de Jesus Hernandez on 7/8/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageMessageViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *imageSender;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailView;

//@property (strong, nonatomic)

- (void)setThumbnailViewFromImage:(UIImage *)image;

@end
