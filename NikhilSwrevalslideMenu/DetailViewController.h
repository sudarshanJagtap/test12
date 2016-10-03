//
//  DetailViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/23/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
#import "AsyncImageView.h"
#import "RateView.h"
#import "ResponseUtility.h"
@interface DetailViewController : UIViewController<SKSTableViewDelegate>
//@property(nonatomic,strong)NSString *cuisineTxt;
//@property(nonatomic,assign)float ratingTxt;
//@property(nonatomic,strong)NSString *minOrderTxt;
//@property(nonatomic,strong)NSString *DeliveryText;
//@property(nonatomic,strong)NSString *cid,*imgUrl, *cuisineName,*pass_rest_id;
@property (weak, nonatomic) IBOutlet SKSTableView *tableVw;
@property (weak, nonatomic) IBOutlet UILabel *deliveryLbl;
@property (weak, nonatomic) IBOutlet UILabel *waitTimeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgVw;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *minOrderLbl;
@property (strong, nonatomic)NSMutableArray *contents;
@property (weak, nonatomic) IBOutlet UIView *opaqueView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageVw;
@property (weak, nonatomic) IBOutlet RateView *ratingsView;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet UIButton *backBtnClick;
@property (nonatomic,strong)UserFiltersResponse *selectedUfrespo;
- (IBAction)menuBtnClick:(id)sender;
- (IBAction)navBackBtnClk:(id)sender;
@end
