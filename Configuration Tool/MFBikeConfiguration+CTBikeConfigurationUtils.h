//
//  MFBikeConfiguration+CTBikeConfigurationUtils.h
//  Configuration Tool
//
//  Created by Jon on 7/5/14.
//  Copyright (c) 2014 Modeo Vehicles LLC. All rights reserved.
//

#import <ModeoFramework/ModeoFramework.h>
#import <ModeoFramework/MFSecretsDontLookHere.h>
#import <Parse/Parse.h>

@interface MFBikeConfiguration (CTBikeConfigurationUtils)

+ (MFBikeConfiguration *)bikeConfigurationWithPFObject:(PFObject *)parseObject;

@end
