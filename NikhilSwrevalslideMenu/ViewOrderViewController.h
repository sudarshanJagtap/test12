//
//  ViewOrderViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 9/6/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewOrderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableVw;
@property (weak, nonatomic) IBOutlet UILabel *asubTotal;
@property (weak, nonatomic) IBOutlet UILabel *asalesTax;
@property (weak, nonatomic) IBOutlet UILabel *aDeliveryFee;
@property (weak, nonatomic) IBOutlet UILabel *aTotal;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@property(nonatomic,strong)NSString *orderID;
@end
