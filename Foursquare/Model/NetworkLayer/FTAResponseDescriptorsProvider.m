//
//  FTAResponseDescriptorsProvider.m
//  Foursquare
//
//  Created by Yuriy Berdnikov on 6/9/15.
//  Copyright (c) 2015 Yuriy Berdnikov. All rights reserved.
//

#import "FTAResponseDescriptorsProvider.h"
#import "FTAResponseDataMapper.h"

@implementation FTAResponseDescriptorsProvider

+ (instancetype)sharedInstance
{
    static FTAResponseDescriptorsProvider *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[FTAResponseDescriptorsProvider alloc] init];
    });
    
    return _sharedInstance;
}

- (NSArray *)responseDescriptors
{
    return @[
             [self restaurantsResponseDescriptor],
             ];
}

- (RKResponseDescriptor *)restaurantsResponseDescriptor
{
    RKObjectMapping *responseMapping = [[FTAResponseDataMapper sharedInstance] restaurantsMapping];
    
    RKResponseDescriptor *restaurantsResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                                       method:RKRequestMethodGET
                                                                                                  pathPattern:@"venues/explore"
                                                                                                      keyPath:@"response.groups"
                                                                                                  statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return restaurantsResponseDescriptor;
}

@end
