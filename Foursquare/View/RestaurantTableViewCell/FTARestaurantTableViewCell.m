//
//  FTARestaurantTableViewCell.m
//  Foursquare
//
//  Created by Yuriy Berdnikov on 6/9/15.
//  Copyright (c) 2015 Yuriy Berdnikov. All rights reserved.
//

#import "FTARestaurantTableViewCell.h"
#import "FTAVenue.h"
#import "FTAVenuePhoto.h"
#import <UIImageView+WebCache.h>

@interface FTARestaurantTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;

@end

@implementation FTARestaurantTableViewCell

+ (NSString *)reuseIdentifier
{
    return @"restaurantTableViewCell";
}

- (void)prepareForReuse
{
    self.restaurantImageView.image = nil;
    self.restaurantNameLabel.text = nil;
}

- (void)setVenue:(FTAVenue *)venue
{
    if (!venue)
        return;
    
    self.restaurantNameLabel.text = venue.name;
    
    FTAVenuePhoto *photo = [venue.photos anyObject];
    if (photo && photo.prefix.length)
    {
        NSString *photoURL = [photo.prefix stringByAppendingFormat:@"%ldx%ld%@", (long)CGRectGetWidth(self.restaurantImageView.bounds),
                              (long)CGRectGetHeight(self.restaurantImageView.bounds),
                              photo.suffix];
        [self.restaurantImageView sd_setImageWithURL:[NSURL URLWithString:photoURL] placeholderImage:nil];
    }
}

@end
