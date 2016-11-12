//
//  VantivPaymentWebViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 11/13/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VantivPaymentWebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *vantivWebView;
@property(nonatomic,strong)NSString *urlStr;
@property(nonatomic,strong)NSMutableDictionary *bfPaymentDictionary;
@end
