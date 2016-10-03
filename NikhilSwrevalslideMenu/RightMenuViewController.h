//
//  RightMenuViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sunny Gupta on 16/07/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@protocol RightMenuViewControllerDelegate <NSObject>

@required
-(void)delegateDelivery;

@end

@interface RightMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
- (IBAction)segmentClicked:(id)sender;
@property (weak, nonatomic) IBOutlet RateView *ratingsView;
@property (weak, nonatomic) IBOutlet RateView *dollarView;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIView *moreFiltersView;
@property (strong, nonatomic) IBOutlet UITableView *tblViewIteam;
@property (strong,nonatomic)id<RightMenuViewControllerDelegate> rmdelegate;
@property (strong, nonatomic) NSArray *arrayiteam;
@property (weak, nonatomic) IBOutlet UILabel *asapLbl;
@property (weak, nonatomic) IBOutlet UIButton *asapChkBx;
@property (weak, nonatomic) IBOutlet UILabel *asapDisplayLbl;
@property (weak, nonatomic) IBOutlet UIView *pickerMainView;
@property (weak, nonatomic) IBOutlet UIButton *prevBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)prevBtnClick:(id)sender;
- (IBAction)nextBtnClick:(id)sender;
- (IBAction)doneBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *dateDisplayLbl;

@property (weak, nonatomic) IBOutlet UIDatePicker *DatetimePicker;

@end
