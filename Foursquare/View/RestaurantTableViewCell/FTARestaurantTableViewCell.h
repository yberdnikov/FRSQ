//
//  FTARestaurantTableViewCell.h
//  Foursquare
//
//  Created by Yuriy Berdnikov on 6/9/15.
//  Copyright (c) 2015 Yuriy Berdnikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTAVenue;

@interface FTARestaurantTableViewCell : UITableViewCell

@property (nonatomic, strong) FTAVenue *venue;

+ (NSString *)reuseIdentifier;

@end
