//
//  AppDelegate.m
//  Backup to OneDrive
//
//  Created by George Strajan on 10/28/14.
//  Copyright (c) 2014 George Strajan. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginWindow.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong) LoginWindow *loginWindow;


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (IBAction)Login:(id)sender {

    self.loginWindow = [[LoginWindow alloc] initWithWindowNibName:@"LoginWindow"];
    [self.loginWindow showWindow:self];

}
@end
