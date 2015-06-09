//
//  FTAResponseDescriptorsProvider.h
//  Foursquare
//
//  Created by Yuriy Berdnikov on 6/9/15.
//  Copyright (c) 2015 Yuriy Berdnikov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTAResponseDescriptorsProvider : NSObject

+ (instancetype)sharedInstance;

- (NSArray *)responseDescriptors;

@end
