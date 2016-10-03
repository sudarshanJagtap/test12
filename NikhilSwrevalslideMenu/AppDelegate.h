//
//  AppDelegate.h
//  NikhilSwrevalslideMenu
//
//  Created by Nikhil Boriwale on 11/07/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGViewHUD.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) LGViewHUD *hudView;
-(void)showLoadingViewWithString:(NSString *)str;
-(void)hideLoadingView;



@end

