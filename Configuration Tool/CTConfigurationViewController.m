//
//  CTConfigurationViewController.m
//  Configuration Tool
//
//  Created by Jon on 7/2/14.
//  Copyright (c) 2014 Modeo Vehicles LLC. All rights reserved.
//

#import "CTConfigurationViewController.h"
#import "CTEditPropertyViewController.h"
#import "CTPropertyData.h"
#import "CTEditSensorViewController.h"
#import "CTSensorData.h"

@interface CTConfigurationViewController ()

@property (strong, nonatomic) NSMutableArray *properties;
@property (strong, nonatomic) NSMutableArray *sensors;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CTConfigurationViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tableView.indexPathForSelectedRow) {
        [self.tableView reloadRowsAtIndexPaths:@[self.tableView.indexPathForSelectedRow] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"Properties" : @"Sensors";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.properties.count : self.sensors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = indexPath.section == 0 ? @"propertyCell" : @"sensorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSArray *arrayForSection = indexPath.section == 0 ? self.properties : self.sensors;
    CTConfigurationData *configurationData = [arrayForSection objectAtIndex:indexPath.row];
    cell.textLabel.text = configurationData.name;
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSInteger row = self.tableView.indexPathForSelectedRow.row;
    if ([segue.destinationViewController isKindOfClass:[CTEditPropertyViewController class]]) {
        CTEditPropertyViewController *viewController = (CTEditPropertyViewController *)segue.destinationViewController;
        viewController.propertyData = [self.properties objectAtIndex:row];
    }
    else if ([segue.destinationViewController isKindOfClass:[CTEditSensorViewController class]]) {
        CTEditSensorViewController *viewController = (CTEditSensorViewController *)segue.destinationViewController;
        viewController.sensorData = [self.sensors objectAtIndex:row];
    }
}

- (IBAction)userDidTapPlus:(UIBarButtonItem *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create New" message:@"What would you like to create?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Property", @"Sensor", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        CTPropertyData *propertyData = [CTPropertyData new];
        propertyData.name = [NSString stringWithFormat:@"New Property %lu", self.properties.count + 1];
        [self.properties addObject:propertyData];
    }
    else if (buttonIndex == 2) {
        CTSensorData *sensorData = [CTSensorData new];
        sensorData.name = [NSString stringWithFormat:@"New Sensor %lu", self.sensors.count + 1];
        [self.sensors addObject:sensorData];
    }
    
    [self.tableView reloadData];
}

- (NSMutableArray *)properties {
    if (!_properties) {
        _properties = [NSMutableArray new];
    }
    return _properties;
}

- (NSMutableArray *)sensors {
    if (!_sensors) {
        _sensors = [NSMutableArray new];
    }
    return _sensors;
}

@end
