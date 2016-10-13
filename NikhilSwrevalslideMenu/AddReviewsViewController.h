//
//  AddReviewsViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 10/5/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
#import "RequestUtility.h"
@interface AddReviewsViewController : UIViewController
@property (weak, nonatomic) IBOutlet RateView *qualityOfFoodRW;
@property (weak, nonatomic) IBOutlet RateView *cleanlinessRW;
@property (weak, nonatomic) IBOutlet RateView *tasteRW;
@property(nonatomic,strong)USerOrderHistory *uData;
@property(nonatomic,strong)NSString *userId;
@property (weak, nonatomic) IBOutlet UITextView *titleTxtView;
@property (weak, nonatomic) IBOutlet UITextView *commentTxtVw;

@end
