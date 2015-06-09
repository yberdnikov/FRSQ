//
//  FTAVenue.h
//  Foursquare
//
//  Created by Yuriy Berdnikov on 6/9/15.
//  Copyright (c) 2015 Yuriy Berdnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FTAVenuePhoto, FTAVenuesGroup;

@interface FTAVenue : NSManagedObject

@property (nonatomic, retain) NSString * venueID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * rating;
@property (nonatomic, retain) NSNumber * ratingSignals;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) FTAVenuesGroup *group;
@end

@interface FTAVenue (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(FTAVenuePhoto *)value;
- (void)removePhotosObject:(FTAVenuePhoto *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
