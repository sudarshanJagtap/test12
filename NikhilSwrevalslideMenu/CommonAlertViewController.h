//
//  CommonAlertViewController.h
//  Suvidhaa
//
//  Created by Krishnakumar C on 21/12/2014.
//  Copyright (c) 2014 Mindgate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIAlertView.h>

@interface CommonAlertViewController : NSObject <UIAlertViewDelegate>

+(void)showAlertDialogueWithMessage:(NSString *)message andTitle:(NSString *)title fromController:(id)controller;

-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

-(void)showInView:(UIView *)view withCompletionHandler:(void(^)(NSString *buttonTitle, NSInteger buttonIndex))handler;

@end
