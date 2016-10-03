//
//  DisplayRatingsViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 9/27/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
@interface DisplayRatingsViewController : UIViewController
@property(nonatomic,strong)NSString *restID;
@property(nonatomic,strong)NSString *restName;
@property (weak, nonatomic) IBOutlet RateView *globalRatingView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLbl;
@property (weak, nonatomic) IBOutlet UILabel *RestTitleLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableVw;
@end
