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
@property (weak, nonatomic) IBOutlet UISwitch *callbackOnChangeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *eepromSaveSwitch;
@property (weak, nonatomic) IBOutlet UITextField *defaultValueTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *permissionsSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dataTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *numBytesLabel;
@property (weak, nonatomic) IBOutlet UIButton *addByteButton;

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
    [self updateUI];
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

- (void)updateUI {
    
    self.title = self.propertyConfiguration.name;
    
    self.dataTypeSegmentedControl.selectedSegmentIndex = self.propertyConfiguration.dataType;
    self.permissionsSegmentedControl.selectedSegmentIndex = self.propertyConfiguration.permissions;
    
    self.eepromSaveSwitch.on = self.propertyConfiguration.eepromSave;
    self.callbackOnChangeSwitch.on = self.propertyConfiguration.callbackOnChange;
    
    NSString *defaultValueString = @"";
    if (self.propertyConfiguration.dataType == kPropertyDataTypeByte) {
        defaultValueString = [NSString stringWithFormat:@"%d", self.propertyConfiguration.defaultValue.byteValue];
    }
    else if (self.propertyConfiguration.dataType == kPropertyDataTypeUnsignedShort) {
        defaultValueString = [NSString stringWithFormat:@"%d", self.propertyConfiguration.defaultValue.unsignedShortValue];
    }
    else if (self.propertyConfiguration.dataType == kPropertyDataTypeByteArray) {
        
        NSString *byteArrayString = @"";
        
        NSUInteger length = self.propertyConfiguration.defaultValue.length;
        if (length > 0) {
            
            Byte *bytes = (Byte *)self.propertyConfiguration.defaultValue.rawData.bytes;
            
            for (NSInteger i = 0; i < self.propertyConfiguration.defaultValue.length; i++) {
                NSInteger value = bytes[i];
                byteArrayString = [NSString stringWithFormat:@"%@,%ld", byteArrayString, (long)value];
            }
            
            byteArrayString = [byteArrayString substringFromIndex:1];
        }
        
        defaultValueString = byteArrayString;
    }
    else if (self.propertyConfiguration.dataType == kPropertyDataTypeString) {
        defaultValueString = self.propertyConfiguration.defaultValue.utf8StringValue;
    }
    
    self.defaultValueTextField.text = defaultValueString;
    self.nameField.text = self.propertyConfiguration.name;
    self.identifierField.text = [NSString stringWithFormat:@"%ld", (long)self.propertyConfiguration.identifier];
    
    NSUInteger size = self.propertyConfiguration.defaultValue.length;
    NSString *suffix = size != 1 ? @"s" : @"";
    self.numBytesLabel.text = [NSString stringWithFormat:@"(%lu byte%@)", (unsigned long)size, suffix];
    
    self.addByteButton.enabled = self.dataTypeSegmentedControl.selectedSegmentIndex == kPropertyDataTypeByteArray;
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
        self.propertyConfiguration.name = textField.text;
    }
    else if (textField == self.identifierField) {
        NSInteger value = textField.text.integerValue;
        value = MIN(value, 255);
        value = MAX(value, 0);
        self.propertyConfiguration.identifier = value;
    }
    else if (textField == self.defaultValueTextField) {
        
        MFPropertyData *defaultValue;
        if (self.propertyConfiguration.dataType == kPropertyDataTypeByte) {
            defaultValue = [MFPropertyData propertyDataWithByte:(Byte)textField.text.integerValue];
        }
        else if (self.propertyConfiguration.dataType == kPropertyDataTypeUnsignedShort) {
            defaultValue = [MFPropertyData propertyDataWithUnsignedShort:(unsigned short)textField.text.integerValue];
        }
        else if (self.propertyConfiguration.dataType == kPropertyDataTypeString) {
            defaultValue = [MFPropertyData propertyDataWithUTF8String:textField.text];
        }
        else {
            NSArray *byteStrings = [textField.text componentsSeparatedByString:@","];
            
            Byte bytes[byteStrings.count];
            
            for (NSInteger i = 0; i < byteStrings.count; i++) {
                NSInteger value = [[byteStrings objectAtIndex:i] integerValue];
                
                if (value < 255) {
                    bytes[i] = (Byte)value;
                }
            }
            
            NSData *rawData = [NSData dataWithBytes:bytes length:byteStrings.count];
            defaultValue = [MFPropertyData propertyDataWithData:rawData];
        }
        
        self.propertyConfiguration.defaultValue = defaultValue;
    }
    
    self.editingTextField = nil;
    
    [self updateUI];
}

- (IBAction)callbackOnChangeSwitchDidChange:(UISwitch *)sender {
    self.propertyConfiguration.callbackOnChange = sender.on;
    [self updateUI];
}

- (IBAction)eepromSaveSwitchDidChange:(UISwitch *)sender {
    self.propertyConfiguration.eepromSave = sender.on;
    [self updateUI];
}

- (IBAction)permissionsSegmentedControlDidChange:(UISegmentedControl *)sender {
    self.propertyConfiguration.permissions = (MFPropertyPermission)sender.selectedSegmentIndex;
    [self updateUI];
}

- (IBAction)dataTypeSegmentedControldidChange:(UISegmentedControl *)sender {
    MFPropertyDataType dataType = (MFPropertyDataType)sender.selectedSegmentIndex;
    self.propertyConfiguration.dataType = dataType;
    
    MFPropertyData *newPropertyData;
    
    if (dataType == kPropertyDataTypeByte) {
        newPropertyData = [MFPropertyData propertyDataWithByte:0];
    }
    else if (dataType == kPropertyDataTypeUnsignedShort) {
        newPropertyData = [MFPropertyData propertyDataWithUnsignedShort:0];
    }
    else if (dataType == kPropertyDataTypeByteArray) {
        newPropertyData = [[MFPropertyData alloc] init];
    }
    else if (dataType == kPropertyDataTypeString) {
        newPropertyData = [MFPropertyData propertyDataWithUTF8String:@""];
    }
    
    self.propertyConfiguration.defaultValue = newPropertyData;
    
    [self updateUI];
}
- (IBAction)userDidTapAddByte:(UIButton *)sender {
    NSUInteger length = self.propertyConfiguration.defaultValue.length + 1;
    self.propertyConfiguration.defaultValue = [[MFPropertyData alloc] initWithLength:length];
    [self updateUI];
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
