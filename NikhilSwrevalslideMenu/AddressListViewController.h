//
//  AddressListViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/31/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressListViewController : UIViewController
- (IBAction)backNavBtnClick:(id)sender;
- (IBAction)addAddressBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *addressTableView;

@end
