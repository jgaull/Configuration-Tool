//
//  CTConfigurationsListViewController.m
//  Configuration Tool
//
//  Created by Jon on 7/5/14.
//  Copyright (c) 2014 Modeo Vehicles LLC. All rights reserved.
//

#import "CTConfigurationsListViewController.h"
#import "CTConfigurationViewController.h"
#import "MFBikeConfiguration+CTBikeConfigurationUtils.h"

@interface CTConfigurationsListViewController ()

@end

@implementation CTConfigurationsListViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.parseClassName = @"Configuration";
        self.textKey = @"versionNumber";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"versionCell";
    
    PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.textLabel.text = [object objectForKey:self.textKey];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[CTConfigurationViewController class]]) {
        
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        PFObject *object = [self objectAtIndexPath:indexPath];
        MFBikeConfiguration *configuration = [MFBikeConfiguration bikeConfigurationWithPFObject:object];
        
        CTConfigurationViewController *viewController = (CTConfigurationViewController *)segue.destinationViewController;
        viewController.configuration = configuration;
    }
}

- (PFQuery *)queryForTable {
    return [super queryForTable];
}

@end
