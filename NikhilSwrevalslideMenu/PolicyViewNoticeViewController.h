//
//  PolicyViewNoticeViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sunny Gupta on 28/10/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PolicyViewNoticeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *backButton;

- (IBAction)BackButtonAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIWebView *myWebView;


@end
