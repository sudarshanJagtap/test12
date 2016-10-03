//
//  CommonAlertViewController.m
//  Suvidhaa
//
//  Created by Krishnakumar C on 21/12/2014.
//  Copyright (c) 2014 Mindgate. All rights reserved.
//

#import "CommonAlertViewController.h"
#import <UIKit/UIViewController.h>
#import "Constant.h"

@interface CommonAlertViewController()

@property (nonatomic, strong) UIAlertView *actionAlert;

@property (nonatomic, strong) void(^completionHandler)(NSString *, NSInteger);

@end



@implementation CommonAlertViewController
#pragma mark - Show Alert Dialogue with message

+(void)showAlertDialogueWithMessage:(NSString *)message andTitle:(NSString *)title fromController:(id)controller;
{
   
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

	
}

-(id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...  {
    
    self = [super init];
    if (self) {
        
        _actionAlert   = [[UIAlertView alloc] initWithTitle:title
                                                    message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        
        
        va_list arguments;
        va_start(arguments, otherButtonTitles);
        NSString *currentButtonTitle = otherButtonTitles;
        while (currentButtonTitle != nil) {
            [_actionAlert addButtonWithTitle:currentButtonTitle];
            currentButtonTitle = va_arg(arguments, NSString *);
        }
        va_end(arguments);
        
        [_actionAlert addButtonWithTitle:cancelButtonTitle];
        
        [_actionAlert setCancelButtonIndex:_actionAlert.numberOfButtons - 1];
        
    }
    
    return self;
}

- (void)showInView:(UIView *)view withCompletionHandler:(void (^)(NSString *, NSInteger))handler
{
    _completionHandler = handler;
    
    [_actionAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [_actionAlert buttonTitleAtIndex:buttonIndex];
    _completionHandler(title, buttonIndex);
}

@end
