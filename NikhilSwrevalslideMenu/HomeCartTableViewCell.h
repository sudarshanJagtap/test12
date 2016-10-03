//
//  HomeCartTableViewCell.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 8/28/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface HomeCartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet AsyncImageView *imgVw;
@property (weak, nonatomic) IBOutlet UILabel *restName;
@property (weak, nonatomic) IBOutlet UILabel *noOfProds;
@property (weak, nonatomic) IBOutlet UILabel *orderType;
@property (weak, nonatomic) IBOutlet UIButton *goToResoBtn;
@property (weak, nonatomic) IBOutlet UIButton *emptyCartBtn;

@end
