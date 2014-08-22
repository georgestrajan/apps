//
//  ViewController.h
//  LeavingWork
//
//  Created by George Strajan on 7/30/14.
//  Copyright (c) 2014 GS Industries LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface ViewController : UITableViewController<CLLocationManagerDelegate> {
    BOOL _didStartMonitoringRegion;
    
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *geofences;

@end

