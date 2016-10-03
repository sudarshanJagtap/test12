//
//  AddressListTableViewCell.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 8/1/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fullNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *address1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *address2Lbl;
@property (weak, nonatomic) IBOutlet UILabel *contactNoLbl;
@property (weak, nonatomic) IBOutlet UILabel *cityLbl;
@property (weak, nonatomic) IBOutlet UILabel *zipCodeLbl;
@property (weak, nonatomic) IBOutlet UILabel *stateLbl;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *countryLbl;
@end
