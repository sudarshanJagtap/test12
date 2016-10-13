//
//  ViewOrderTableViewCell.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 9/6/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subCatNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *custStringLbl;
@property (weak, nonatomic) IBOutlet UILabel *dishPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *quantityLbl;
@property (weak, nonatomic) IBOutlet UILabel *dishTotalLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *custStrnghghtConstant;

@end

@interface viewOrderCustomView : UIView

@end