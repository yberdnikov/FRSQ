//
//  FTARestaurantViewController.m
//  Foursquare
//
//  Created by Yuriy Berdnikov on 6/9/15.
//  Copyright (c) 2015 Yuriy Berdnikov. All rights reserved.
//

#import "FTARestaurantViewController.h"
#import "FTAVenue.h"
#import "FTAVenuePhoto.h"
#import <UIImageView+WebCache.h>

@interface FTARestaurantViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *venueImageView;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueRatingLabel;

@end

@implementation FTARestaurantViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self populateViewWithVenueData];
}

- (void)populateViewWithVenueData
{
    self.title = self.venue.name;
    
    self.venueNameLabel.text = self.venue.name;
    self.venueRatingLabel.text = [NSString stringWithFormat:@"%@ (from %@ users)", self.venue.rating, self.venue.ratingSignals];
    
    FTAVenuePhoto *photo = [self.venue.photos anyObject];
    if (photo && photo.prefix.length)
    {
        NSString *photoURL = [photo.prefix stringByAppendingFormat:@"%ldx%ld%@", (long)CGRectGetWidth(self.venueImageView.bounds),
                              (long)CGRectGetHeight(self.venueImageView.bounds),
                              photo.suffix];
        [self.venueImageView sd_setImageWithURL:[NSURL URLWithString:photoURL] placeholderImage:nil];
    }
}

@end
