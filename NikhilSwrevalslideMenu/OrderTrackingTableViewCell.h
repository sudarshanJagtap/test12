//
//  OrderTrackingTableViewCell.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 9/2/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTrackingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalAmtLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *deliveryDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *isDeliverdLbl;
@property (weak, nonatomic) IBOutlet UIButton *orderDetailsBtn;

@end
