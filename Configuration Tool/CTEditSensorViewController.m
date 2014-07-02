//
//  CTEditSensorViewController.m
//  Configuration Tool
//
//  Created by Jon on 7/2/14.
//  Copyright (c) 2014 Modeo Vehicles LLC. All rights reserved.
//

#import "CTEditSensorViewController.h"

@interface CTEditSensorViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *identifierField;

@property (weak, nonatomic) UITextField *editingTextField;

@end

@implementation CTEditSensorViewController

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
    self.title = self.sensorData.name;
    self.nameField.text = self.sensorData.name;
    self.identifierField.text = [NSString stringWithFormat:@"%ld", (long)self.sensorData.identifier];
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
        self.sensorData.name = textField.text;
    }
    else if (textField == self.identifierField) {
        NSInteger value = textField.text.integerValue;
        value = MIN(value, 255);
        value = MAX(value, 0);
        self.identifierField.text = [NSString stringWithFormat:@"%ld", (long)value];
        self.sensorData.identifier = value;
    }
    
    self.editingTextField = nil;
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
