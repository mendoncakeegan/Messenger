//
//  ImageMessageViewCell.h
//  Messenger
//
//  Created by Jose de Jesus Hernandez on 7/8/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageMessageViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *imageSender;

- (void)setThumbnailViewFromImage:(UIImage *)image;

@end
