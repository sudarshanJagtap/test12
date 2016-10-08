//
//  CartViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/30/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "CartViewController.h"
#import "CartTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "DBManager.h"
#import "AppDelegate.h"
#import "RequestUtility.h"
#import "DetailTableViewCell.h"
#import "CuisineDetailOperation.h"
#import "CustomizeOptionTableViewCell.h"
#import "SignUpLoginViewController.h"
#import "Utility.h"
#import "ResponseUtility.h"
#import "BillSummaryViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#define kOFFSET_FOR_KEYBOARD 80.0

@interface CartViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>{
  NSString *textStr;
  NSMutableArray *tableArray;
  float totalprice;
  float ppPrice;
  UITableView *ppTableView;
  UIScrollView* coverView;
  UIView *popUpView;
  UIView *popVw;
  NSMutableArray *selectedCustomCuisineStringArray,*selectedCustomCuisinePriceArray,*selectedCustomCuisineIdArray;
  UILabel *lbl4;
  NSMutableArray *sectionArray;
  AppDelegate *appDelegate;
  CuisineDetailOperation *cdOperation;
  NSMutableDictionary *responseDict;
  NSInteger selectedPopUpIndex;
  NSMutableArray *globalCartArray;
  
  //values to be passed.
  NSString *subTotalPassed;
  NSString *salesTaxPassed;
  NSString *deliveryFeePassed;
  NSString *totalAmountPassed;
  
  NSInteger uuID;
  NSString *userId;
  NSMutableDictionary *beforePaymentDictionary;
  NSMutableArray *temporayUniqueID;
  UITextView *myTextView;

}

@end

@implementation CartViewController
@synthesize selectedRestName,selectedUfrespo;
- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationController.navigationBarHidden = YES;
}

//-(void)getDisplayCartData{
//    [appDelegate showLoadingViewWithString:@"Loading..."];
//    RequestUtility *utility = [RequestUtility sharedRequestUtility];
//    NSString *url = @"http://ymoc.mobisofttech.co.in/android_api/display_cart.php";
//  NSMutableDictionary *dictioanry = [[NSMutableDictionary alloc]init];
//  [dictioanry setValue:userId forKey:@"user_id"];
//  [dictioanry setValue:selectedUfrespo.ufp_id forKey:@"restaurant_id"];
//  [dictioanry setValue:@"1" forKey:@"order_mode"];
//  [dictioanry setValue:@"0" forKey:@"order_schedule_status"];
//  [dictioanry setValue:@"00-00-00" forKey:@"order_schedule_date"];
//  [dictioanry setValue:@"000:00" forKey:@"order_schedule_time"];
//  [dictioanry setValue:@"display_cart" forKey:@"action"];
//
//  [utility doYMOCPostRequestfor:url withParameters:dictioanry onComplete:^(bool status, NSDictionary *responseDictionary){
//    if (status) {
//      NSLog(@"response:%@",responseDictionary);
//
//      dispatch_async(dispatch_get_main_queue(), ^(){
//        //Add method, task you want perform on mainQueue
//        //Control UIView, IBOutlet all here
//        [self parseDisplayCartData:responseDictionary];
//        [appDelegate hideLoadingView];
//      });
//    }else{
//      [appDelegate hideLoadingView];
//    }
//  }];
//
//}
//
//-(void)parseDisplayCartData:(NSDictionary*)response{
//  NSMutableArray *displayCartAraay = [[NSMutableArray alloc]init];
//  if ([[response valueForKey:@"code"] isEqualToString:@"1"]) {
//    NSLog(@"success");
//    NSDictionary *dict = [response valueForKey:@"data"];
//    NSArray *cart = [dict valueForKey:@"cart_data"];
//    for (int i =0; i<cart.count; i++) {
//      USerSelectedCartData *data = [[USerSelectedCartData alloc]init];
//      NSDictionary *respo = [cart objectAtIndex:i];
//      data.ordertype = [dict valueForKey:@"order_mode"];
//      data.order_schedule_date = [dict valueForKey:@"order_schedule_date"];
//      data.order_schedule_status = [dict valueForKey:@"order_schedule_status"];
//      data.order_schedule_time = [dict valueForKey:@"order_schedule_time"];
//      data.restaurant_Id = [[dict valueForKey:@"restaurant_id"] integerValue];
//        data.obtainedCartID = [respo valueForKey:@"cart_id"];
//        data.instructions = [respo valueForKey:@"instructions"];
//        data.quantity = [respo valueForKey:@"quantity"];
//        data.sub_category_Name = [respo valueForKey:@"sub_category"];
//        data.subCategory_Id = [[respo valueForKey:@"sub_category_id"] integerValue];
//        float Price = [[respo valueForKey:@"price"] floatValue];
//
//      NSArray *customization = [respo valueForKey:@"customization"];
//
//      NSMutableArray *custIDArray = [[NSMutableArray alloc]init];
//      NSMutableArray *cust_optionArray = [[NSMutableArray alloc]init];
//      NSMutableArray *cust_priceArray = [[NSMutableArray alloc]init];
//      if ([[respo valueForKey:@"customization"] isKindOfClass:[NSArray class]]) {
//      for (int i =0; i<customization.count; i++) {
//        NSDictionary *cRespo = [customization objectAtIndex:i];
//        NSString *cust_id = [cRespo valueForKey:@"cust_id"];
//        if (cust_id.length>0) {
//          [custIDArray addObject:cust_id];
//        }
//        NSString *cust_option = [cRespo valueForKey:@"cust_option"];
//        if (cust_option.length>0) {
//          [cust_optionArray addObject:cust_option];
//        }
//        NSString *cust_price = [cRespo valueForKey:@"cust_price"];
//        if (cust_price.length>0) {
//          [cust_priceArray addObject:cust_price];
//        }
//      }
//      data.customizedCuisineId = [custIDArray componentsJoinedByString:@"&"];
//      data.customizeCuisineString = [cust_optionArray componentsJoinedByString:@"&"];
//      data.customizeCuisinePrice = [cust_priceArray componentsJoinedByString:@"&"];
//      for (int i =0; i<cust_priceArray.count; i++) {
//        Price = Price+[[cust_priceArray objectAtIndex:i] floatValue];
//      }
//      }
//      data.TotalFinalPrice = Price;
//      [displayCartAraay addObject:data];
//    }
//    tableArray = [[NSMutableArray alloc]init];
//    [tableArray addObjectsFromArray:displayCartAraay];
//    NSArray *dbArray = [[DBManager getSharedInstance] getALlCartData:[selectedUfrespo.ufp_id intValue]];
//    [tableArray addObjectsFromArray:dbArray];
//    [self.tblVw reloadData];
//    int countt = (int)tableArray.count;
//    self.tableHeightConstraint.constant = countt*90;
//    [self calculateAllDetails];
//  }
//
//}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  userId=[userdictionary valueForKey:@"user_id"];
  [self addingValueToCartRequest:[selectedUfrespo.ufp_id integerValue]];
  self.navigationController.navigationBarHidden = YES;
  selectedCustomCuisineStringArray = [[NSMutableArray alloc]init];
  selectedCustomCuisinePriceArray = [[NSMutableArray alloc]init];
  selectedCustomCuisineIdArray = [[NSMutableArray alloc]init];
  NSArray *dbArray = [[DBManager getSharedInstance] getALlCartData:[selectedUfrespo.ufp_id intValue]];
  tableArray  = [[NSMutableArray alloc]init];
  [tableArray removeAllObjects];
  [tableArray addObjectsFromArray:dbArray] ;
  [self.tblVw reloadData];
  int countt = (int)tableArray.count;
  self.tableHeightConstraint.constant = countt*90;
  [self calculateAllDetails];
  if([RequestUtility sharedRequestUtility].delivery_status == 0){
    self.constraintDeliveryFeeHeight.constant=0;
    self.constraintOrderModeHeight.constant=40;
    
  }else{
    self.constraintDeliveryFeeHeight.constant=40;
    self.constraintOrderModeHeight.constant=40;
  }
  if([RequestUtility sharedRequestUtility].isAsap){
    self.orderScheduleLabel.hidden = NO;
    self.orderScheduleDateTimeLabel.hidden = NO;
    Utility *utilityObj = [[Utility alloc]init];
    NSString *dateStr = [NSString stringWithFormat:@"%@ : %@", [utilityObj getCurrentAsapDate],[utilityObj getCurrentTime]];
    self.orderScheduleDateTimeLabel.text = dateStr;
    self.constriantOrderScheduleHeight.constant=40;
  }else{
    self.orderScheduleLabel.hidden = YES;
    self.orderScheduleDateTimeLabel.hidden = YES;
    self.constriantOrderScheduleHeight.constant=40;
      self.constraintHacktop.constant=-30;
  }
  self.cosntraintCouponAmountHeight.constant=0;
//  self.constraintHacktop.constant=-30;
}


-(void)reloadView{
  selectedCustomCuisineStringArray = [[NSMutableArray alloc]init];
  selectedCustomCuisinePriceArray = [[NSMutableArray alloc]init];
  selectedCustomCuisineIdArray = [[NSMutableArray alloc]init];
  NSArray *dbArray = [[DBManager getSharedInstance] getALlCartData:[selectedUfrespo.ufp_id intValue]];
  tableArray  = [[NSMutableArray alloc]init];
  [tableArray removeAllObjects];
  [tableArray addObjectsFromArray:dbArray] ;
  [self.tblVw reloadData];
  int countt = (int)tableArray.count;
  self.tableHeightConstraint.constant = countt*90;
  [self calculateAllDetails];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = YES;
}

-(void)calculateAllDetails{
  NSArray *dbArray = [[DBManager getSharedInstance] getALlCartData:[selectedUfrespo.ufp_id intValue]];
  globalCartArray = [[NSMutableArray alloc]init];
  [globalCartArray addObjectsFromArray:dbArray];
  //  [globalCartArray addObjectsFromArray:tableArray];
  //  [tableArray addObjectsFromArray:dbArray];
  if (tableArray.count>0) {
    if([RequestUtility sharedRequestUtility].delivery_status == 0){
      self.deliveryFeePriceLbl .text = [NSString stringWithFormat:@"$ 0.00"];
    }else{
      self.deliveryFeePriceLbl .text = [NSString stringWithFormat:@"$ %@",selectedUfrespo.fee];
    }
  }else{
    self.deliveryFeePriceLbl .text = [NSString stringWithFormat:@"$ 0.00"];
  }
  self.orderModeLbl .text = [RequestUtility sharedRequestUtility].selectedOrderType;;
  float subtotalAmountcalculated = 0;
  USerSelectedCartData *cart;
  for (int i = 0 ;i<tableArray.count;  i++) {
    cart = (USerSelectedCartData*)[tableArray objectAtIndex:i];
    subtotalAmountcalculated = subtotalAmountcalculated+cart.TotalFinalPrice;
  }
  self.subTotalPriceLbl.text = [NSString stringWithFormat:@"$ %.02f",subtotalAmountcalculated ];
  self.salesTaxPriceLbl .text = [NSString stringWithFormat:@"$ %@",selectedUfrespo.fee];
  //  float ratio = 15/100;
  //  int x = [price.text floatValue];
  //  int y = [units.text floatValue];
  float calc_result = [[ResponseUtility getSharedInstance].salesTaxValue floatValue]/ 100.0;
  
  //  ratio = [[NSString stringWithFormat:@"$ %.02f",ratio ] floatValue];
  float tax = subtotalAmountcalculated *calc_result;
  //200*(15/100)
  self.salesTaxPriceLbl.text = [NSString stringWithFormat:@"$ %.02f",tax ];
  float finalAmount;
  if([RequestUtility sharedRequestUtility].delivery_status == 1){
    finalAmount= subtotalAmountcalculated + tax + [selectedUfrespo.fee floatValue];
  }else{
    finalAmount= subtotalAmountcalculated + tax;
  }
  //  int qAmt = [cart.quantity intValue];
  //  finalAmount = finalAmount*qAmt;
  self.totalPriceLbl.text = [NSString stringWithFormat:@"$ %.02f",finalAmount ];
  
  float amountPending = [selectedUfrespo.min_order_amount floatValue]-subtotalAmountcalculated;
  if (amountPending>0) {
    [self.checkOutBtn setEnabled:NO];
    [self.checkOutBtn setTitle:[NSString stringWithFormat:@"%.2f Should be Added",amountPending] forState:UIControlStateNormal];
  }else{
    [self.checkOutBtn setEnabled:YES];
    [self.checkOutBtn setTitle:[NSString stringWithFormat:@"Proceed to CheckOut"] forState:UIControlStateNormal];
  }
  
  subTotalPassed = [NSString stringWithFormat:@"$ %.02f",subtotalAmountcalculated ];
  salesTaxPassed = [NSString stringWithFormat:@"$ %.02f",tax ];
  deliveryFeePassed = [NSString stringWithFormat:@"$ %@",selectedUfrespo.fee];
  totalAmountPassed = [NSString stringWithFormat:@"$ %.02f",finalAmount];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger retval = 0;
  if (tableView == ppTableView) {
    retval = [ResponseUtility getSharedInstance].CustomizeMenuArray.count;
  }else{
    retval = tableArray.count;
  }
  return retval;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CGFloat retval;
  if (tableView == ppTableView) {
    retval = 35;
  }else{
    retval = 90;
  }
  return retval;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  id retcell;
  if (tableView == ppTableView) {
    static NSString *cellIdentifier = @"CustomizeOptionTableViewCell";
    
    CustomizeOptionTableViewCell *cell = (CustomizeOptionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
      NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomizeOptionTableViewCell" owner:self options:nil];
      cell = [nib objectAtIndex:0];
    }
    
    CustomizationMenu *cmenu =  [[ResponseUtility getSharedInstance].CustomizeMenuArray objectAtIndex:indexPath.row];
    if (![cmenu.cust_option isKindOfClass:[NSNull class]]) {
      cell.titleLbl.text = cmenu.cust_option;
    }else{
      cell.titleLbl.text = @"";
    }
    
    //    cell.titleLbl.textColor = [UIColor redColor];
    cell.titleLbl.textColor =[UIColor colorWithRed:188.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0];
    //     if (cmenu.cust_price!=NULL) {
    cell.priceLbl.text = [NSString stringWithFormat:@"$ %.02f",cmenu.cust_price];
    //     }
    if ([selectedCustomCuisineStringArray containsObject:cmenu.cust_option]) {
      cell.imgVw.image = [UIImage imageNamed:@"checkbox_mark.png"];
    }else{
      cell.imgVw.image = [UIImage imageNamed:@"checkbox_unmark.png"];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleChecking:)];
    [cell addGestureRecognizer:tap];
    cell.userInteractionEnabled = YES;
    
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1)];/// change size as you need.
    separatorLineView.backgroundColor = [UIColor colorWithRed:(196/255.f) green:(196/255.f) blue:(196/255.f) alpha:1.0f];
    [cell.contentView addSubview:separatorLineView];
    UIFont *myFont = [ UIFont fontWithName: @"System Bold" size: 20.0 ];
    cell.textLabel.font  = myFont;
    [cell setIndentationLevel:2];
    cell.backgroundColor = [UIColor colorWithRed:(224/255.f) green:(224/255.f) blue:(224/255.f) alpha:1.0f];
    retcell = cell;
  }else{
    
    static NSString *cellIdentifier = @"CartTableViewCell";
    
    CartTableViewCell *cell = (CartTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
      NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CartTableViewCell" owner:self options:nil];
      cell = [nib objectAtIndex:0];
    }
    
    USerSelectedCartData *cartMenu = (USerSelectedCartData*)[tableArray objectAtIndex:indexPath.row];
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    cell.layer.borderWidth = 0.5;
    cell.quantityLbl.layer.borderColor = [UIColor colorWithRed:40/255.0f green:174/255.0f   blue:156/255.0f alpha:1.0f].CGColor;
    cell.quantityLbl.layer.borderWidth = 1.0;
    cell.editBtn.tag = indexPath.row;
    cell.deleteBtn.tag = indexPath.row;
    cell.plusBtn.tag = indexPath.row;
    cell.minusBtn.tag = indexPath.row;
    cell.quantityLbl.text = cartMenu.quantity;
    cell.nameLbl.text = cartMenu.sub_category_Name;
    cell.detailLbl.text = cartMenu.customizeCuisineString;
    cell.priceLbl.text = [NSString stringWithFormat:@"$ %.2f",cartMenu.TotalFinalPrice];
    [cell.editBtn addTarget:self
                     action:@selector(editMethod:) forControlEvents:UIControlEventTouchDown];
    [cell.deleteBtn addTarget:self
                       action:@selector(deleteMethod:) forControlEvents:UIControlEventTouchDown];
    [cell.plusBtn addTarget:self
                     action:@selector(plusMethod:) forControlEvents:UIControlEventTouchDown];
    [cell.minusBtn addTarget:self
                      action:@selector(minusMethod:) forControlEvents:UIControlEventTouchDown];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    retcell = cell;
  }
  return retcell;
}

- (void) handleChecking:(UITapGestureRecognizer *)tapRecognizer {
  CGPoint tapLocation = [tapRecognizer locationInView:ppTableView];
  NSIndexPath *tappedIndexPath = [ppTableView indexPathForRowAtPoint:tapLocation];
  CustomizationMenu *menu = (CustomizationMenu*)[[ResponseUtility getSharedInstance].CustomizeMenuArray objectAtIndex:tappedIndexPath.row];
  if ([selectedCustomCuisineStringArray containsObject:menu.cust_option]) {
    int index = 0;
    for (int i =0; i<selectedCustomCuisineStringArray.count; i++) {
      NSString *text = [selectedCustomCuisineStringArray objectAtIndex:i];
      if ([text isEqualToString:menu.cust_option]) {
        index = i;
      }
    }
    [selectedCustomCuisineStringArray removeObject:menu.cust_option];
    
    NSString *selectedPrice =[NSString stringWithFormat:@"%@", [selectedCustomCuisinePriceArray objectAtIndex:index]];
    //    totalprice = ppPrice-[selectedPrice floatValue];//menu.cust_price;
    NSString*tp = [[NSString stringWithFormat:@"%@",lbl4.text]substringFromIndex:2];
    totalprice = [tp floatValue];
    totalprice = totalprice-[selectedPrice floatValue];
    //    ppPrice = totalprice;
    [selectedCustomCuisinePriceArray removeObjectAtIndex:index];
    [selectedCustomCuisineIdArray removeObjectAtIndex:index];
    lbl4.text= [NSString stringWithFormat:@"$ %.02f",totalprice ];
  }
  else {
    [selectedCustomCuisineStringArray addObject:menu.cust_option];
    [selectedCustomCuisinePriceArray addObject:[NSString stringWithFormat:@"%f",menu.cust_price]];
    [selectedCustomCuisineIdArray addObject:menu.cust_id];
    //    totalprice = ppPrice+menu.cust_price;
    //    ppPrice = totalprice;
    NSString*tp = [[NSString stringWithFormat:@"%@",lbl4.text]substringFromIndex:2];
    totalprice = [tp floatValue];
    //    totalprice = [lbl4.text floatValue];
    totalprice = totalprice+menu.cust_price;
    lbl4.text= [NSString stringWithFormat:@"$ %.02f",totalprice];
  }
  [ppTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tappedIndexPath] withRowAnimation: UITableViewRowAnimationFade];
  NSLog(@"%@",selectedCustomCuisineStringArray);
}

-(void)editMethod:(UIButton*)sender
{
  
  USerSelectedCartData *cart = (USerSelectedCartData*)[tableArray objectAtIndex:sender.tag];
  selectedPopUpIndex = sender.tag;
  //  [selectedCustomCuisinePriceArray addObject:[NSString stringWithFormat:@"%f",menu.cust_price]];
  [selectedCustomCuisineStringArray removeAllObjects];
  [selectedCustomCuisinePriceArray removeAllObjects];
  [selectedCustomCuisineIdArray removeAllObjects];
  [selectedCustomCuisineStringArray addObjectsFromArray:[cart.customizeCuisineString componentsSeparatedByString:@"&"]];
  [selectedCustomCuisinePriceArray addObjectsFromArray:[cart.customizeCuisinePrice componentsSeparatedByString:@"&"]];
  [selectedCustomCuisineIdArray addObjectsFromArray:[cart.customizedCuisineId componentsSeparatedByString:@"&"]];
  NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
  [dict setValue:@"get_customization_option" forKey:@"action"];
  [dict setValue:[NSString stringWithFormat:@"%ld",(long)cart.restaurant_Id] forKey:@"restaurant_id"];
  [dict setValue:[NSString stringWithFormat:@"%ld",(long)cart.subCategory_Id] forKey:@"sub_category_id"];
  [self getOptionToCustomizedCuisine:dict];
  NSLog(@"edit Clicked a button %ld",(long)sender.tag);
}
-(void)deleteMethod:(UIButton*)sender
{
  USerSelectedCartData *cart = (USerSelectedCartData*)[tableArray objectAtIndex:sender.tag];
  if (userId.length>0) {
    [self deleteCartiwthCartId:cart.serverCartID];
    DBManager *manager = [DBManager getSharedInstance];
    BOOL retval = [manager deleteRecord:(int)cart.unique_id];
    if (retval) {
      NSArray *dbArray = [[DBManager getSharedInstance]getALlCartData:[selectedUfrespo.ufp_id intValue]];
      tableArray  = [[NSMutableArray alloc]init];
      [tableArray addObjectsFromArray:dbArray] ;
      [self.tblVw reloadData];
      [self calculateAllDetails];
      self.tableHeightConstraint.constant = tableArray.count*90;
    }
  }else{
    
    DBManager *manager = [DBManager getSharedInstance];
    BOOL retval = [manager deleteRecord:(int)cart.unique_id];
    if (retval) {
      NSArray *dbArray = [[DBManager getSharedInstance]getALlCartData:[selectedUfrespo.ufp_id intValue]];
      tableArray  = [[NSMutableArray alloc]init];
      [tableArray addObjectsFromArray:dbArray] ;
      [self.tblVw reloadData];
      [self calculateAllDetails];
      self.tableHeightConstraint.constant = tableArray.count*90;
    }
  }
  
  NSLog(@"deleted Clicked a button %ld",(long)sender.tag);
}

-(void)plusMethod:(UIButton*)sender
{
  USerSelectedCartData *cartMenu = (USerSelectedCartData*)[tableArray objectAtIndex:sender.tag];
  int quanti = [[NSString stringWithFormat:@"%@",cartMenu.quantity] intValue];
  quanti++;
  float CostofCustomize = 0;
  NSArray*priceArray = [cartMenu.customizeCuisinePrice componentsSeparatedByString:@"&"];
  for (int i =0; i<priceArray.count; i++) {
    CostofCustomize = CostofCustomize+[[priceArray objectAtIndex:i] floatValue];
  }
  float costofOne = cartMenu.subCategoryPrice + CostofCustomize;
  cartMenu.TotalFinalPrice = costofOne*quanti;
  cartMenu.quantity = [NSString stringWithFormat:@"%d",quanti];
  BOOL retval = NO;
  if (userId.length>0) {
    [self updateQuantiyDataToCartServer:cartMenu];
    retval = [self updateDataIntoDB:cartMenu];
    if (retval) {
      [self calculateAllDetails];
    }
  }else{
    retval = [self updateDataIntoDB:cartMenu];
    if (retval) {
      [self calculateAllDetails];
    }
  }
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
  [self.tblVw reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationNone];
}
-(void)minusMethod:(UIButton*)sender
{
  USerSelectedCartData *cartMenu = (USerSelectedCartData*)[tableArray objectAtIndex:sender.tag];
  int quanti = [[NSString stringWithFormat:@"%@",cartMenu.quantity] intValue];
  if (quanti>1) {
    quanti--;
    float CostofCustomize = 0;
    NSArray*priceArray = [cartMenu.customizeCuisinePrice componentsSeparatedByString:@"&"];
    for (int i =0; i<priceArray.count; i++) {
      CostofCustomize = CostofCustomize+[[priceArray objectAtIndex:i] floatValue];
    }
    float costofOne = cartMenu.subCategoryPrice + CostofCustomize;
    cartMenu.TotalFinalPrice = costofOne*quanti;
    cartMenu.quantity = [NSString stringWithFormat:@"%d",quanti];
    BOOL retval = NO;
    if (userId.length>0) {
      [self updateQuantiyDataToCartServer:cartMenu];
      retval = [self updateDataIntoDB:cartMenu];
      if (retval) {
        [self calculateAllDetails];
      }
    }else{
      retval = [self updateDataIntoDB:cartMenu];
      if (retval) {
        [self calculateAllDetails];
      }
    }
    
    NSLog(@"minus Clicked a button %ld",(long)sender.tag);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    [self.tblVw reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationNone];
  }
}


- (IBAction)navBackBtnClk:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}


-(void)getOptionToCustomizedCuisine:(NSDictionary *)params{
  
  //  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSString *url = @"http://ymoc.mobisofttech.co.in/android_api/ajax_customization.php";
  [utility doPostRequestfor:url withParameters:params onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      dispatch_async(dispatch_get_main_queue(), ^{
        [self parseSearchDetailsInfoResponse:responseDictionary];
      });
    }else{
      dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate hideLoadingView];
      });
    }
  }];
}


-(void)parseSearchDetailsInfoResponse:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
    [ResponseUtility getSharedInstance].CustomizeMenuArray = [[NSMutableArray alloc]init];
    if ([[ResponseDictionary valueForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
      CustomizationMenu *cMenu = [[CustomizationMenu alloc]init];
      cMenu.status = [ResponseDictionary valueForKey:@"status"];
      cMenu.data = [ResponseDictionary valueForKey:@"data"];
      cMenu.c_id = [ResponseDictionary valueForKey:@"id"];
      cMenu.restaurant_id = [ResponseDictionary valueForKey:@"restaurant_id"];
      cMenu.category = [ResponseDictionary valueForKey:@"category"];
      cMenu.sub_category = [ResponseDictionary valueForKey:@"sub_category"];
      cMenu.cust_description = [ResponseDictionary valueForKey:@"cust_description"];
      cMenu.cust_id = [ResponseDictionary valueForKey:@"cust_id"];
      cMenu.cust_option = [ResponseDictionary valueForKey:@"cust_option"];
      if ([ResponseDictionary valueForKey:@"cust_price"]!=NULL) {
        cMenu.cust_price = [[ResponseDictionary valueForKey:@"cust_price"] floatValue];
      }
      if  ([ResponseDictionary valueForKey:@"price"]) {
        cMenu.price = [[ResponseDictionary valueForKey:@"price"] floatValue];
      }
      ppPrice = cMenu.price;
      [[ResponseUtility getSharedInstance].CustomizeMenuArray addObject:cMenu];
    }
    else if ([[ResponseDictionary valueForKey:@"data"] isKindOfClass:[NSArray class]]){
      NSArray *valuesAr = [ResponseDictionary valueForKey:@"data"];
      for (NSArray *respo in valuesAr){
        CustomizationMenu *cMenu = [[CustomizationMenu alloc]init];
        cMenu.status = [respo valueForKey:@"status"];
        cMenu.data = [respo valueForKey:@"data"];
        cMenu.c_id = [respo valueForKey:@"id"];
        cMenu.restaurant_id = [respo valueForKey:@"restaurant_id"];
        cMenu.category = [respo valueForKey:@"category"];
        cMenu.sub_category = [respo valueForKey:@"sub_category"];
        cMenu.cust_description = [respo valueForKey:@"cust_description"];
        cMenu.cust_id = [respo valueForKey:@"cust_id"];
        cMenu.cust_option = [respo valueForKey:@"cust_option"];
        if (![[respo valueForKey:@"cust_price"] isKindOfClass:[NSNull class]]){
          cMenu.cust_price = [[respo valueForKey:@"cust_price"] floatValue];
        }
        if (![[respo valueForKey:@"price"] isKindOfClass:[NSNull class]]) {
          cMenu.price = [[respo valueForKey:@"price"] floatValue];
        }
        ppPrice = cMenu.price;
        [[ResponseUtility getSharedInstance].CustomizeMenuArray addObject:cMenu];
      }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      [appDelegate hideLoadingView];
      [self adPopUpMenu];
    });
    
  }
}

-(void)adPopUpMenu{
  //  [selectedRowsArray removeAllObjects];
  //  [selectedCustomCuisinePriceArray removeAllObjects];
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screenRect.size.height;
  CGFloat screenWidth = screenRect.size.width;
  coverView = [[UIScrollView alloc] initWithFrame:screenRect];
  coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
  [self.view addSubview:coverView];
  popVw.layer.cornerRadius = 10.0;
  popVw=[[UIView alloc]initWithFrame:CGRectMake(20, 100, screenWidth-40, screenHeight/2+100)];
  [popVw setBackgroundColor:[UIColor whiteColor]];
  CustomizationMenu *cmenu;
  if ([ResponseUtility getSharedInstance].CustomizeMenuArray.count>0) {
    cmenu = [[ResponseUtility getSharedInstance].CustomizeMenuArray objectAtIndex:0];
  }
  USerSelectedCartData *cart = (USerSelectedCartData*)[tableArray objectAtIndex:selectedPopUpIndex];
  //  selectedPopUpIndex = sender.tag;
  //  [selectedCustomCuisinePriceArray addObject:[NSString stringWithFormat:@"%f",menu.cust_price]];
  [selectedCustomCuisineStringArray removeAllObjects];
  [selectedCustomCuisinePriceArray removeAllObjects];
  [selectedCustomCuisineIdArray removeAllObjects];
  [selectedCustomCuisineStringArray addObjectsFromArray:[cart.customizeCuisineString componentsSeparatedByString:@"&"]];
  [selectedCustomCuisinePriceArray addObjectsFromArray:[cart.customizeCuisinePrice componentsSeparatedByString:@"&"]];
  [selectedCustomCuisineIdArray addObjectsFromArray:[cart.customizedCuisineId componentsSeparatedByString:@"&"]];
  
  
  float ppWidth = popVw.frame.size.width;
  UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ppWidth-20, 40)];
  lbl1.textColor = [UIColor redColor];
  lbl1.backgroundColor=[UIColor colorWithRed:(219/255.f) green:(219/255.f) blue:(219/255.f) alpha:1.0f];
  lbl1.textColor=[UIColor redColor];
  lbl1.userInteractionEnabled=NO;
  lbl1.textAlignment = NSTextAlignmentCenter;
  lbl1.text= @"Would you like to choose?";
  lbl1.textColor=[UIColor colorWithRed:188.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0];
  lbl1.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
  [popVw addSubview:lbl1];
  
  UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, ppWidth-20, 25)];
  lbl2.textColor = [UIColor blackColor];
  lbl2.backgroundColor=[UIColor clearColor];
  lbl2.textColor=[UIColor blackColor];
  lbl2.userInteractionEnabled=NO;
  lbl2.text= cmenu.sub_category;
  lbl2.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
  [popVw addSubview:lbl2];
  
  int tbleViewArrCount = (int)[ResponseUtility getSharedInstance].CustomizeMenuArray.count;
  NSMutableArray *tempArray = [[NSMutableArray alloc]init];
  for (int i=0; i<[ResponseUtility getSharedInstance].CustomizeMenuArray.count; i++) {
    CustomizationMenu *cm = [[ResponseUtility getSharedInstance].CustomizeMenuArray objectAtIndex:i];
    if (![cm.cust_option isKindOfClass:[NSNull class]]) {
      [tempArray addObject:cm.cust_option];
    }
    
  }
  float extendedHeight = 35*tbleViewArrCount;
  if (tempArray.count ==0) {
    extendedHeight = 35*tempArray.count;
    ppTableView.hidden = YES;
  }else {    ppTableView.hidden = NO;}
  
  ppTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 85, ppWidth-20, extendedHeight) style:UITableViewStylePlain];
  ppTableView.delegate = self;
  ppTableView.dataSource = self;
  ppTableView.backgroundColor = [UIColor clearColor];
  [popVw addSubview:ppTableView];
  
  if (tbleViewArrCount>0) {
    extendedHeight = extendedHeight+90;
  }else{
    extendedHeight = 90;
  }
  
  float lblwidth = ppWidth/2-10;
  UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(10, extendedHeight, lblwidth, 25)];
  lbl3.textColor = [UIColor redColor];
  lbl3.backgroundColor=[UIColor colorWithRed:(219/255.f) green:(219/255.f) blue:(219/255.f) alpha:1.0f];
  lbl3.textColor=[UIColor blackColor];
  lbl3.userInteractionEnabled=NO;
  lbl3.text= @"Total Price";
  lbl3.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
  [popVw addSubview:lbl3];
  
  lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(lbl3.frame.size.width, extendedHeight, lblwidth+10, 25)];
  lbl4.textColor = [UIColor redColor];
  lbl4.backgroundColor=[UIColor colorWithRed:(219/255.f) green:(219/255.f) blue:(219/255.f) alpha:1.0f];
  lbl4.textColor=[UIColor blackColor];
  lbl4.userInteractionEnabled=NO;
  lbl4.textAlignment = NSTextAlignmentRight;
  //  NSString]
  lbl4.text= [NSString stringWithFormat:@"$ %.02f",cmenu.price];
  //  if (tempArray.count ==0) {
  //    //  didSelectSubRowPrice
  //    //    lbl4.text= [NSString stringWithFormat:@"$ %.02f",didSelectSubRowPrice];
  //  }
  
  float tfp = cmenu.price;
  for (int i =0; i<selectedCustomCuisinePriceArray.count; i++) {
    float pr = [[selectedCustomCuisinePriceArray objectAtIndex:i] floatValue];
    tfp = tfp+ pr;
  }
  totalprice = tfp;
  //  totalprice =ppPrice;
  lbl4.text= [NSString stringWithFormat:@"$ %.02f",tfp];
  
  lbl4.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
  [popVw addSubview:lbl4];
  
  extendedHeight = extendedHeight+30;
  UILabel *lbl5 = [[UILabel alloc] initWithFrame:CGRectMake(10, extendedHeight, ppWidth-20, 25)];
  lbl5.textColor = [UIColor redColor];
  lbl5.backgroundColor=[UIColor clearColor];
  lbl5.textColor=[UIColor blackColor];
  lbl5.userInteractionEnabled=NO;
  lbl5.text= @"Special instructions";
  lbl5.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
  [popVw addSubview:lbl5];
  
  extendedHeight = extendedHeight+30;
  myTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, extendedHeight, ppWidth-20, 55)];
  [[myTextView layer] setBorderColor:[[UIColor blackColor] CGColor]];
  [[myTextView layer] setBorderWidth:2.3];
  [[myTextView layer] setCornerRadius:5];
  myTextView.delegate = self;
  [popVw addSubview:myTextView];
  
  extendedHeight = extendedHeight+70;
  UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
  [button1 addTarget:self
              action:@selector(cancelOrderBtnClick)
    forControlEvents:UIControlEventTouchUpInside];
  button1.backgroundColor = [UIColor blackColor];
  [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [button1 setTitle:@"Cancel" forState:UIControlStateNormal];
  button1.frame = CGRectMake(10.0, extendedHeight, lblwidth, 40.0);
  [popVw addSubview:button1];
  
  UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
  [button2 addTarget:self
              action:@selector(confirmOrderBtnClick)
    forControlEvents:UIControlEventTouchUpInside];
  button2.backgroundColor = [UIColor colorWithRed:(0/255.f) green:(204/255.f) blue:(0/255.f) alpha:1.0f];;
  [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [button2 setTitle:@"Confirm" forState:UIControlStateNormal];
  button2.frame = CGRectMake(button1.frame.size.width, extendedHeight, lblwidth+10, 40.0);
  [popVw addSubview:button2];
  
  [popVw setFrame:CGRectMake(20, 100, screenWidth-40, extendedHeight+50)];
  popVw.layer.cornerRadius = 10.0;
  
  [coverView setShowsHorizontalScrollIndicator:NO];
  [coverView setShowsVerticalScrollIndicator:YES];
  coverView.scrollEnabled= YES;
  coverView.userInteractionEnabled= YES;
  //    [yourView addSubview:MyScrollVw];
  coverView.contentSize= CGSizeMake(320 ,extendedHeight+300);
  
  [coverView addSubview:popVw];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
  
  if([text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    return NO;
  }
  
  return YES;
}
- (IBAction)couponSubmitBtnClick:(id)sender {
//  self.cosntraintCouponAmountHeight.constant=40;
}
- (IBAction)proceedToCheckoutBtnClick:(id)sender {
  if (userId.length>0) {
    [self createBeforePayment];
  }else{
    [self proceedTONextScreen];
  }
}

-(void)cancelOrderBtnClick{
  [selectedCustomCuisineIdArray removeAllObjects];
  [selectedCustomCuisinePriceArray removeAllObjects];
  [selectedCustomCuisineStringArray removeAllObjects];
  [coverView removeFromSuperview];
  [popVw removeFromSuperview];
}

-(void)confirmOrderBtnClick{
  
  USerSelectedCartData *cart = (USerSelectedCartData*)[tableArray objectAtIndex:selectedPopUpIndex];
  
  float ttPrice = 0;
  float cPrice = cart.subCategoryPrice;
  ttPrice = cPrice;
  for (int i =0; i<selectedCustomCuisinePriceArray.count; i++) {
    ttPrice = ttPrice+[[selectedCustomCuisinePriceArray objectAtIndex:i] floatValue];
  }
  cart.TotalFinalPrice = ttPrice*[cart.quantity intValue];
  cart.customizeCuisineString = [selectedCustomCuisineStringArray componentsJoinedByString:@"&"];
  cart.customizeCuisinePrice = [selectedCustomCuisinePriceArray componentsJoinedByString:@"&"];
  cart.customizedCuisineId = [selectedCustomCuisineIdArray componentsJoinedByString:@"&"];
  BOOL retval = [self updateDataIntoDB:cart];
  if(userId.length>0){
    [self updateDataToCartServer:cart];
  }
  if (retval) {
    [self calculateAllDetails];
  }
  
  [coverView removeFromSuperview];
  [popVw removeFromSuperview];
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedPopUpIndex inSection:0];
  [self.tblVw reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationNone];
}


-(BOOL)updateDataIntoDB:(USerSelectedCartData*)cart{
  BOOL retval = [[DBManager getSharedInstance] updateDataIntoDB:cart];
  return retval;
}


-(void)addingValueToCartRequest:(NSInteger)restID{
  Utility *utilityObj = [[Utility alloc]init];
  if (userId.length>0) {
    
    NSMutableDictionary *cdictionary = [[NSMutableDictionary alloc]init];
    [cdictionary setValue:userId forKey:@"user_id"];
    [cdictionary setValue:@"1" forKey:@"app_status"];
    [cdictionary setValue:[utilityObj GetOurIpAddress] forKey:@"ip_address"];
    [cdictionary setValue:@"1" forKey:@"order_mode"];
    if ([RequestUtility sharedRequestUtility ].isAsap) {
      [cdictionary setValue:@"1" forKey:@"order_schedule_status"];
      [cdictionary setValue:[utilityObj getCurrentDate] forKey:@"order_schedule_date"];
      [cdictionary setValue:[utilityObj getCurrentTime] forKey:@"order_schedule_time"];
    }else{
      [cdictionary setValue:@"0" forKey:@"order_schedule_status"];
      [cdictionary setValue:@"00-00-00" forKey:@"order_schedule_date"];
      [cdictionary setValue:@"00:00" forKey:@"order_schedule_time"];
    }
    temporayUniqueID = [[NSMutableArray alloc]init];
    NSMutableArray *cArray = [[NSMutableArray alloc]init];
    NSArray *arr = [[DBManager getSharedInstance] getALlPendingCartDatatobeAdded:(int)restID];
    if (arr.count>0) {
      
      for (int i =0; i<arr.count; i++) {
        
        
        USerSelectedCartData *cartData = (USerSelectedCartData*)[arr objectAtIndex:i];
        //      currentUID = cartData.unique_id;
        NSString *randID = cartData.randomCartID;
        [temporayUniqueID addObject:randID];
        NSString *AND_cart_id = [NSString stringWithFormat:@"%ld", (long)cartData.unique_id ];
        NSMutableDictionary *cartdictionary = [[NSMutableDictionary alloc]init];
        [cartdictionary setValue:randID forKey:@"AND_cart_id"];
        [cartdictionary setValue:AND_cart_id forKey:@"cart_id"];
        [cartdictionary setValue:[NSString stringWithFormat:@"%ld",(long)cartData.restaurant_Id] forKey:@"rest_id"];
        [cartdictionary setValue:[NSString stringWithFormat:@"%ld",(long)cartData.subCategory_Id] forKey:@"sub_cat_id"];
        [cartdictionary setValue:cartData.quantity forKey:@"quantity"];
        [cartdictionary setValue:cartData.instructions forKey:@"instruction"];
        NSMutableArray *custArray = [[NSMutableArray alloc]init];
        NSArray *cIDArray = [cartData.customizedCuisineId componentsSeparatedByString:@"&"];
        NSArray *cOPArray = [cartData.customizeCuisineString componentsSeparatedByString:@"&"];
        NSArray *cPRArray = [cartData.customizeCuisinePrice componentsSeparatedByString:@"&"];
        NSString *emptyStr = [cOPArray objectAtIndex:0];
        if (![emptyStr isEqual:@""]) {
          
          for (int i =0; i<cOPArray.count; i++) {
            NSMutableDictionary *custdictionary = [[NSMutableDictionary alloc]init];
            [cartdictionary setValue:AND_cart_id forKey:@"cart_id"];
            [custdictionary setValue:[cIDArray objectAtIndex:i] forKey:@"cust_id"];
            [custdictionary setValue:[cOPArray objectAtIndex:i] forKey:@"cust_option"];
            [custdictionary setValue:[cPRArray objectAtIndex:i] forKey:@"cust_price"];
            [custArray addObject:custdictionary];
          }
        }else{
          for (int i =1; i<cOPArray.count; i++) {
            NSMutableDictionary *custdictionary = [[NSMutableDictionary alloc]init];
            [cartdictionary setValue:AND_cart_id forKey:@"cart_id"];
            [custdictionary setValue:[cIDArray objectAtIndex:i] forKey:@"cust_id"];
            [custdictionary setValue:[cOPArray objectAtIndex:i] forKey:@"cust_option"];
            [custdictionary setValue:[cPRArray objectAtIndex:i] forKey:@"cust_price"];
            [custArray addObject:custdictionary];
          }
        }
        [cArray addObject:cartdictionary];
        [cartdictionary setObject:custArray forKey:@"customization"];
        [cdictionary setObject:cArray forKey:@"cart_data"];
      }
      NSLog(@"cart = %@",cdictionary);
      NSError * err;
      NSData * jsonData = [NSJSONSerialization dataWithJSONObject:cdictionary options:0 error:&err];
      NSString * addToCartString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
      NSLog(@"Add to cart String = %@",addToCartString);
      [self addValuesToCart:addToCartString];
    }
  }
}

-(void)addValuesToCart:(NSString*)string{
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSString *url = @"http://ymoc.mobisofttech.co.in/android_api/add_cart.php";
  [utility doYMOCStringPostRequest:url withParameters:string onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      
      dispatch_async(dispatch_get_main_queue(), ^{
        [self parseAddToCartUserResponse:responseDictionary];
      });
    }else{
      dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate hideLoadingView];
      });
    }
  }];
}

// The reponse from server is : {"code":"1","data":{"8":49},"msg":"success"}

-(void)parseAddToCartUserResponse:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
      NSString *code = [ResponseDictionary valueForKey:@"code"];
      if ([code isEqualToString:@"1"]) {
        NSLog(@"login successfull");
        [appDelegate hideLoadingView];
        NSDictionary *data = [ResponseDictionary valueForKey:@"data"];
        for (int i =0; i<data.count; i++) {
          NSString *localID = [temporayUniqueID objectAtIndex:i];
          if (localID.length>0) {
            
            NSString *serverID = [[data valueForKey:localID] stringValue];
            if (serverID.length>0) {
              [[DBManager getSharedInstance] updateDataIntoDB:serverID andLocalCartID:localID];
            }
          }
          
        }
        [self reloadView];
        
      }else{
        [appDelegate hideLoadingView];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[ResponseDictionary valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
      }
    });
    
  }
}

-(void)createBeforePayment{
  if (userId.length>0) {
    
    Utility *utilityObj = [[Utility alloc]init];
    beforePaymentDictionary  = [[NSMutableDictionary alloc]init];
    [beforePaymentDictionary setValue:@"before_payment" forKey:@"action"];
    [beforePaymentDictionary setValue:userId forKey:@"user_id"];
    [beforePaymentDictionary setValue:selectedUfrespo.ufp_id forKey:@"restaurant_id"];
    [beforePaymentDictionary setValue:[utilityObj GetOurIpAddress] forKey:@"ip_address"];
    if([RequestUtility sharedRequestUtility].delivery_status == 0){
      [beforePaymentDictionary setValue:@"0" forKey:@"order_mode"];
    }else{
      [beforePaymentDictionary setValue:@"1" forKey:@"order_mode"];
    }
    if ([RequestUtility sharedRequestUtility ].isAsap) {
      [beforePaymentDictionary setValue:@"1" forKey:@"order_schedule_status"];
      [beforePaymentDictionary setValue:[utilityObj getCurrentDate] forKey:@"order_schedule_date"];
      [beforePaymentDictionary setValue:[utilityObj getCurrentTime] forKey:@"order_schedule_time"];
    }else{
      [beforePaymentDictionary setValue:@"0" forKey:@"order_schedule_status"];
      [beforePaymentDictionary setValue:@"00-00-00" forKey:@"order_schedule_date"];
      [beforePaymentDictionary setValue:@"00:00" forKey:@"order_schedule_time"];
    }
    
    NSData * beforPaymentjsonData = [NSJSONSerialization dataWithJSONObject:beforePaymentDictionary options:0 error:nil];
    NSString * beforPaymentString = [[NSString alloc] initWithData:beforPaymentjsonData encoding:NSUTF8StringEncoding];
    NSLog(@"beforePaymentString = %@",beforPaymentString);
    
    [self beforePayment:beforPaymentString];
    
  }
}

-(void)beforePayment:(NSString*)string{
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSString *url = @"http://ymoc.mobisofttech.co.in/android_api/before_payment.php";
  [utility doYMOCStringPostRequest:url withParameters:string onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      dispatch_async(dispatch_get_main_queue(), ^{
        [self parseUserResponseBeforePayment:responseDictionary];
      });
    }else{
      dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate hideLoadingView];
      });
    }
  }];
}

-(void)parseUserResponseBeforePayment:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
      NSString *code = [ResponseDictionary valueForKey:@"code"];
      if ([code isEqualToString:@"1"]) {
        NSLog(@"login successfull");
        [appDelegate hideLoadingView];
        [self proceedTONextScreen];
      }else{
        [appDelegate hideLoadingView];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Problem initiating users before payment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
      }
    });
    
  }
}

-(void)proceedTONextScreen{
  if ([FBSDKAccessToken currentAccessToken])
  {
    NSLog(@"user logged in throug fb already");
  }
  if (userId.length>0) {
    
    BillSummaryViewController *obj_clvc  = (BillSummaryViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"BillSummaryViewControllerId"];
    obj_clvc.subTotalPassed = subTotalPassed;
    obj_clvc.salesTaxPassed = salesTaxPassed;
    obj_clvc.deliveryFeePassed = deliveryFeePassed;
    obj_clvc.totalAmountPassed = totalAmountPassed;
    obj_clvc.bfPaymentDictionary = beforePaymentDictionary;
    [self.navigationController pushViewController:obj_clvc animated:YES];
  }else{
    
    SignUpLoginViewController *obj_clvc  = (SignUpLoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SignUpLoginViewControllerId"];
    [self.navigationController pushViewController:obj_clvc animated:YES];
  }
}


-(void)updateDataToCartServer:(USerSelectedCartData*)cdata{
  
  NSMutableDictionary *cdictionary = [[NSMutableDictionary alloc]init];
  [cdictionary setValue:userId forKey:@"user_id"];
  [cdictionary setValue:@"1" forKey:@"app_status"];
  [cdictionary setValue:@"update_cart" forKey:@"action"];
  
  NSMutableArray *cArray = [[NSMutableArray alloc]init];
  //    for (int i =0; i<globalCartArray.count; i++) {
  USerSelectedCartData *uscd = (USerSelectedCartData*)[globalCartArray objectAtIndex:selectedPopUpIndex];
  //  NSString *AND_cart_id = [NSString stringWithFormat:@"%ld", (long)uscd.unique_id ];
  NSMutableDictionary *cartdictionary = [[NSMutableDictionary alloc]init];
  [cartdictionary setValue:uscd.randomCartID forKey:@"AND_cart_id"];
  
  [cartdictionary setValue:uscd.serverCartID forKey:@"cart_id"];
  
  [cartdictionary setValue:[NSString stringWithFormat:@"%ld",(long)uscd.restaurant_Id] forKey:@"rest_id"];
  
  [cartdictionary setValue:[NSString stringWithFormat:@"%ld",(long)uscd.subCategory_Id] forKey:@"sub_cat_id"];
  
  [cartdictionary setValue:uscd.quantity forKey:@"quantity"];
  
  NSString *instruct = myTextView.text;
  if (instruct.length>0) {
    [cartdictionary setValue:uscd.instructions forKey:@"instruction"];
  }else{
    [cartdictionary setValue:@"no instructions" forKey:@"instruction"];
  }
  NSMutableArray *custArray = [[NSMutableArray alloc]init];
  NSArray *cIDArray =[NSArray arrayWithArray:selectedCustomCuisineIdArray];// [uscd.customizedCuisineId componentsSeparatedByString:@"&"];
  NSArray *cOPArray =[NSArray arrayWithArray:selectedCustomCuisineStringArray];// [selectedCustomCuisineStringArray componentsSeparatedByString:@"&"];
  NSArray *cPRArray = [NSArray arrayWithArray:selectedCustomCuisinePriceArray];//[uscd.customizeCuisinePrice componentsSeparatedByString:@"&"];
  NSString *emptyStr = [cOPArray objectAtIndex:0];
  if (![emptyStr isEqual:@""]) {
    
    for (int i =0; i<cOPArray.count; i++) {
      NSMutableDictionary *custdictionary = [[NSMutableDictionary alloc]init];
      [cartdictionary setValue:uscd.serverCartID forKey:@"cart_id"];
      [custdictionary setValue:[cIDArray objectAtIndex:i] forKey:@"cust_id"];
      [custdictionary setValue:[cOPArray objectAtIndex:i] forKey:@"cust_option"];
      [custdictionary setValue:[cPRArray objectAtIndex:i] forKey:@"cust_price"];
      [custArray addObject:custdictionary];
    }
  }else{
    for (int i =1; i<cOPArray.count; i++) {
      NSMutableDictionary *custdictionary = [[NSMutableDictionary alloc]init];
      [cartdictionary setValue:uscd.serverCartID forKey:@"cart_id"];
      [custdictionary setValue:[cIDArray objectAtIndex:i] forKey:@"cust_id"];
      [custdictionary setValue:[cOPArray objectAtIndex:i] forKey:@"cust_option"];
      [custdictionary setValue:[cPRArray objectAtIndex:i] forKey:@"cust_price"];
      [custArray addObject:custdictionary];
    }
  }
  [cArray addObject:cartdictionary];
  [cartdictionary setObject:custArray forKey:@"customization"];
  [cdictionary setObject:cArray forKey:@"cart_data"];
  //    }
  NSLog(@"cart = %@",cdictionary);
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:cdictionary options:0 error:&err];
  NSString * addToCartString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSLog(@"update to cart String = %@",addToCartString);
  
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSString *url = @"http://ymoc.mobisofttech.co.in/android_api/update_cart.php";
  [utility doYMOCStringPostRequest:url withParameters:addToCartString onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      dispatch_async(dispatch_get_main_queue(), ^{
        [self parseUserResponseAfterUpdateCartQuantity:responseDictionary];
      });
    }else{
      dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate hideLoadingView];
      });
    }
  }];
}

-(void)updateQuantiyDataToCartServer:(USerSelectedCartData*)cdata{
  
  //  {
  //    "action": "update_quantity",
  //    "user_id": "185",
  //    "app_status": "1",
  //    "cart_id": "13",
  //    "quantity": "6",
  //    "order_mode": "1",
  //    "order_schedule_status": "0",
  //    "order_schedule_date": "0000-00-00",
  //    "order_schedule_time": "00:00:00"
  //  }
  
  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
  [dictionary setValue:cdata.serverCartID forKey:@"cart_id"];
  [dictionary setValue:@"update_quantity" forKey:@"action"];
  [dictionary setValue:@"1" forKey:@"order_mode"];
  [dictionary setValue:cdata.quantity forKey:@"quantity"];
  [dictionary setValue:userId forKey:@"user_id"];
  if ([RequestUtility sharedRequestUtility ].isAsap) {
    [dictionary setValue:@"1" forKey:@"order_schedule_status"];
    [dictionary setValue:[[RequestUtility sharedRequestUtility ] getCurrentDate] forKey:@"order_schedule_date"];
    [dictionary setValue:[[RequestUtility sharedRequestUtility ] getCurrentTime] forKey:@"order_schedule_time"];
  }else{
    [dictionary setValue:@"0" forKey:@"order_schedule_status"];
    [dictionary setValue:@"0000-00-00" forKey:@"order_schedule_date"];
    [dictionary setValue:@"00:00:00" forKey:@"order_schedule_time"];
  }
  [dictionary setValue:@"1" forKey:@"app_status"];
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&err];
  NSString *String = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSLog(@"updateQuantiyDataToCartServer string \n = %@",String);
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSString *url = @"http://ymoc.mobisofttech.co.in/android_api/update_cart_quantity.php";
  [utility doYMOCStringPostRequest:url withParameters:String onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      dispatch_async(dispatch_get_main_queue(), ^{
        [self parseUserResponseAfterUpdateCartQuantity:responseDictionary];
      });
    }else{
      dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate hideLoadingView];
      });
    }
  }];
}

-(void)parseUserResponseAfterUpdateCartQuantity:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
      NSString *code = [ResponseDictionary valueForKey:@"code"];
      if ([code isEqualToString:@"1"]) {
        NSLog(@"update quantity successfull");
        [appDelegate hideLoadingView];
        [self reloadView];
      }else{
        [appDelegate hideLoadingView];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Problem initiating users after payment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
      }
    });
    
  }
}

-(void)deleteCartiwthCartId:(NSString*)cartID{
  //http://ymoc.mobisofttech.co.in/android_api/delete_cart.php	{"action":"delete","user_id":"12","app_status":"1","cart_id":"147","order_mode":"1","order_schedule_status":"0","order_schedule_date":"0000-00-00","order_schedule_time":"00:00:00"}
  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
  [dictionary setValue:cartID forKey:@"cart_id"];
  [dictionary setValue:@"delete" forKey:@"action"];
  [dictionary setValue:@"0" forKey:@"order_mode"];
  [dictionary setValue:userId forKey:@"user_id"];
  if ([RequestUtility sharedRequestUtility ].isAsap) {
    [dictionary setValue:@"1" forKey:@"order_schedule_status"];
    [dictionary setValue:[[RequestUtility sharedRequestUtility ] getCurrentDate] forKey:@"order_schedule_date"];
    [dictionary setValue:[[RequestUtility sharedRequestUtility ] getCurrentTime] forKey:@"order_schedule_time"];
  }else{
    [dictionary setValue:@"0" forKey:@"order_schedule_status"];
    [dictionary setValue:@"00-00-00" forKey:@"order_schedule_date"];
    [dictionary setValue:@"00:00" forKey:@"order_schedule_time"];
  }
  [dictionary setValue:@"1" forKey:@"app_Status"];
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&err];
  NSString *String = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSLog(@"delete cart string \n = %@",String);
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSString *url = @"http://ymoc.mobisofttech.co.in/android_api/delete_cart.php";
  [utility doYMOCStringPostRequest:url withParameters:String onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      dispatch_async(dispatch_get_main_queue(), ^{
        [self parseUserResponseAfterDeleteCart:responseDictionary];
      });
    }else{
      dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate hideLoadingView];
      });
    }
  }];
}

-(void)parseUserResponseAfterDeleteCart:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
      NSString *code = [ResponseDictionary valueForKey:@"code"];
      if ([code isEqualToString:@"1"]) {
        NSLog(@"Delete cart successfull");
        [appDelegate hideLoadingView];
        //        [self getDisplayCartData];
      }else{
        [appDelegate hideLoadingView];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Problem Deleting the cart value." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
      }
    });
    
  }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self animateTextField:textField up:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
  [self animateTextField:textField up:NO];
}


- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
  int animatedDistance;
  int moveUpValue = textField.frame.origin.y+ textField.frame.size.height;
  UIInterfaceOrientation orientation =
  [[UIApplication sharedApplication] statusBarOrientation];
  if (orientation == UIInterfaceOrientationPortrait ||
      orientation == UIInterfaceOrientationPortraitUpsideDown)
  {
    
    animatedDistance = 216-(520-moveUpValue-5);
  }
  else
  {
    animatedDistance = 162-(320-moveUpValue-5);
  }
  
  if(animatedDistance>0)
  {
    const int movementDistance = animatedDistance;
    const float movementDuration = 0.3f;
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
  }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  
  [textField resignFirstResponder];
  return YES;
}


-(void)designView{

  float yAxis = self.tblVw.frame.size.height+self.tblVw.frame.origin.y+40;
  
  UILabel *fsubtotalLabel = [self getLabelWithMsg:@"SubTotal:" andColor:@"Black"andYcord:yAxis andAllignt:@"left"];
  UILabel *asubtotalLabel = [self getLabelWithMsg:@"ASubTotal:" andColor:@"red" andYcord:yAxis andAllignt:@"right"];
  [self.fscrollView addSubview:fsubtotalLabel];
  [self.fscrollView addSubview:asubtotalLabel];
  
  yAxis = yAxis+50;
  UILabel *fsalesTaxLabel = [self getLabelWithMsg:@"SalesTax:" andColor:@"Black" andYcord:yAxis andAllignt:@"left"];
  UILabel *asalesTaxLabel = [self getLabelWithMsg:@"ASalesTax:" andColor:@"red" andYcord:yAxis andAllignt:@"right"];
  [self.fscrollView addSubview:fsalesTaxLabel];
  [self.fscrollView addSubview:asalesTaxLabel];
  
  yAxis = yAxis+50;
  UILabel *fdeliveryfeeLabel = [self getLabelWithMsg:@"DeliveryFee:" andColor:@"Black" andYcord:yAxis andAllignt:@"left"];
  UILabel *adeliveryfeeLabel = [self getLabelWithMsg:@"ADeliveryFee:" andColor:@"red" andYcord:yAxis andAllignt:@"right"];
  [self.fscrollView addSubview:fdeliveryfeeLabel];
  [self.fscrollView addSubview:adeliveryfeeLabel];
  
  yAxis = yAxis+50;
  UILabel *fordermodeLabel = [self getLabelWithMsg:@"Order Mode:" andColor:@"Black" andYcord:yAxis andAllignt:@"left"];
  UILabel *aordermodeLabel = [self getLabelWithMsg:@"AOrder Mode:" andColor:@"red" andYcord:yAxis andAllignt:@"right"];
  [self.fscrollView addSubview:fordermodeLabel];
  [self.fscrollView addSubview:aordermodeLabel];
  
  yAxis = yAxis+50;
  UILabel *forderScheduleLabel = [self getLabelWithMsg:@"Order Schedule:" andColor:@"Black" andYcord:yAxis andAllignt:@"left"];
  UILabel *aorderScheduleLabel = [self getLabelWithMsg:@"AOrder Schedule:" andColor:@"red" andYcord:yAxis andAllignt:@"right"];
  [self.fscrollView addSubview:forderScheduleLabel];
  [self.fscrollView addSubview:aorderScheduleLabel];
  
  yAxis = yAxis+50;
  UILabel *fcouponCodeLabel = [self getLabelWithMsg:@"Coupon Amount:" andColor:@"Black" andYcord:yAxis andAllignt:@"left"];
  UILabel *acouponCodeLabel = [self getLabelWithMsg:@"ACoupon Amount:" andColor:@"red" andYcord:yAxis andAllignt:@"right"];
  [self.fscrollView addSubview:fcouponCodeLabel];
  [self.fscrollView addSubview:acouponCodeLabel];
  
  yAxis = yAxis+50;
  UILabel *ftotalLabel = [self getLabelWithMsg:@"Total:" andColor:@"Black" andYcord:yAxis andAllignt:@"left"];
  UILabel *atotalLabel = [self getLabelWithMsg:@"ATotal:" andColor:@"red" andYcord:yAxis andAllignt:@"right"];
  [self.fscrollView addSubview:ftotalLabel];
  [self.fscrollView addSubview:atotalLabel];

}

-(UILabel*)getLabelWithMsg:(NSString*)msgStr andColor:(NSString*)color andYcord:(float)yCord andAllignt:(NSString*)align{
  
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screenRect.size.height;
  CGFloat screenWidth = screenRect.size.width;
  
  UILabel *lbl = [[UILabel alloc]init];
  if ([align isEqualToString:@"left"]) {
    [lbl setFrame:CGRectMake(0, yCord, screenWidth/2, 45)];
    lbl.textAlignment = 0;
      lbl.textColor = [UIColor blackColor];
  }else{
    [lbl setFrame:CGRectMake(screenWidth/2, yCord, screenWidth/2, 45)];
      lbl.textColor = [UIColor colorWithRed:85.0/255.0 green:150.0/255.0 blue:28.0/255.0 alpha:1.0];
    lbl.textAlignment = 1;
  }
  lbl.font = [UIFont fontWithName:@"Sansation-Bold" size:16];
  lbl.text = msgStr;
  lbl.numberOfLines = 1;
  lbl.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
  lbl.adjustsFontSizeToFitWidth = YES;
  lbl.minimumScaleFactor = 10.0f/12.0f;
  lbl.adjustsFontSizeToFitWidth = YES;
  lbl.backgroundColor = [UIColor clearColor];
  lbl.lineBreakMode = NSLineBreakByWordWrapping;
  return lbl;
}

@end
