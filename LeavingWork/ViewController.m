//
//  ViewController.m
//  LeavingWork
//
//  Created by George Strajan on 7/30/14.
//  Copyright (c) 2014 GS Industries LLC. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>


@interface ViewController ()

@end

@implementation ViewController

const double defaultRegionRaduisMeters = 250;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
//     Do any additional setup after loading the view, typically from a nib.
}

- (void)setupView {
// Create Add button

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCurrentLocation:)];
    
    // Create Edit Button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editTableView:)];

    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {

    return self.geofences ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.geofences count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CLRegion* geofence = [self.geofences objectAtIndex:[indexPath row]];
    CLCircularRegion* circularRegion = (CLCircularRegion*)geofence;
    CLLocationCoordinate2D center = circularRegion.center;
    NSString* text = [NSString stringWithFormat:@"%.5f | %.5f", center.latitude, center.longitude];
    
    NSString* cellIdentifer = @"GeofenceCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    [cell.textLabel setText:text];
    [cell.detailTextLabel setText:circularRegion.identifier];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRUE;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return FALSE;
}

- (void) addCurrentLocation:(id)sender {
    _didStartMonitoringRegion = FALSE;
    
    [self.locationManager requestAlwaysAuthorization];
    
    // we have permissions, start updating location
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status != kCLAuthorizationStatusAuthorized)
    {
        // we did not receive authorization from the user that we can use location services ...
        [self showLocationServicesNotEnabledError];
        return;
    }
}

- (void)showLocationServicesNotEnabledError {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Location services"
                                                         message:@"Please enable location services for the app to work"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (locations && [locations count] && !_didStartMonitoringRegion) {
        _didStartMonitoringRegion = TRUE;
        
        CLLocation* location = locations[0];
        
        CLCircularRegion* circularRegion = [[CLCircularRegion alloc] initWithCenter:[location coordinate] radius:defaultRegionRaduisMeters identifier:[[NSUUID UUID] UUIDString]];
        
        // Start monitoring region
        [self.locationManager startMonitoringForRegion:circularRegion];
        [self.locationManager stopUpdatingLocation];
        
        // Update Table View
        [self.geofences addObject:circularRegion];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:([self.geofences count] - 1) inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self updateView];
        
    }
}

- (void) updateView {
    if (![self.geofences count]) {
        // no geofences defined
        [self.tableView setEditing:false animated:true];
        [self.navigationItem.rightBarButtonItem setEnabled:FALSE];
        [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"Edit", nil)];
    } else {
        // there are geofences, enable the edit button
        [self.navigationItem.rightBarButtonItem setEnabled:true];
    }
    
    // Update Add Button
    if ([self.geofences count] < 20) {
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    CLCircularRegion* cirucularRegion = (CLCircularRegion*)region;
    NSString* text = [NSString stringWithFormat:@"Exited region %.5f | %.5f", cirucularRegion.center.latitude, cirucularRegion.center.longitude];
    
    PFObject *testObject = [PFObject objectWithClassName:@"didExitRegionObject"];
    testObject[@"text"] = text;
    [testObject saveInBackground];
    
    [PFCloud callFunctionInBackground:@"SendEmail"
                                withParameters:@{@"text": text, @"subject": @"Left area notification"}
                                block:^(NSNumber* id, NSError *error) {
                                    if (error) {
                                        // TODO Somehow notify user that the email could not be sent
                                    }
                                }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    // Initialize location manager
    self.locationManager = [[CLLocationManager alloc] init];
    
    // Configure location manager
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    // Load geofences
    self.geofences = [NSMutableArray arrayWithArray:[[self.locationManager monitoredRegions] allObjects]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
