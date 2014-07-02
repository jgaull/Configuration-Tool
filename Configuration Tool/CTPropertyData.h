//
//  CTPropertyData.h
//  Configuration Tool
//
//  Created by Jon on 7/2/14.
//  Copyright (c) 2014 Modeo Vehicles LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CTConfigurationData.h"

@interface CTPropertyData : CTConfigurationData

@property (nonatomic) NSInteger identifier;
@property (nonatomic) NSInteger size;
@property (nonatomic) BOOL callbackOnChange;

@end
