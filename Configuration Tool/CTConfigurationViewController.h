//
//  CTConfigurationViewController.h
//  Configuration Tool
//
//  Created by Jon on 7/2/14.
//  Copyright (c) 2014 Modeo Vehicles LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTConfigurationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex;

@end
