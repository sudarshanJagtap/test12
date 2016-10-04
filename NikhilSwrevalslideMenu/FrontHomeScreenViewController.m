//
//  FrontHomeScreenViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Nikhil Boriwale on 11/07/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "FrontHomeScreenViewController.h"
#import "SWRevealViewController.h"
#import "ImageDownloadOperation.h"
#import "FrontHomeScreenTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "RightMenuViewController.h"
#import "HomeViewOperation.h"
#import "FilterOperations.h"
#import "DetailViewController.h"
#import "ResponseUtility.h"
#import "RequestUtility.h"
#import "AsyncImageView.h"
#import "DBManager.h"
#import "HomeCartTableViewCell.h"
#import <GooglePlaces/GooglePlaces.h>
@interface FrontHomeScreenViewController ()<RightMenuViewControllerDelegate,RateViewDelegate,GMSAutocompleteViewControllerDelegate>{
  ResponseUtility *respoUtility;
  RequestUtility *reqUtility;
  UserFiltersResponse *ufpUtility;
  FilterOperations *fOperation;
  NSMutableArray *tempArray;
  UIButton *crossBtn;
  NSMutableArray* bandArray;
  NSString *dropDownSelectedString;
  UILabel *noRestoLabel;
  UIButton *CartButton;
  
  UIView *trsnparentView;
  UIView* coverView;
  UIView *popUpView;
  UITableView *ppTableView;
  NSMutableArray *allRestArray;
  NSMutableArray *popRestArray;
  UITapGestureRecognizer *tap;
  UIView *fullscreenView;
  UIView *alertView;
  UserFiltersResponse *didSelectedFilterRespo;
}

@end

@implementation FrontHomeScreenViewController
- (void)viewDidLoad {
  
  [super viewDidLoad];
  fullscreenView = [[UIView alloc]init];
  alertView = [[UIView alloc]init];
  tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(RemovecartPpUp)];
  ppTableView.tableFooterView = [[UIView alloc] initWithFrame : CGRectZero];
  popUpView = [[UIView alloc]init];
  ppTableView = [[UITableView alloc] init];
  coverView = [[UIView alloc]init ];
  trsnparentView = [[UIView alloc]init];
  noRestoLabel = [[UILabel alloc] init];
  self.searchArea.layer.borderColor = [UIColor colorWithRed:40/255.0f green:174/255.0f   blue:156/255.0f alpha:1.0f].CGColor;
  self.searchArea.layer.borderWidth = 1.0f;
  self.navigationController.navigationBarHidden = YES;
  fOperation = [FilterOperations getSharedInstance];
  UIEdgeInsets inset = UIEdgeInsetsMake(15, 0, 0, 0);
  self.tableView.contentInset = inset;
  NSString *cityValue = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"city"];
//  self.titleLbl.text =cityValue;
  NSString *cityValueText = [NSString stringWithFormat:@" %@",cityValue];
  self.addressBtn.text = cityValueText;
  [self.navigationController.navigationBar setTitleTextAttributes:
   @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
  
  self.addressBtn.layer.cornerRadius = 14;
  [[self.addressBtn layer] setBorderWidth:2.0f];
  self.addressBtn.layer.borderColor = [UIColor colorWithRed:188.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0].CGColor;
  self.addressBtn.clipsToBounds=YES;
  
  [self.addressBtn setUserInteractionEnabled:YES];
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnSearchMenu:)];
  [tapGestureRecognizer setNumberOfTapsRequired:1];
  [self.addressBtn addGestureRecognizer:tapGestureRecognizer];

  
  self.btnDelivery.layer.cornerRadius = 4;
  self.btnDelivery.layer.borderWidth = 1;
  self.btnDelivery.layer.borderColor = [UIColor whiteColor].CGColor;
  
  self.btnSort.layer.cornerRadius = 4;
  self.btnSort.layer.borderWidth = 1;
  self.btnSort.layer.borderColor = [UIColor whiteColor].CGColor;
  
  
  self.btnPickup.layer.cornerRadius = 4;
  self.btnPickup.layer.borderWidth = 1;
  self.btnPickup.layer.borderColor = [UIColor whiteColor].CGColor;
  
  
  [self.BarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
  respoUtility = [ResponseUtility getSharedInstance];
  reqUtility = [RequestUtility sharedRequestUtility];
  reqUtility.delivery_status = 1;
  [self.btnPickup setEnabled:YES];
  self.btnDelivery.backgroundColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0f];
  self.btnPickup.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
  [self.btnDelivery setEnabled:NO];
  crossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [crossBtn addTarget:self
               action:@selector(clearFliter)
     forControlEvents:UIControlEventTouchUpInside];
  [crossBtn setTitle:@"" forState:UIControlStateNormal];
  crossBtn.frame = CGRectMake(10, self.addedFilterLabel.frame.origin.y, 20, 20.0);
  [crossBtn setBackgroundImage:[UIImage imageNamed:@"delete_item"] forState:UIControlStateNormal];
  [self.view addSubview:crossBtn];
  [self updateFiltersLabel];
  [self delegateDelivery];
  bandArray = [[NSMutableArray alloc] init];
  [bandArray addObject:@"Default"];
  [bandArray addObject:@"Restaurant Name"];
  [bandArray addObject:@"Price(Ascending)"];
  [bandArray addObject:@"Price(Descending)"];
  [bandArray addObject:@"Rating"];
  [bandArray addObject:@"Delivery Estimate"];
  [bandArray addObject:@"Delivery Minimum"];
  
  self.downPicker = [[DownPicker alloc] initWithTextField:self.dropdown withData:bandArray];
  [self.downPicker addTarget:self
                      action:@selector(dp_Selected:)
            forControlEvents:UIControlEventValueChanged];
  
  
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screenRect.size.height;
  CGFloat screenWidth = screenRect.size.width;
  CartButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [CartButton addTarget:self
                 action:@selector(showCartView)
       forControlEvents:UIControlEventTouchUpInside];
  [CartButton setTitle:@"1" forState:UIControlStateNormal];
  [CartButton setBackgroundImage:[UIImage imageNamed:@"added_cart_img.png"] forState:UIControlStateNormal];
  CartButton.frame = CGRectMake(screenWidth-70, screenHeight-70, 50,50 );
  [self.view addSubview:CartButton];
  
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  self.navigationController.navigationBarHidden = YES;
  respoUtility = [ResponseUtility getSharedInstance];
  reqUtility = [RequestUtility sharedRequestUtility];
//  self.titleLbl.text = respoUtility.enteredAddress;
  
  NSString *cityValueText = [NSString stringWithFormat:@" %@",respoUtility.enteredAddress];
  self.addressBtn.text = cityValueText;
//  self.addressBtn.text = respoUtility.enteredAddress;
  //  NSMutableArray* bandArray = [[NSMutableArray alloc] init];
  
  // add some sample data
  //  [bandArray addObject:@"Default"];
  //  [bandArray addObject:@"Restaurant Name"];
  //  [bandArray addObject:@"Price(Ascending)"];
  //  [bandArray addObject:@"Price(Descending)"];
  //  [bandArray addObject:@"Rating"];
  //  [bandArray addObject:@"Delivery Estimate"];
  //  [bandArray addObject:@"Delivery Minimum"];
  //
  //  self.downPicker = [[DownPicker alloc] initWithTextField:self.dropdown withData:bandArray];
  //  [self.downPicker addTarget:self
  //                      action:@selector(dp_Selected:)
  //            forControlEvents:UIControlEventValueChanged];
  tempArray = [[NSMutableArray alloc]init];
  [tempArray addObjectsFromArray:respoUtility.UserFiltersResponseArray];
}

-(void)viewWillDisappear:(BOOL)animated{
  self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
  
  [RequestUtility sharedRequestUtility].isThroughLeftMenu = NO;
  self.searchArea.hidden = YES;
  self.navigationController.navigationBarHidden = YES;
  tempArray = [[NSMutableArray alloc]init];
  [tempArray addObjectsFromArray:respoUtility.UserFiltersResponseArray];

  NSDictionary*rDict = [[DBManager getSharedInstance] getALlRestuarants];
  NSArray *rArr = [rDict allValues];
  //  NSArray *rKeys = [rDict allKeys];
  if (rArr.count>0) {
    CartButton.hidden = NO;
    [CartButton setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)rArr.count] forState:UIControlStateNormal];
    
  }else{
    CartButton.hidden = YES;
  }
  

}

-(void)showCartView{
  
  NSDictionary*rDict = [[DBManager getSharedInstance] getALlRestuarants];
  NSMutableDictionary *DeliveryDict = [[NSMutableDictionary alloc]init];
  NSMutableDictionary *pickupDict = [[NSMutableDictionary alloc]init];
  NSMutableDictionary *ASAPDict = [[NSMutableDictionary alloc]init];
  NSArray *rArr = [rDict allValues];
  NSArray *rKeys = [rDict allKeys];
  allRestArray = [[NSMutableArray alloc]init];
  popRestArray = [[NSMutableArray alloc]init];
  if (rArr.count>0) {
    CartButton.hidden = NO;
    [CartButton setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)rArr.count] forState:UIControlStateNormal];
    
    for (int i =0; i<rArr.count; i++) {
      
      int Id = [[rArr objectAtIndex:i] intValue];
      NSArray *tempRestArray = [[DBManager getSharedInstance]getALlCartData:[[rArr objectAtIndex:i] intValue]];
      if (tempRestArray.count>0) {
        [popRestArray addObject:[tempRestArray objectAtIndex:0]];
      }
      int dcount = [[DBManager getSharedInstance]getALlRestuarantswhereOrderIs:@"Delivery" andRestuarantId:Id];
      if (dcount>0) {
        [DeliveryDict setValue:[NSNumber numberWithInt:dcount] forKey:[rKeys objectAtIndex:i]];
        AllRestoCartData *cdata = [[AllRestoCartData alloc]init];
        cdata.rest_id = [rArr objectAtIndex:i];
        cdata.rest_name = [rKeys objectAtIndex:i];
        cdata.orderCount = [NSString stringWithFormat:@"%d",dcount];
        cdata.orderType = @"Delivery";
        [allRestArray addObject:cdata];
      }
      int pcount = [[DBManager getSharedInstance]getALlRestuarantswhereOrderIs:@"PickUp" andRestuarantId:Id];
      if (pcount>0) {
        [pickupDict setValue:[NSNumber numberWithInt:pcount] forKey:[rKeys objectAtIndex:i]];
        AllRestoCartData *cdata = [[AllRestoCartData alloc]init];
        cdata.rest_id = [rArr objectAtIndex:i];
        cdata.rest_name = [rKeys objectAtIndex:i];
        cdata.orderCount = [NSString stringWithFormat:@"%d",pcount];
        cdata.orderType = @"PickUp";
        [allRestArray addObject:cdata];
      }
      int acount = [[DBManager getSharedInstance]getALlRestuarantswhereOrderIs:@"ASAP" andRestuarantId:Id];
      if (acount>0) {
        [ASAPDict setValue:[NSNumber numberWithInt:pcount] forKey:[rKeys objectAtIndex:i]];
        AllRestoCartData *cdata = [[AllRestoCartData alloc]init];
        cdata.rest_id = [rArr objectAtIndex:i];
        cdata.rest_name = [rKeys objectAtIndex:i];
        cdata.orderCount = [NSString stringWithFormat:@"%d",acount];
        cdata.orderType = @"ASAP";
        [allRestArray addObject:cdata];
      }
      
    }
    
  
  
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screenRect.size.height;
  CGFloat screenWidth = screenRect.size.width;
  
  [popUpView setFrame:CGRectMake(10, 70, screenWidth-20, screenHeight-90)];
  [popUpView addSubview:ppTableView];
  [self.view addGestureRecognizer:tap];
  ppTableView.delegate = self;
  ppTableView.dataSource = self;
  
  [ppTableView setFrame:CGRectMake(05, 05, screenWidth-30, screenHeight-100)];
  popUpView.backgroundColor  = [UIColor blackColor];
  popUpView.hidden = NO;
  [popUpView addSubview:ppTableView];
  [coverView setFrame:self.view.bounds];
  popUpView.backgroundColor = [UIColor blackColor];
  popUpView.layer.borderColor = [UIColor yellowColor].CGColor;
  coverView.layer.borderWidth = 2.0f;
  popUpView.backgroundColor = [UIColor grayColor];
  coverView.hidden = NO;
  trsnparentView.backgroundColor = [UIColor blackColor];
  trsnparentView.alpha = 0/7;
  trsnparentView.hidden = NO;
  [trsnparentView setFrame:self.view.bounds];
  [self.view addSubview:trsnparentView];
  [coverView addSubview:popUpView];
  [self.view addSubview:coverView];
  [self.view bringSubviewToFront:coverView];
  [ppTableView reloadData];
  }else{
    CartButton.hidden = YES;
    [self RemovecartPpUp];
  }
}

-(void)updateFiltersLabel{
  
  NSMutableString *addedFiltersText = [[NSMutableString alloc]init];
  NSString *features;
  if (reqUtility.selectedFeaturesArray.count>0) {
    
    for (int i =0; i<reqUtility.selectedFeaturesArray.count; i++) {
      NSString *str = [reqUtility getDisplayFeature:[reqUtility.selectedFeaturesArray objectAtIndex:i]];
      [addedFiltersText appendString:str];
      [addedFiltersText appendString:@", "];
    }
  }else{features = @"";}
  
  NSString *cuisine;
  if (reqUtility.selectedCusinesArray.count>0) {
    cuisine = [reqUtility.selectedCusinesArray componentsJoinedByString:@","];
    [addedFiltersText appendString:cuisine];
    [addedFiltersText appendString:@", "];
  }else{cuisine = @"";}
  
  NSString *ratings;
  if (reqUtility.ratings>0) {
    ratings = [NSString stringWithFormat:@"%d * & less",reqUtility.ratings];
    [addedFiltersText appendString:ratings];
    [addedFiltersText appendString:@", "];
  }
  
  if (reqUtility.isAsap) {
    [addedFiltersText appendString:reqUtility.asapDisplayLbl];
    [addedFiltersText appendString:@", "];
  }
  
  if (dropDownSelectedString.length>0) {
    [addedFiltersText appendString:dropDownSelectedString];
    [addedFiltersText appendString:@", "];
  }
  NSString *minOrder;
  
  if ([reqUtility.min_order_amount isEqual:@"10"]) {minOrder = @"$ & less";[addedFiltersText appendString:minOrder];}
  else if ([reqUtility.min_order_amount isEqual:@"100"]) {minOrder = @"$$ & less";[addedFiltersText appendString:minOrder];}
  else if ([reqUtility.min_order_amount isEqual:@"1000"]) {minOrder = @"$$$ & less";[addedFiltersText appendString:minOrder];}
  else if ([reqUtility.min_order_amount isEqual:@"10000"]) {minOrder = @"$$$$ & less";[addedFiltersText appendString:minOrder];}
  else if ([reqUtility.min_order_amount isEqual:@"100000"]) {minOrder = @"$$$$$ & less";[addedFiltersText appendString:minOrder];}
  else{minOrder = @"";}
  
  NSLog(@"addedFilterText = \n %@",addedFiltersText);
  
  NSString *filterTxt = [NSString stringWithFormat:@"\t%@", addedFiltersText];
  CGFloat lblHght = [self heightForLabel:self.addedFilterLabel withText:filterTxt];
  self.lblHghtConstraint.constant = lblHght+05;
  self.addedFilterLabel.text = filterTxt;
  NSString *allignedFilterText = filterTxt;
  if ([allignedFilterText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>1) {
  }
  if (addedFiltersText.length>0) {
    crossBtn.hidden = NO;
    self.addedFilterLabel.hidden = NO;
  }else{
    crossBtn.hidden = YES;
    self.addedFilterLabel.hidden = YES;
  }
  self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
  self.tableTopConstraint.constant = -5;
  
}

-(void)clearFliter{
  NSLog(@"clear filters clicked");
  self.addedFilterLabel.hidden = YES;
  self.resetFiltersView.hidden = NO;
  crossBtn.hidden = YES;
  [self.view bringSubviewToFront:self.resetFiltersView];
}

- (IBAction)resetFiltersCancelBtnClick:(id)sender {
  self.resetFiltersView.hidden = YES;
  self.addedFilterLabel.hidden = NO;
  crossBtn.hidden = YES;
}

- (IBAction)resetFiltersResetBtnClick:(id)sender {
  self.resetFiltersView.hidden = YES;
  self.addedFilterLabel.hidden = NO;
  [reqUtility.selectedCusinesArray removeAllObjects];
  [reqUtility.selectedFeaturesArray removeAllObjects];
  reqUtility.min_order_amount = @"no";
  reqUtility.ratings = 0;
  reqUtility.delivery_status = 0;
  reqUtility.sorting = @"no";
  reqUtility.isAsap = NO;
  self.addedFilterLabel.hidden = YES;
  crossBtn.hidden = YES;
  self.lblHghtConstraint.constant = 0;
  [self delegateDelivery];
}

-(CGFloat)heightForLabel:(UILabel *)label withText:(NSString *)text{
  
  NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:label.font}];
  CGRect rect = [attributedText boundingRectWithSize:(CGSize){label.frame.size.width, CGFLOAT_MAX}
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                             context:nil];
  
  return ceil(rect.size.height);
}

-(void)dp_Selected:(id)dp {
  NSString* selectedValue = [self.downPicker text];
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  fOperation.blnShowAlertMsg = YES;
  if ([selectedValue isEqualToString:@"Default"]) {
    reqUtility.sorting = @"";
    dropDownSelectedString = @"";
  }
  else if ([selectedValue isEqualToString:@"Restaurant Name"]) {
    reqUtility.sorting = @"order by ri.name asc";
    dropDownSelectedString = @"Restaurant Name";
  }else if([selectedValue isEqualToString:@"Price(Ascending)"]){
    reqUtility.sorting = @"order by rai.min_order_amount asc";
    dropDownSelectedString = @"Price(Ascending)";
  }else if([selectedValue isEqualToString:@"Price(Descending)"]){
    reqUtility.sorting = @"order by rai.min_order_amount desc";
    dropDownSelectedString = @"Price(Descending)";
  }else if([selectedValue isEqualToString:@"Rating"]){
    reqUtility.sorting = @"order by rai.rating desc";
    dropDownSelectedString = @"Rating";
  }else if([selectedValue isEqualToString:@"Delivery Estimate"]){
    reqUtility.sorting = @"order by rai.delivery_time asc";
    dropDownSelectedString = @"Delivery Estimate";
  }else if([selectedValue isEqualToString:@"Delivery Minimum"]){
    reqUtility.sorting = @"order by rdf.fee asc";
    dropDownSelectedString = @"Delivery Minimum";
  }else if([selectedValue isEqualToString:@"Pickup Estimate"]){
    reqUtility.sorting = @"order by rai.delivery_time asc";
    dropDownSelectedString = @"Pickup Estimate";
  }
  else{
  }
  [self updateFiltersLabel ];
  [fOperation  callAPIWithParamter:[reqUtility getParamsForUserFilters] success:^(BOOL success, id response) {
    NSDictionary *dictionary = [[NSDictionary alloc]init];
    if (response) {
      
      NSArray *array = [response valueForKey:@"data"];
      respoUtility.UserFiltersResponseArray = [[NSMutableArray alloc]init];
      for (int i = 0 ; i < [array count]; i++)
      {
        dictionary = [array objectAtIndex:i];
        ufpUtility = [[UserFiltersResponse alloc]init];
        ufpUtility.address_search = [dictionary valueForKey:@"address_search"];
        ufpUtility.closing_time = [dictionary valueForKey:@"closing_time"];
        ufpUtility.cuisine_string = [dictionary valueForKey:@"cuisine_string"];
        ufpUtility.day = [dictionary valueForKey:@"day"];
        ufpUtility.delivery_facility = [dictionary valueForKey:@"delivery_facility"];
        ufpUtility.delivery_time = [dictionary valueForKey:@"delivery_time"];
        ufpUtility.end_dist = [dictionary valueForKey:@"end_dist"];
        ufpUtility.fee = [dictionary valueForKey:@"fee"];
        ufpUtility.ufp_id = [dictionary valueForKey:@"id"];
        ufpUtility.logo = [dictionary valueForKey:@"logo"];
        ufpUtility.min_order_amount = [dictionary valueForKey:@"min_order_amount"];
        ufpUtility.name = [dictionary valueForKey:@"name"];
        ufpUtility.opening_status = [dictionary valueForKey:@"opening_status"];
        ufpUtility.opening_time = [dictionary valueForKey:@"opening_time"];
        ufpUtility.rating = [dictionary valueForKey:@"rating"];
        ufpUtility.restaurant_status = [dictionary valueForKey:@"restaurant_status"];
        ufpUtility.start_dist = [dictionary valueForKey:@"start_dist"];
        ufpUtility.pkDistance = [dictionary valueForKey:@"distance"];
        ufpUtility.imageStr = [dictionary valueForKey:@"image"];
        [[DBManager getSharedInstance] saveUserFilterResponse:ufpUtility];
        [respoUtility.UserFiltersResponseArray addObject:ufpUtility];
        
        
      }
      tempArray = [[NSMutableArray alloc]init];
      [tempArray addObjectsFromArray:respoUtility.UserFiltersResponseArray];
      [self.tableView reloadData];
      self.tableView.hidden = NO;
      noRestoLabel.hidden = YES;
      [appDelegate hideLoadingView];//after compltion close progress bar
    }else{
      [self showNoReastuarant ];
      self.tableView.hidden = YES;
      [appDelegate hideLoadingView];
    }
  } failure:^(BOOL failed, NSString *errorMessage) {
    [appDelegate hideLoadingView];
  }];
  
  
}

#pragma mark - Table view data source

- (CGFloat)tableView:(SKSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  CGFloat retval;
  if (tableView == ppTableView) {
    retval = 120.0;
  }else{
    retval = 145.0;
  }
  return retval;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger retval;
  if (tableView == ppTableView) {
    retval = allRestArray.count;
  }else{
    retval= [respoUtility.UserFiltersResponseArray count];
  }
  return retval;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell;
  if (tableView == ppTableView) {
    
    static NSString *cellIdentifier = @"HomeCartTableViewCell";
    
    HomeCartTableViewCell *cell = (HomeCartTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
      NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeCartTableViewCell" owner:self options:nil];
      cell = [nib objectAtIndex:0];
    }
    AllRestoCartData *cdata = (AllRestoCartData*)[allRestArray objectAtIndex:indexPath.row];
    cell.restName.text = cdata.rest_name;
    cell.noOfProds.text = [NSString stringWithFormat:@"%@ product(s)",cdata.orderCount];
    cell.orderType.text = [NSString stringWithFormat:@"Order Mode : %@",cdata.orderType];
    cell.goToResoBtn.tag = indexPath.row;
    cell.emptyCartBtn.tag = indexPath.row;
    [cell.goToResoBtn addTarget:self action:@selector(goToRest:) forControlEvents:UIControlEventTouchUpInside];
    [cell.emptyCartBtn addTarget:self action:@selector(EmptyCart:) forControlEvents:UIControlEventTouchUpInside];
    USerSelectedCartData *cd = (USerSelectedCartData*)[popRestArray objectAtIndex:indexPath.row];
    NSString *imglogo=cd.Logo;
    NSString *stringURL=@"http://mailer.mobisofttech.co.in/ymoc_portal_dev_latest/ymoc_main/upload/logo/medium/";
//    NSString *stringURL=@"http://ymoc.mobisofttech.co.in/ymoc_main/upload/logo/thumbnail/";
    

    NSString *url_Img_FULL = [stringURL stringByAppendingPathComponent:imglogo];
    if (imglogo) {
      cell.imgVw.showActivityIndicator = YES;
      cell.imgVw.imageURL = [NSURL URLWithString:url_Img_FULL];
      cell.imgVw.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return cell;
    
  }else{
    
    FrontHomeScreenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UserFiltersResponse *ufpRespo = [respoUtility.UserFiltersResponseArray objectAtIndex:indexPath.row];
    cell.lblName.text =ufpRespo.name;
    cell.lblCuisinString .text = ufpRespo.cuisine_string;
    NSString *orderValue = ufpRespo.min_order_amount;
    orderValue = [@"Min $ " stringByAppendingString:orderValue];
    cell.lblOrder.text =orderValue;
    NSString *feeValue = ufpRespo.fee;
    NSString *distanceValue = ufpRespo.pkDistance;
//    if (ufpRespo.cuisine_string.length>60) {
//      cell.cuisineStringHeightConstraint.constant = 48;
//    }else
      if(ufpRespo.cuisine_string.length>40) {
    cell.cuisineStringHeightConstraint.constant = 32;
    }else{
      cell.cuisineStringHeightConstraint.constant = 16;
    }
    if ([self.btnDelivery isEnabled]) {
      
      distanceValue = [@"Distance: " stringByAppendingString:distanceValue];
      cell.lblFee.text =distanceValue;
      cell.lblOrder.hidden =YES;
      cell.labelOrderHeightConstraint.constant = 4;
    }else{
      feeValue = [@"Delivery Fee $ " stringByAppendingString:feeValue];
      cell.lblFee.text =feeValue;
      cell.lblOrder.hidden =NO;
      cell.labelOrderHeightConstraint.constant = 16;
      
    }
    int rating = [ufpRespo.rating intValue];
    if (rating==1) {
      [cell.imgDollarVw setImage:[UIImage imageNamed:@"1d"]];
    }
    if (rating==2) {
      [cell.imgDollarVw setImage:[UIImage imageNamed:@"2d"]];
    }
    if (rating==3) {
      [cell.imgDollarVw setImage:[UIImage imageNamed:@"3d"]];
    }
    if (rating==4) {
      [cell.imgDollarVw setImage:[UIImage imageNamed:@"4d"]];
    }
    if (rating==5) {
      [cell.imgDollarVw setImage:[UIImage imageNamed:@"5d"]];
    }
    cell.lblRating.text = [NSString stringWithFormat:@"    %@",ufpRespo.rating];
    NSString *timeValue = ufpRespo.delivery_time;
    timeValue = [timeValue stringByAppendingString:@" Minutes"];
    cell.lbldeliveritime.text =timeValue;
    NSString *imglogo=ufpRespo.logo;

    
    NSString *stringURL=@"http://mailer.mobisofttech.co.in/ymoc_portal_dev_latest/ymoc_main/upload/logo/medium/";
    //    NSString *stringURL=@"http://ymoc.mobisofttech.co.in/ymoc_main/upload/logo/thumbnail/";
    
    NSString *url_Img_FULL = [stringURL stringByAppendingPathComponent:imglogo];
    if (imglogo) {
      cell.imgView.showActivityIndicator = YES;
      cell.imgView.imageURL = [NSURL URLWithString:url_Img_FULL];
      cell.imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    UIView *roundedView = [cell.contentView viewWithTag:20];
    if (roundedView == nil) {
      NSInteger spacingBothHorizontal = 20;
      CGRect customizedFrame = CGRectMake(spacingBothHorizontal/2, 0, CGRectGetWidth(cell.contentView.frame) - spacingBothHorizontal, CGRectGetHeight(cell.contentView.frame) - 10);
      roundedView = [[UIView alloc] initWithFrame:customizedFrame];
      roundedView.layer.cornerRadius = 5.0f;
      roundedView.backgroundColor = [UIColor whiteColor];
      roundedView.layer.shadowOffset = CGSizeMake(-1, -1);
      roundedView.layer.shadowOpacity = 2.0;
      roundedView.layer.shadowColor = [UIColor clearColor].CGColor;
      roundedView.tag = 100;
      
      if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
      }
      if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
      }
      if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
      }
      
      [cell.contentView addSubview:roundedView];
      [cell.contentView sendSubviewToBack:roundedView];
      cell.contentView.backgroundColor = [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1.0f];    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserFiltersResponse *ufpRespo = (UserFiltersResponse*)[respoUtility.UserFiltersResponseArray objectAtIndex:indexPath.row];
  didSelectedFilterRespo = ufpRespo;
  NSString *orderType = [[DBManager getSharedInstance]getOrderTypeForRestaurantID:[ufpRespo.ufp_id intValue]];
  
  if ([orderType isEqualToString:@"Delivery"]) {
    if ([self.btnPickup isEnabled]) {
        DetailViewController *obj_clvc  = (DetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewControllerId"];
      
        obj_clvc.selectedUfrespo = ufpRespo;
        [self.navigationController pushViewController:obj_clvc animated:YES];
    }else{
      //update ordertype and changeBtnType
       [self showOrderModeChangeAlertForRestID:ufpRespo andMsg:@"  You have cart filled with Delivery order mode and you have selected Pickup order mode. Please select order mode with you want to continue  "];
      
    }
    
  }else if([orderType isEqualToString:@"PickUp"]){
    
    if ([self.btnDelivery isEnabled]) {
      DetailViewController *obj_clvc  = (DetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewControllerId"];
      
      obj_clvc.selectedUfrespo = ufpRespo;
      [self.navigationController pushViewController:obj_clvc animated:YES];
    }else{
      //update ordertype and changeBtnType
     [self showOrderModeChangeAlertForRestID:ufpRespo andMsg:@"  You have cart filled with Pickup order mode and you have selected Delivery order mode. Please select order mode with you want to continue  "];
    }
  
  }else{
    DetailViewController *obj_clvc  = (DetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewControllerId"];
    
    obj_clvc.selectedUfrespo = ufpRespo;
    [self.navigationController pushViewController:obj_clvc animated:YES];
  
  }
  

}

-(void)showOrderModeChangeAlertForRestID:(UserFiltersResponse*)ufrespo andMsg:(NSString*)msgStr{

  float screenWidth = [[UIScreen mainScreen] bounds].size.width;
  float screenheight = [[UIScreen mainScreen] bounds].size.height;
  fullscreenView.frame = self.view.bounds;
  fullscreenView.backgroundColor = [UIColor blackColor];
  UITapGestureRecognizer *singleFingerTap =
  [[UITapGestureRecognizer alloc] initWithTarget:self
                                          action:@selector(handleSingleTap:)];
  [fullscreenView addGestureRecognizer:singleFingerTap];
  fullscreenView.hidden = NO;
  alertView.hidden = NO;
  fullscreenView.alpha = 0.5;
  [self.view addSubview:fullscreenView];
  [self.view bringSubviewToFront:fullscreenView];
  
  
  alertView.backgroundColor = [UIColor whiteColor];
  [alertView setFrame:CGRectMake(10, screenheight/2-100, screenWidth-20, 180)];
  UIImageView *imgView = [[UIImageView alloc]init];
  [imgView setFrame:CGRectMake(screenWidth/2-100, 10, 200, 40)];
  [imgView setImage: [UIImage imageNamed:@"ymoc_login_logo.png"]];
  [alertView addSubview:imgView];
  
  
  UILabel *fromLabel = [[UILabel alloc]init];
  [fromLabel setFrame:CGRectMake(0, 50, screenWidth-20, 65)];
  fromLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
  fromLabel.text = msgStr;
  fromLabel.numberOfLines = 4;
  fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
  fromLabel.adjustsFontSizeToFitWidth = YES;
  fromLabel.minimumScaleFactor = 10.0f/12.0f;
  fromLabel.clipsToBounds = YES;
  fromLabel.backgroundColor = [UIColor clearColor];
  fromLabel.textColor = [UIColor blackColor];
  fromLabel.textAlignment = NSTextAlignmentCenter;
  [alertView addSubview:fromLabel];
  
  UIButton *deliveryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [deliveryBtn addTarget:self
             action:@selector(deliveryBtnClicked)
   forControlEvents:UIControlEventTouchUpInside];
  [deliveryBtn setTitle:@"Delivery" forState:UIControlStateNormal];
  deliveryBtn.frame = CGRectMake(screenWidth/2-125, 120, 120, 40.0);
  deliveryBtn.backgroundColor = [UIColor colorWithRed:71/255.0f green:202/255.0f blue:75/255.0f alpha:1.0f];
  [alertView addSubview:deliveryBtn];
  
  UIButton *pickUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [pickUpBtn addTarget:self
             action:@selector(pickUpBtnClicked)
   forControlEvents:UIControlEventTouchUpInside];
  [pickUpBtn setTitle:@"Pickup" forState:UIControlStateNormal];
  pickUpBtn.frame = CGRectMake(screenWidth/2+5, 120, 120, 40.0);
  pickUpBtn.backgroundColor = [UIColor colorWithRed:101/255.0f green:220/255.0f blue:243/255.0f alpha:1.0f];
  [alertView addSubview:pickUpBtn];
  [self.view addSubview:alertView];
  [self.view bringSubviewToFront:alertView];
}

-(void)deliveryBtnClicked{
  fullscreenView.hidden = YES;
  alertView.hidden = YES;
  [fullscreenView removeFromSuperview];
  
  BOOL retval = [[DBManager getSharedInstance]updateOrderModeIntoDB:didSelectedFilterRespo.ufp_id andOrderMode:@"Delivery"];
  if (retval) {
//    [self btndelivery:self];
    DetailViewController *obj_clvc  = (DetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewControllerId"];
    obj_clvc.selectedUfrespo = didSelectedFilterRespo;
    [self.navigationController pushViewController:obj_clvc animated:YES];
  }else{
  //Failed to update order mode
  }
  
}

-(void)pickUpBtnClicked{
  fullscreenView.hidden = YES;
  alertView.hidden = YES;
  [fullscreenView removeFromSuperview];
  
  BOOL retval = [[DBManager getSharedInstance]updateOrderModeIntoDB:didSelectedFilterRespo.ufp_id andOrderMode:@"PickUp"];
  if (retval) {
//    [self btnpickup:self];
    DetailViewController *obj_clvc  = (DetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewControllerId"];
    obj_clvc.selectedUfrespo = didSelectedFilterRespo;
    [self.navigationController pushViewController:obj_clvc animated:YES];
  }else{
    //Failed to update order mode
  }
  
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
  fullscreenView.hidden = YES;
  alertView.hidden = YES;
  [fullscreenView removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

-(IBAction)goToRest:(id)sender{
  UIButton *btn = ((UIButton*)sender);
  NSLog(@"%ld",(long)btn.tag);
  [self RemovecartPpUp];
  USerSelectedCartData *data = (USerSelectedCartData*)[popRestArray objectAtIndex:btn.tag];
  if ([data.ordertype isEqualToString:@"PickUp"]) {
    reqUtility.selectedOrderType = @"PickUp";
    reqUtility.delivery_status = 0;
  }else if([data.ordertype isEqualToString:@"Delivery"]){
    reqUtility.selectedOrderType = @"Delivery";
    reqUtility.delivery_status = 1;
  }else{
    if ([data.ordertype isEqualToString:@"PickUp"]) {
      reqUtility.delivery_status = 0;
    }else{
      reqUtility.delivery_status = 1;
    }
    reqUtility.selectedOrderType  = @"ASAP";
  }
  NSString *ID = [NSString stringWithFormat:@"%ld",(long)data.restaurant_Id];
  UserFiltersResponse *frsp = [[DBManager getSharedInstance]getUserFilterData:ID];
  DetailViewController *obj_clvc  = (DetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewControllerId"];
  obj_clvc.selectedUfrespo = frsp;
  
  [self.navigationController pushViewController:obj_clvc animated:YES];
}

-(IBAction)EmptyCart:(id)sender{
  UIButton *btn = ((UIButton*)sender);
  NSLog(@"%ld",(long)btn.tag);
  [self RemovecartPpUp];
  USerSelectedCartData *data = (USerSelectedCartData*)[popRestArray objectAtIndex:btn.tag];
  NSString *ID = [NSString stringWithFormat:@"%ld",(long)data.restaurant_Id];
  int IDREST = [ID intValue];
  [[DBManager getSharedInstance]deleteRecord:IDREST andOrderType:data.ordertype];
  [self showCartView];
}

- (IBAction)btnpickup:(id)sender {
  reqUtility.selectedOrderType = @"PickUp";
  bandArray = [[NSMutableArray alloc] init];
  [bandArray addObject:@"Default"];
  [bandArray addObject:@"Restaurant Name"];
  [bandArray addObject:@"Price(Ascending)"];
  [bandArray addObject:@"Price(Descending)"];
  [bandArray addObject:@"Rating"];
  [bandArray addObject:@"Pickup Estimate"];
  //  [bandArray addObject:@"Delivery Minimum"];
  self.downPicker = [[DownPicker alloc] initWithTextField:self.dropdown withData:bandArray];
  [self.downPicker addTarget:self
                      action:@selector(dp_Selected:)
            forControlEvents:UIControlEventValueChanged];
  [self.btnPickup setEnabled:NO];
  [self.btnDelivery setEnabled:YES];
  self.btnPickup.backgroundColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0f];
  self.btnDelivery.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  fOperation.blnShowAlertMsg = YES;
  //  fOperation.delivery_status = 0;
  reqUtility.delivery_status = 0;
  [self updateFiltersLabel ];
  [fOperation  callAPIWithParamter:[reqUtility getParamsForUserFilters] success:^(BOOL success, id response) {
    NSDictionary *dictionary = [[NSDictionary alloc]init];
    if (response) {
      
      self.array = [response valueForKey:@"data"];
      respoUtility.UserFiltersResponseArray = [[NSMutableArray alloc]init];
      for (int i = 0 ; i < [self.array count]; i++)
      {
        dictionary = [self.array objectAtIndex:i];
        ufpUtility = [[UserFiltersResponse alloc]init];
        ufpUtility.address_search = [dictionary valueForKey:@"address_search"];
        ufpUtility.closing_time = [dictionary valueForKey:@"closing_time"];
        ufpUtility.cuisine_string = [dictionary valueForKey:@"cuisine_string"];
        ufpUtility.day = [dictionary valueForKey:@"day"];
        ufpUtility.delivery_facility = [dictionary valueForKey:@"delivery_facility"];
        ufpUtility.delivery_time = [dictionary valueForKey:@"delivery_time"];
        ufpUtility.end_dist = [dictionary valueForKey:@"end_dist"];
        ufpUtility.fee = [dictionary valueForKey:@"fee"];
        ufpUtility.ufp_id = [dictionary valueForKey:@"id"];
        ufpUtility.logo = [dictionary valueForKey:@"logo"];
        ufpUtility.min_order_amount = [dictionary valueForKey:@"min_order_amount"];
        ufpUtility.name = [dictionary valueForKey:@"name"];
        ufpUtility.opening_status = [dictionary valueForKey:@"opening_status"];
        ufpUtility.opening_time = [dictionary valueForKey:@"opening_time"];
        ufpUtility.rating = [dictionary valueForKey:@"rating"];
        ufpUtility.restaurant_status = [dictionary valueForKey:@"restaurant_status"];
        ufpUtility.start_dist = [dictionary valueForKey:@"start_dist"];
        ufpUtility.pkDistance = [dictionary valueForKey:@"distance"];
        ufpUtility.imageStr = [dictionary valueForKey:@"image"];
        [[DBManager getSharedInstance] saveUserFilterResponse:ufpUtility];
        [respoUtility.UserFiltersResponseArray addObject:ufpUtility];
      }
      tempArray = [[NSMutableArray alloc]init];
      [tempArray addObjectsFromArray:respoUtility.UserFiltersResponseArray];
      [self.tableView reloadData];
      self.tableView.hidden = NO;
      noRestoLabel.hidden = YES;
      [appDelegate hideLoadingView];//after compltion close progress bar
    }else{
      [self showNoReastuarant ];
      self.tableView.hidden = YES;
      [appDelegate hideLoadingView];
    }
  } failure:^(BOOL failed, NSString *errorMessage) {
    [appDelegate hideLoadingView];
  }];
  
}

- (IBAction)btndelivery:(id)sender {
  bandArray = [[NSMutableArray alloc] init];
  [bandArray addObject:@"Default"];
  [bandArray addObject:@"Restaurant Name"];
  [bandArray addObject:@"Price(Ascending)"];
  [bandArray addObject:@"Price(Descending)"];
  [bandArray addObject:@"Rating"];
  [bandArray addObject:@"Delivery Estimate"];
  [bandArray addObject:@"Delivery Minimum"];
  reqUtility.selectedOrderType = @"Delivery";
  self.downPicker = [[DownPicker alloc] initWithTextField:self.dropdown withData:bandArray];
  [self.downPicker addTarget:self
                      action:@selector(dp_Selected:)
            forControlEvents:UIControlEventValueChanged];
  [self.btnPickup setEnabled:YES];
  [self.btnDelivery setEnabled:NO];
  self.btnDelivery.backgroundColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0f];
  self.btnPickup.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
  reqUtility.delivery_status = 1;
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  fOperation.blnShowAlertMsg = YES;
  //  fOperation.delivery_status = 1;
  [self updateFiltersLabel ];
  [fOperation  callAPIWithParamter:[reqUtility getParamsForUserFilters] success:^(BOOL success, id response) {
    NSDictionary *dictionary = [[NSDictionary alloc]init];
    if (response) {
      
      self.array = [response valueForKey:@"data"];
      
      respoUtility.UserFiltersResponseArray = [[NSMutableArray alloc]init];
      
      for (int i = 0 ; i < [self.array count]; i++)
      {
        dictionary = [self.array objectAtIndex:i];
        ufpUtility = [[UserFiltersResponse alloc]init];
        ufpUtility.address_search = [dictionary valueForKey:@"address_search"];
        ufpUtility.closing_time = [dictionary valueForKey:@"closing_time"];
        ufpUtility.cuisine_string = [dictionary valueForKey:@"cuisine_string"];
        ufpUtility.day = [dictionary valueForKey:@"day"];
        ufpUtility.delivery_facility = [dictionary valueForKey:@"delivery_facility"];
        ufpUtility.delivery_time = [dictionary valueForKey:@"delivery_time"];
        ufpUtility.end_dist = [dictionary valueForKey:@"end_dist"];
        ufpUtility.fee = [dictionary valueForKey:@"fee"];
        ufpUtility.ufp_id = [dictionary valueForKey:@"id"];
        ufpUtility.logo = [dictionary valueForKey:@"logo"];
        ufpUtility.min_order_amount = [dictionary valueForKey:@"min_order_amount"];
        ufpUtility.name = [dictionary valueForKey:@"name"];
        ufpUtility.opening_status = [dictionary valueForKey:@"opening_status"];
        ufpUtility.opening_time = [dictionary valueForKey:@"opening_time"];
        ufpUtility.rating = [dictionary valueForKey:@"rating"];
        ufpUtility.restaurant_status = [dictionary valueForKey:@"restaurant_status"];
        ufpUtility.start_dist = [dictionary valueForKey:@"start_dist"];
        ufpUtility.pkDistance = [dictionary valueForKey:@"distance"];
        ufpUtility.imageStr = [dictionary valueForKey:@"image"];
        [[DBManager getSharedInstance] saveUserFilterResponse:ufpUtility];
        [respoUtility.UserFiltersResponseArray addObject:ufpUtility];
      }
      tempArray = [[NSMutableArray alloc]init];
      [tempArray addObjectsFromArray:respoUtility.UserFiltersResponseArray];
      [self.tableView reloadData];
      self.tableView.hidden = NO;
      noRestoLabel.hidden = YES;
      [appDelegate hideLoadingView];//after compltion close progress bar
    }else{
      [self showNoReastuarant ];
      self.tableView.hidden = YES;
      [appDelegate hideLoadingView];
    }
  } failure:^(BOOL failed, NSString *errorMessage) {
    [appDelegate hideLoadingView];
  }];
  
}

- (IBAction)btnsort:(id)sender {
  
}
- (IBAction)btnRightMenu:(id)sender {
  [self.view endEditing:YES];
  RightMenuViewController *obj_clvc  = (RightMenuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"rightmenucontroller"];
  obj_clvc.rmdelegate = self;
  [self.navigationController pushViewController:obj_clvc animated:YES];
  
}

- (IBAction)btnSearchMenu:(id)sender {
//  [self.searchTxtFld becomeFirstResponder];
//  self.searchTxtFld.text= @"";
//  self.searchArea.hidden = NO;
//  
//}
  GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
  acController.delegate = self;
  [acController.view setFrame:CGRectMake(50, 50, 200, 200)];
  acController.view.backgroundColor = [UIColor blackColor ];
  
  [UIColor colorWithRed:(213/255.f) green:(213/255.f) blue:(213/255.f) alpha:1.0f];
  [UIColor colorWithRed:188.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0];
  [UIColor colorWithRed:112/255.0 green:170.0/255.0 blue:157.0/255.0 alpha:1.0];
  acController.tableCellBackgroundColor = [UIColor colorWithRed:112/255.0 green:170.0/255.0 blue:157.0/255.0 alpha:1.0];;
  acController.tableCellSeparatorColor = [UIColor whiteColor];
  acController.primaryTextColor = [UIColor whiteColor];
  acController.secondaryTextColor = [UIColor whiteColor];
  acController.primaryTextHighlightColor = [UIColor whiteColor];
  [self presentViewController:acController animated:YES completion:nil];
  
}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
  [self dismissViewControllerAnimated:YES completion:nil];
  // Do something with the selected place.
  NSLog(@"Place name %@", place.name);
  NSLog(@"Place address %@", place.formattedAddress);
  NSLog(@"Place attributions %@", place.attributions.string);
  respoUtility.enteredAddress = place.formattedAddress;
//  self.titleLbl.text = respoUtility.enteredAddress;
//    self.addressBtn.text = respoUtility.enteredAddress;
  NSString *cityValueText = [NSString stringWithFormat:@" %@",respoUtility.enteredAddress];
  self.addressBtn.text = cityValueText;
  [self delegateDelivery];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
  [self dismissViewControllerAnimated:YES completion:nil];
  // TODO: handle the error.
  NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
  [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
  [self updateFilteredContentForProductName: newString type:newString];
  
  return YES;
}


#pragma mark - Content Filtering

- (void)updateFilteredContentForProductName:(NSString *)productName type:(NSString *)typeName {
  [respoUtility.UserFiltersResponseArray removeAllObjects];
  for (UserFiltersResponse *product in tempArray) {
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    NSRange productNameRange = NSMakeRange(0, product.name.length);
    NSRange foundRange = [product.name rangeOfString:productName options:searchOptions range:productNameRange];
    if (foundRange.length > 0) {
      NSLog(@"added name %@",product.name);
      [respoUtility.UserFiltersResponseArray addObject:product];
    }
  }
  if ([productName isEqual:@""]||[typeName isEqual:@""]) {
    [respoUtility.UserFiltersResponseArray removeAllObjects];
    [respoUtility.UserFiltersResponseArray addObjectsFromArray:tempArray];
  }
  [self.tableView reloadData];
  self.tableView.hidden = NO;
  noRestoLabel.hidden = YES;
}

- (IBAction)searchBackBtnClick:(id)sender {
  
  [self.searchTxtFld resignFirstResponder];
  [self.view endEditing:YES];
  self.searchTxtFld.text= @"";
  self.searchArea.hidden = YES;
  [respoUtility.UserFiltersResponseArray removeAllObjects];
  [respoUtility.UserFiltersResponseArray addObjectsFromArray:tempArray];
  [self.tableView reloadData];
  self.tableView.hidden = NO;
  noRestoLabel.hidden = YES;
}

-(void)delegateDelivery{
  reqUtility.selectedOrderType = @"Delivery";
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  fOperation.blnShowAlertMsg = YES;
  if (self.btnDelivery.isEnabled) {
    
  }else{reqUtility.delivery_status = 1;}
  [self updateFiltersLabel ];
  [fOperation  callAPIWithParamter:[reqUtility getParamsForUserFilters] success:^(BOOL success, id response) {
    NSDictionary *dictionary = [[NSDictionary alloc]init];
    if (response) {
      
      self.array = [response valueForKey:@"data"];
      
      respoUtility.UserFiltersResponseArray = [[NSMutableArray alloc]init];
      
      for (int i = 0 ; i < [self.array count]; i++)
      {
        dictionary = [self.array objectAtIndex:i];
        ufpUtility = [[UserFiltersResponse alloc]init];
        ufpUtility.address_search = [dictionary valueForKey:@"address_search"];
        ufpUtility.closing_time = [dictionary valueForKey:@"closing_time"];
        ufpUtility.cuisine_string = [dictionary valueForKey:@"cuisine_string"];
        ufpUtility.day = [dictionary valueForKey:@"day"];
        ufpUtility.delivery_facility = [dictionary valueForKey:@"delivery_facility"];
        ufpUtility.delivery_time = [dictionary valueForKey:@"delivery_time"];
        ufpUtility.end_dist = [dictionary valueForKey:@"end_dist"];
        ufpUtility.fee = [dictionary valueForKey:@"fee"];
        ufpUtility.ufp_id = [dictionary valueForKey:@"id"];
        ufpUtility.logo = [dictionary valueForKey:@"logo"];
        ufpUtility.min_order_amount = [dictionary valueForKey:@"min_order_amount"];
        ufpUtility.name = [dictionary valueForKey:@"name"];
        ufpUtility.opening_status = [dictionary valueForKey:@"opening_status"];
        ufpUtility.opening_time = [dictionary valueForKey:@"opening_time"];
        ufpUtility.rating = [dictionary valueForKey:@"rating"];
        ufpUtility.restaurant_status = [dictionary valueForKey:@"restaurant_status"];
        ufpUtility.start_dist = [dictionary valueForKey:@"start_dist"];
        ufpUtility.pkDistance = [dictionary valueForKey:@"distance"];
        ufpUtility.imageStr = [dictionary valueForKey:@"image"];
        [[DBManager getSharedInstance] saveUserFilterResponse:ufpUtility];
        [respoUtility.UserFiltersResponseArray addObject:ufpUtility];
      }
      tempArray = [[NSMutableArray alloc]init];
      [tempArray addObjectsFromArray:respoUtility.UserFiltersResponseArray];
      [self.tableView reloadData];
      self.tableView.hidden = NO;
      noRestoLabel.hidden = YES;
      [appDelegate hideLoadingView];//after compltion close progress bar
    }else{
      [self showNoReastuarant ];
      self.tableView.hidden = YES;
      [appDelegate hideLoadingView];
    }
    
  } failure:^(BOOL failed, NSString *errorMessage) {
    [appDelegate hideLoadingView];
  }];
  
}

-(void)showNoReastuarant{
  
  
  //  [lbl1 setCenter:self.view.center];
  noRestoLabel.hidden = NO;
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screenRect.size.width;
  CGFloat screenHeight = screenRect.size.height;
  
  [noRestoLabel setFrame:CGRectMake(screenWidth/2-100, screenHeight/2-20, screenWidth, 40)];
  noRestoLabel.backgroundColor=[UIColor clearColor];
  noRestoLabel.textColor=[UIColor redColor];
  noRestoLabel.userInteractionEnabled=NO;
  noRestoLabel.text= @"No reastuarant available";
  [self.view addSubview:noRestoLabel];
  [self.view bringSubviewToFront:noRestoLabel];
}

-(void)RemovecartPpUp{
  
  popUpView.hidden = YES;
  coverView.hidden = YES;
    trsnparentView.hidden = YES;
  [trsnparentView removeFromSuperview];
  [coverView removeFromSuperview];
  [popUpView removeFromSuperview];

  [self.view removeGestureRecognizer:tap];
  
}

@end





