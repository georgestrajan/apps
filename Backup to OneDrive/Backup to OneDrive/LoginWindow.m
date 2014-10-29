//
//  LoginWindow.m
//  Backup to OneDrive
//
//  Created by George Strajan on 10/28/14.
//  Copyright (c) 2014 George Strajan. All rights reserved.
//

#import "LoginWindow.h"

@interface LoginWindow ()

@property (strong) IBOutlet WebView *LoginWebView;
@end

@implementation LoginWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // get an authorization token
    self.LoginWebView.frameLoadDelegate = self;
    [self.LoginWebView setShouldCloseWithWindow:false];
    [self.LoginWebView setMainFrameURL:@"https://login.live.com/oauth20_authorize.srf?client_id=0000000040132697&scope=wl.signin%20wl.basic%20wl.offline_access&response_type=code&display=touch&redirect_uri=https%3A%2F%2Flogin.live.com%2Foauth20_desktop.srf"];

}

-(void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    //Did finish Load
    NSString* newUrl = [self.LoginWebView mainFrameURL];
    
    // TODO Check that the newUrl contains an authorization code, the user might have clicked No
    
    NSString* codeString = @"code=";
    NSRange rangeOfCode = [newUrl rangeOfString:codeString];
    
    if (rangeOfCode.length > 0)
    {
        
        // the new URL is something like https://login.live.com/oauth20_desktop.srf?code=65b05872-997d-dc6e-9ede-465ba212b88c&lc=1033
        
        NSString* authCode = [newUrl substringFromIndex:NSMaxRange(rangeOfCode)];
        NSRange rangeOfOtherParams = [authCode rangeOfString:@"&"];
        if (rangeOfOtherParams.location != NSNotFound)
        {
            authCode = [authCode substringToIndex:rangeOfOtherParams.location];
        }
    }
    
    
}

@end
