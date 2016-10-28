//
//  AboutUsViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 9/2/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *policyButton;
@property (strong, nonatomic) IBOutlet UIButton *leaderShipButton;
@property (strong, nonatomic) IBOutlet UIButton *investOppurtunity;
- (IBAction)privacyAction:(id)sender;
- (IBAction)leaderShipAction:(id)sender;
- (IBAction)investOppturnity:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *textViewContent;

@end
