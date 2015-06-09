//
//  FTAResponseDataMapper.h
//  Foursquare
//
//  Created by Yuriy Berdnikov on 6/9/15.
//  Copyright (c) 2015 Yuriy Berdnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>

@interface FTAResponseDataMapper : NSObject

+ (instancetype)sharedInstance;

- (RKEntityMapping *)restaurantsMapping;

@end
