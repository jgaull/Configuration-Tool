//
//  MFBikeConfiguration+CTBikeConfigurationUtils.m
//  Configuration Tool
//
//  Created by Jon on 7/5/14.
//  Copyright (c) 2014 Modeo Vehicles LLC. All rights reserved.
//

#import "MFBikeConfiguration+CTBikeConfigurationUtils.h"

@implementation MFBikeConfiguration (CTBikeConfigurationUtils)

+ (MFBikeConfiguration *)bikeConfigurationWithPFObject:(PFObject *)object {
    
    NSMutableArray *properties = [NSMutableArray new];
    NSMutableArray *propertiesJson = [object objectForKey:@"properties"];
    for (NSDictionary *dictionary in propertiesJson) {
        MFPropertyConfigurationData *propertyConfig = [[MFPropertyConfigurationData alloc] initWithDictionary:dictionary];
        [properties addObject:propertyConfig];
    }
    
    NSMutableArray *sensors = [NSMutableArray new];
    NSMutableArray *sensorsJson = [object objectForKey:@"sensors"];
    for (NSDictionary *dictionary in sensorsJson) {
        MFSensorConfigurationData *sensorConfig = [[MFSensorConfigurationData alloc] initWithDictionary:dictionary];
        [sensors addObject:sensorConfig];
    }
    
    NSString *versionNumber = [object objectForKey:@"versionNumber"];
    
    MFBikeConfiguration *configuration = [[MFBikeConfiguration alloc] initWithProperties:properties sensors:sensors versionNumber:versionNumber];
    return configuration;
}

@end
