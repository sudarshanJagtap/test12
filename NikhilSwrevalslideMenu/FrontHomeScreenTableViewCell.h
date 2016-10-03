//
//  FrontHomeScreenTableViewCell.h
//  NikhilSwrevalslideMenu
//
//  Created by Nikhil Boriwale on 13/07/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "RateView.h"
@interface FrontHomeScreenTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet AsyncImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblCuisinString;
@property (strong, nonatomic) IBOutlet UILabel *lblOrder;
@property (strong, nonatomic) IBOutlet UILabel *lblFee;
@property (weak, nonatomic) IBOutlet UILabel *lblRating;
@property (strong, nonatomic) IBOutlet UILabel *lbldeliveritime;
@property (weak, nonatomic) IBOutlet RateView *dollarView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIImageView *imgDollarVw;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelOrderHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cuisineStringHeightConstraint;

@end
