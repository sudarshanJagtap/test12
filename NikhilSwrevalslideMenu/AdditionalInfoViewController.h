//
//  AdditionalInfoViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 9/26/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdditionalInfoViewController : UIViewController
@property(nonatomic,strong)NSString *restID;
@property (weak, nonatomic) IBOutlet UILabel *timingLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timingHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *mobileLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mobileHeightConstraint;
@end
