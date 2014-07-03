//
//  CTEditSensorViewController.h
//  Configuration Tool
//
//  Created by Jon on 7/2/14.
//  Copyright (c) 2014 Modeo Vehicles LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ModeoFramework/MFSecretsDontLookHere.h>

@interface CTEditSensorViewController : UIViewController <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (void)textFieldDidBeginEditing:(UITextField *)textField;

@property (nonatomic, strong) MFSensorConfigurationData *sensorData;

@end
