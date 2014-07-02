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
    self.title = self.propertyData.name;
    self.nameField.text = self.propertyData.name;
    self.identifierField.text = [NSString stringWithFormat:@"%ld", (long)self.propertyData.identifier];
    self.sizeField.text = [NSString stringWithFormat:@"%ld", (long)self.propertyData.size];
    self.callbackOnChangeSwitch.on = self.propertyData.callbackOnChange;
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
        self.propertyData.name = textField.text;
    }
    else if (textField == self.identifierField) {
        NSInteger value = textField.text.integerValue;
        value = MIN(value, 255);
        value = MAX(value, 0);
        self.propertyData.identifier = value;
        textField.text = [NSString stringWithFormat:@"%ld", (long)value];
    }
    else if (textField == self.sizeField) {
        NSInteger value = textField.text.integerValue;
        value = MIN(value, 17);
        value = MAX(value, 0);
        self.propertyData.size = value;
        textField.text = [NSString stringWithFormat:@"%ld", (long)value];
    }
    
    self.editingTextField = nil;
}

- (IBAction)callbackOnChangeSwitchDidChange:(UISwitch *)sender {
    self.propertyData.callbackOnChange = self.callbackOnChangeSwitch.on;
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
