//
//  FTAVenuePhoto.h
//  Foursquare
//
//  Created by Yuriy Berdnikov on 6/9/15.
//  Copyright (c) 2015 Yuriy Berdnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FTAVenue;

@interface FTAVenuePhoto : NSManagedObject

@property (nonatomic, retain) NSString * photoID;
@property (nonatomic, retain) NSString * prefix;
@property (nonatomic, retain) NSString * suffix;
@property (nonatomic, retain) FTAVenue *venue;

@end
