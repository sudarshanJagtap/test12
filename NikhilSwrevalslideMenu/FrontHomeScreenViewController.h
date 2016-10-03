//
//  FrontHomeScreenViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Nikhil Boriwale on 11/07/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrontHomeScreenTableViewCell.h"
#import "Cartoon.h"
#import "DownPicker.h"
#import "RateView.h"
@interface FrontHomeScreenViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray * arr;
    NSOperationQueue * queue ;
  
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblHghtConstraint;
@property (weak, nonatomic) IBOutlet UILabel *addedFilterLabel;
@property (strong, nonatomic) NSMutableArray *array;
@property (nonatomic, strong)FrontHomeScreenTableViewCell * TableNew;
@property (weak, nonatomic) IBOutlet UIButton *BarButton;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *btnPickup;
//@property (strong, nonatomic) IBOutlet UIButton *btnAsop;
@property (strong, nonatomic) IBOutlet UIButton *btnSort;
@property (strong, nonatomic) IBOutlet UIButton *btnDelivery;
@property (strong, nonatomic) DownPicker *downPicker;
@property (strong, nonatomic) IBOutlet UITextField *dropdown;
- (IBAction)btnpickup:(id)sender;
- (IBAction)btndelivery:(id)sender;
- (IBAction)btnRightMenu:(id)sender;
- (IBAction)btnSearchMenu:(id)sender;
- (IBAction)btnsort:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIView *searchArea;

@property (weak, nonatomic) IBOutlet UITextField *searchTxtFld;
- (IBAction)searchBackBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *resetFiltersView;
- (IBAction)resetFiltersCancelBtnClick:(id)sender;
- (IBAction)resetFiltersResetBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *resetFilterMsgLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressBtn;

@end
