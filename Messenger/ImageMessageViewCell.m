//
//  ImageMessageViewCell.m
//  Messenger
//
//  Created by Jose de Jesus Hernandez on 7/8/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "ImageMessageViewCell.h"

@interface ImageMessageViewCell ()


@end

@implementation ImageMessageViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self setThumbnailViewFromImage:image];
    
    NSLog(@"Thumbnail view: %@", self.thumbnailView);
    NSLog(@"Thumbnail view image: %@", self.thumbnailView.image);
}

- (void)setThumbnailViewFromImage:(UIImage *)image
{
    CGSize origImageSize = image.size;
    
    CGRect newRect = CGRectMake(self.imageView.bounds.origin.x, self.imageView.bounds.origin.y,
                                self.imageView.bounds.size.width, self.imageView.bounds.size.height);
    
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height / origImageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(origImageSize, NO, 0.0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:5.0];
    [path addClip];
    
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    [image drawInRect:projectRect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    _thumbnailView = [[UIImageView alloc] initWithImage:smallImage];
    NSLog(@"Inner: %g", self.thumbnailView.bounds.size.width);
}


@end
