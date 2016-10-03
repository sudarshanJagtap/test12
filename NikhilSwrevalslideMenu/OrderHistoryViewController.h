//
//  OrderHistoryViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 9/2/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHistoryViewController : UIViewController
- (IBAction)navBackBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableVw;

@end
