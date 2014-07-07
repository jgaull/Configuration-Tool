//
//  CTEditPropertyViewController.m
//  Configuration Tool
//
//  Created by Jon on 7/2/14.
//  Copyright (c) 2014 Modeo Vehicles LLC. All rights reserved.
//

#import "CTEditPropertyViewController.h"

@interface CTEditPropertyViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *identifierField;
@property (weak, nonatomic) IBOutlet UITextField *sizeField;
@property (weak, nonatomic) IBOutlet UISwitch *callbackOnChangeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *eepromSaveSwitch;
@property (weak, nonatomic) IBOutlet UITextField *defaultValueTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *permissionsSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dataTypeSegmentedControl;

@property (weak, nonatomic) UITextField *editingTextField;

@end

@implementation CTEditPropertyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.propertyConfiguration.name;
    self.nameField.text = self.propertyConfiguration.name;
    self.identifierField.text = [NSString stringWithFormat:@"%ld", (long)self.propertyConfiguration.identifier];
    self.sizeField.text = [NSString stringWithFormat:@"%ld", (long)self.propertyConfiguration.size];
    self.callbackOnChangeSwitch.on = self.propertyConfiguration.callbackOnChange;
    self.eepromSaveSwitch.on = self.propertyConfiguration.eepromSave;
    self.permissionsSegmentedControl.selectedSegmentIndex = self.propertyConfiguration.permissions;
    self.dataTypeSegmentedControl.selectedSegmentIndex = self.propertyConfiguration.dataType;
    
    if (self.propertyConfiguration.dataType == kPropertyDataTypeByteArray) {
        self.defaultValueTextField.text = self.propertyConfiguration.defaultValue.utf8StringValue;
    }
    else {
        NSNumber *value;
        
        switch (self.propertyConfiguration.dataType) {
            case kPropertyDataTypeByte:
                value = [NSNumber numberWithInteger:self.propertyConfiguration.defaultValue.byteValue];
                break;
                
            case kPropertyDataTypeUnsignedShort:
                value = [NSNumber numberWithInteger:self.propertyConfiguration.defaultValue.unsignedShortValue];
                break;
                
            case kPropertyDataTypeByteArray:
            default:
                NSLog(@"Uknown data type for default value!");
                break;
        }
        
        self.defaultValueTextField.text = [NSString stringWithFormat:@"%@", value];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.editingTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.editingTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.nameField) {
        self.title = textField.text;
        self.propertyConfiguration.name = textField.text;
    }
    else if (textField == self.identifierField) {
        NSInteger value = textField.text.integerValue;
        value = MIN(value, 255);
        value = MAX(value, 0);
        self.propertyConfiguration.identifier = value;
        textField.text = [NSString stringWithFormat:@"%ld", (long)value];
    }
    else if (textField == self.sizeField) {
        NSInteger value = textField.text.integerValue;
        value = MIN(value, 17);
        value = MAX(value, 0);
        self.propertyConfiguration.size = value;
        textField.text = [NSString stringWithFormat:@"%ld", (long)value];
    }
    else if (textField == self.defaultValueTextField) {
        
        MFPropertyData *defaultValue;
        switch (self.propertyConfiguration.dataType) {
            case kPropertyDataTypeByte:
                defaultValue = [MFPropertyData propertyDataWithByte:(Byte)textField.text.integerValue];
                break;
                
            case kPropertyDataTypeUnsignedShort:
                defaultValue = [MFPropertyData propertyDataWithUnsignedShort:(unsigned short)textField.text.integerValue];
                break;
                
            case kPropertyDataTypeByteArray:
                defaultValue = [MFPropertyData propertyDataWithBase64String:textField.text];
                break;
                
            default:
                NSLog(@"Uknown data type for default value!");
                break;
        }
        
        self.propertyConfiguration.defaultValue = defaultValue;
    }
    
    self.editingTextField = nil;
}

- (IBAction)callbackOnChangeSwitchDidChange:(UISwitch *)sender {
    self.propertyConfiguration.callbackOnChange = self.callbackOnChangeSwitch.on;
}

- (IBAction)eepromSaveSwitchDidChange:(UISwitch *)sender {
    self.propertyConfiguration.eepromSave = sender.on;
}

- (IBAction)permissionsSegmentedControlDidChange:(UISegmentedControl *)sender {
    self.propertyConfiguration.permissions = (MFPropertyPermission)sender.selectedSegmentIndex;
}

- (IBAction)dataTypeSegmentedControldidChange:(UISegmentedControl *)sender {
    self.propertyConfiguration.dataType = (MFPropertyDataType)sender.selectedSegmentIndex;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
