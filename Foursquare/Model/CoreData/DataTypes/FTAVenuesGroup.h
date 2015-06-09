//
//  FTAVenuesGroup.h
//  Foursquare
//
//  Created by Yuriy Berdnikov on 6/9/15.
//  Copyright (c) 2015 Yuriy Berdnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FTAVenue;

@interface FTAVenuesGroup : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *venues;
@end

@interface FTAVenuesGroup (CoreDataGeneratedAccessors)

- (void)addVenuesObject:(FTAVenue *)value;
- (void)removeVenuesObject:(FTAVenue *)value;
- (void)addVenues:(NSSet *)values;
- (void)removeVenues:(NSSet *)values;

@end
