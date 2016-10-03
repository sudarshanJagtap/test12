//
//  AppDelegate.m
//  NikhilSwrevalslideMenu
//
//  Created by Nikhil Boriwale on 11/07/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "AppDelegate.h"
#import "Constant.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PayPalMobile.h"
#import <Google/SignIn.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
@import GooglePlaces;
@interface AppDelegate ()<UIApplicationDelegate, GIDSignInDelegate>

@end

@implementation AppDelegate
@synthesize hudView;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSString *googlePlacePIKEY = @"AIzaSyB3N4VlBeevnXyZWS33R5yaFJb2mCcfc1s";
  [GMSPlacesClient provideAPIKey:googlePlacePIKEY];
  [Fabric with:@[[Twitter class]]];
  [[FBSDKApplicationDelegate sharedInstance] application:application
                           didFinishLaunchingWithOptions:launchOptions];
  // Add any custom logic here.
  [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"YOUR_CLIENT_ID_FOR_PRODUCTION",
                                                         PayPalEnvironmentSandbox : @"ASGLkX28ypnHeOc26Z9AS2i8ozJyYaEobRW8ZGFjWfcVzK62JHkqgRBYHzP99SRcf7aRhrL459SGVyAX"}];
  NSError* configureError;
  [[GGLContext sharedInstance] configureWithError: &configureError];
  NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
  
  [GIDSignIn sharedInstance].delegate = self;
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//show progress bar......
-(void)showLoadingViewWithString:(NSString *)str {
  hudView = [[LGViewHUD alloc]initWithFrame:CGRectMake(self.window.frame.size.width/2-(customWidth/2), self.window.frame.size.height/2-(customWidth/2), customWidth, customWidth)];
  hudView.bottomText = str;
  [hudView setActivityIndicatorOn:YES];
  [self.window endEditing:YES];
  [hudView showInView:self.window withAnimation:HUDAnimationShowZoom];
  [self.window bringSubviewToFront:hudView];
  [self.window setUserInteractionEnabled:NO];
  
}

//show progress bar ....
-(void)hideLoadingView {
  [self.window endEditing:NO];
  [hudView hideWithAnimation:HUDAnimationHideFadeOut];
  [self.window setUserInteractionEnabled:YES];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  
  
  if ([[url scheme] isEqualToString:@"fb1048169528571102"]) {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
  }
  else{
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
  }
  return YES;
  
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
  if ([[url scheme] isEqualToString:@"fb1048169528571102"]) {
    return [[FBSDKApplicationDelegate sharedInstance]application:app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
  }else{
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
  }
  return YES;
}


@end
