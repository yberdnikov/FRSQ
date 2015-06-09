//
//  FTAResponseDataMapper.m
//  Foursquare
//
//  Created by Yuriy Berdnikov on 6/9/15.
//  Copyright (c) 2015 Yuriy Berdnikov. All rights reserved.
//

#import "FTAResponseDataMapper.h"
#import "FTAVenuePhoto.h"
#import "FTAVenue.h"
#import "FTAVenuesGroup.h"

@implementation FTAResponseDataMapper

+ (instancetype)sharedInstance
{
    static FTAResponseDataMapper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[FTAResponseDataMapper alloc] init];
    });
    
    return _sharedInstance;
}

- (RKEntityMapping *)photoMapping
{
    RKEntityMapping *responseMapping = [RKEntityMapping mappingForEntityForName:@"FTAVenuePhoto" inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    responseMapping.identificationAttributes = @[@"photoID"];
    [responseMapping addAttributeMappingsFromDictionary:@{
                                                          @"id": @"photoID",
                                                          @"prefix": @"prefix",
                                                          @"suffix" : @"suffix"
                                                          }];
    return responseMapping;
}

- (RKEntityMapping *)restaurantMapping
{
    RKEntityMapping *responseMapping = [RKEntityMapping mappingForEntityForName:@"FTAVenue" inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    responseMapping.identificationAttributes = @[@"venueID"];
    [responseMapping addAttributeMappingsFromDictionary:@{
                                                          @"venue.id": @"venueID",
                                                          @"venue.name": @"name",
                                                          @"venue.rating": @"rating",
                                                          @"venue.ratingSignals": @"ratingSignals",
                                                          }];
    
    [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"venue.featuredPhotos.items"
                                                                                    toKeyPath:@"photos"
                                                                                  withMapping:[self photoMapping]]];
    
    return responseMapping;
}

- (RKEntityMapping *)restaurantsMapping
{
    RKEntityMapping *responseMapping = [RKEntityMapping mappingForEntityForName:@"FTAVenuesGroup" inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    responseMapping.identificationAttributes = @[@"name"];
    [responseMapping addAttributeMappingsFromDictionary:@{
                                                          @"name": @"name",
                                                          @"type": @"type",
                                                          }];
    
    [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"items"
                                                                                    toKeyPath:@"venues"
                                                                                  withMapping:[self restaurantMapping]]];
    return responseMapping;
}

@end
