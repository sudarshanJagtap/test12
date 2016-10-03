//
//  LocationViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Nikhil Boriwale on 11/07/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LocationViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
- (IBAction)btnFindFood:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtEntAddressCityState;

@end
