//
//  CustomizeOptionTableViewCell.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/27/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomizeOptionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgVw;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@end
