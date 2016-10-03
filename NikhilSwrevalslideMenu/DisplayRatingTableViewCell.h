//
//  DisplayRatingTableViewCell.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 9/27/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
@interface DisplayRatingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet RateView *ratingsVw;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *initialLbl;

@property (weak, nonatomic) IBOutlet UILabel *commentLbl;
@end
