//
//  CTConfigurationViewController.m
//  Configuration Tool
//
//  Created by Jon on 7/2/14.
//  Copyright (c) 2014 Modeo Vehicles LLC. All rights reserved.
//

#import "CTConfigurationViewController.h"
#import "CTEditPropertyViewController.h"
#import "CTEditSensorViewController.h"

@interface CTConfigurationViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *connectButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

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
    [self performSelector:@selector(connectToBike) withObject:nil afterDelay:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bikeDidDisconnect:) name:kNotificationBikeDidDisconnect object:nil];
}

- (void)bikeDidDisconnect:(NSNotification *)notification {
    [self connectToBike];
}

- (void)connectToBike {
    [[MFBike sharedInstance] connectWithTimeout:999999 andCallback:^(NSError *error) {
        if (error) {
            NSLog(@"Error connecting: %@", error.localizedDescription);
        }
        else {
            NSLog(@"Connected!");
        }
    }];
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
    return [self configurationArrayForIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = indexPath.section == 0 ? @"propertyCell" : @"sensorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSArray *arrayForSection = [self configurationArrayForIndexPath:indexPath];
    MFConfigurationData *configurationData = [arrayForSection objectAtIndex:indexPath.row];
    cell.textLabel.text = configurationData.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)configurationData.identifier];
    return cell;
}

- (NSArray *)configurationArrayForIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? self.configuration.properties : self.configuration.sensors;
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
        viewController.propertyConfiguration = [self.configuration.properties objectAtIndex:row];
    }
    else if ([segue.destinationViewController isKindOfClass:[CTEditSensorViewController class]]) {
        CTEditSensorViewController *viewController = (CTEditSensorViewController *)segue.destinationViewController;
        viewController.sensorData = [self.configuration.sensors objectAtIndex:row];
    }
}

- (IBAction)userDidTapPlus:(UIBarButtonItem *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create New" message:@"What would you like to create?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Property", @"Sensor", nil];
    [alert show];
}

- (IBAction)userDidTapUpload:(UIBarButtonItem *)sender {
    sender.enabled = NO;
    
    NSDate *timestamp = [NSDate date];
    
    MFBikeConfiguration *bikeConfig = [[MFBikeConfiguration alloc] initWithProperties:self.configuration.properties sensors:self.configuration.sensors name:@"Snoop" identifier:nil];
    [[MFBike sharedInstance] uploadConfiguration:bikeConfig withCallback:^(NSError *error) {
        if (!error) {
            NSLog(@"Transfer Time: %f", [timestamp timeIntervalSinceNow]);
        }
        else {
            NSLog(@"failure: %@", error.localizedDescription);
        }
        
        sender.enabled = YES;
    }];
}

- (IBAction)userDidTapSave:(UIBarButtonItem *)sender {
    
    NSMutableArray *properties = [NSMutableArray new];
    for (MFPropertyConfigurationData *property in self.configuration.properties) {
        [properties addObject:property.toDictionary];
    }
    
    NSMutableArray *sensors = [NSMutableArray new];
    for (MFPropertyConfigurationData *sensor in self.configuration.sensors) {
        [sensors addObject:sensor.toDictionary];
    }
    
    PFObject *parseObject = [[PFObject alloc] initWithClassName:@"Configuration"];
    [parseObject setObject:self.configuration.name forKey:@"name"];
    [parseObject setObject:[NSNumber numberWithInteger:self.configuration.numProperties] forKey:@"numProperties"];
    [parseObject setObject:[NSNumber numberWithInteger:self.configuration.numSensors] forKey:@"numSensors"];
    [parseObject setObject:properties forKey:@"properties"];
    [parseObject setObject:sensors forKey:@"sensors"];
    
    [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            NSLog(@"Saved!");
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSMutableArray *properties = [NSMutableArray arrayWithArray:self.configuration.properties];
    NSMutableArray *sensors = [NSMutableArray arrayWithArray:self.configuration.sensors];
    
    if (buttonIndex == 1) {
        MFPropertyConfigurationData *propertyData = [MFPropertyConfigurationData new];
        propertyData.name = [NSString stringWithFormat:@"New Property %lu", properties.count + 1];
        [properties addObject:propertyData];
    }
    else if (buttonIndex == 2) {
        MFSensorConfigurationData *sensorData = [MFSensorConfigurationData new];
        sensorData.name = [NSString stringWithFormat:@"New Sensor %lu", sensors.count + 1];
        [sensors addObject:sensorData];
    }
    
    self.configuration = [[MFBikeConfiguration alloc] initWithProperties:properties sensors:sensors name:self.configuration.name identifier:nil];
    
    [self.tableView reloadData];
}

@end
