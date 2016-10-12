//
//  DetailViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/23/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "DetailViewController.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "AppDelegate.h"
#import "DetailTableViewCell.h"
#import "CuisineDetailOperation.h"
#import <QuartzCore/QuartzCore.h>
#import "RequestUtility.h"
#import "CustomizeOptionTableViewCell.h"
#import "CartViewController.h"
#import "DBManager.h"
#import "Utility.h"
#import "AdditionalInfoViewController.h"
#import "DisplayRatingsViewController.h"
@interface DetailViewController ()<UITextViewDelegate>{
  
  NSMutableArray *sectionArray;
  AppDelegate *appDelegate;
  CuisineDetailOperation *cdOperation;
  NSMutableDictionary *responseDict;
  UIScrollView* coverView;
  UIView *popUpView;
  UIView *popVw;
  UIView *mainView;
  UITableView *ppTableView;
  NSMutableArray *selectedCustomCuisineStringArray;
  NSMutableArray *selectedCustomCuisinePriceArray;
  NSMutableArray *selectedCustomCuisineIdArray;
  UILabel *lbl4;
  float totalprice,menuPrice;
  float didSelectSubRowPrice;
  UIButton *CartButton;
  UILabel*label;
  BOOL isCustomizable;
  UITextView *myTextView;
  NSInteger currentUID;
  NSString *subID,*catName,*subCatName,*newprice;
  NSMutableArray *temporayUniqueID;
}

@end

@implementation DetailViewController
@synthesize selectedUfrespo;

- (void)viewDidLoad {
  [super viewDidLoad];
  label=[[UILabel alloc]init];
  label.text=selectedUfrespo.name;
  label.adjustsFontSizeToFitWidth=YES;
  label.minimumScaleFactor=0.5;
//  if (label.text.length>17) {
//    [label setFont:[UIFont systemFontOfSize:15]];
//  }else{
//  [label setFont:[UIFont systemFontOfSize:17]];
//  }
  label.textColor = [UIColor whiteColor];
  label.frame=CGRectMake(321, 10, 300, 30);
  UIFont* boldFont = [UIFont boldSystemFontOfSize:20];
  [label setFont:boldFont];
  [self.imgVw addSubview:label];
  [self configureRatingsandPricing];
  [UIView animateWithDuration:9.0 delay:0.0 options: UIViewAnimationOptionRepeat
                   animations:^{
                     label.frame=CGRectMake(-300, 10, 300, 30);
                   }completion:^(BOOL finished){
                   }];
  
  dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){

  NSString *stringURL=@"http://mailer.mobisofttech.co.in/ymoc_portal_dev_latest/ymoc_main/upload/image/";
  //    NSString *stringURL=@"http://ymoc.mobisofttech.co.in/ymoc_main/upload/logo/thumbnail/";
  
  NSString *url_Img_FULL = [stringURL stringByAppendingPathComponent:selectedUfrespo.imageStr];
  if (selectedUfrespo.imageStr) {
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url_Img_FULL]];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imgVw.image = [UIImage imageWithData:imageData];
    });
  }
  });
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screenRect.size.height;
  CGFloat screenWidth = screenRect.size.width;
  CartButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [CartButton addTarget:self
                 action:@selector(showCartView)
       forControlEvents:UIControlEventTouchUpInside];
  [CartButton setTitle:@"1" forState:UIControlStateNormal];
  //  [CartButton setBackgroundImage:[UIImage imageNamed:@"added_cart_img.png"] forState:UIControlStateNormal];
  UIImageView *btnImg = [[UIImageView alloc]initWithFrame:CGRectMake(2.5, 7.5, 45,35)];
  [btnImg setImage:[UIImage imageNamed:@"added_cart_img.png"]];
  [CartButton addSubview:btnImg];
   CartButton.layer.cornerRadius = 25;
  CartButton.frame = CGRectMake(screenWidth-70, screenHeight-70, 50,50 );
  CartButton.backgroundColor = [UIColor colorWithRed:170.0/255.0 green:213.0/255.0 blue:92.0/255.0 alpha:1.0];
  [self.view addSubview:CartButton];
  
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  label.hidden = NO;
  [RequestUtility sharedRequestUtility].selectedAddressId = @"-1";
  self.navigationController.navigationBarHidden = YES;
  selectedCustomCuisineStringArray = [[NSMutableArray alloc]init];
  selectedCustomCuisinePriceArray = [[NSMutableArray alloc]init];
  selectedCustomCuisineIdArray = [[NSMutableArray alloc]init];
  self.navigationController.navigationBarHidden = YES;
  if (selectedUfrespo.name.length>17) {
    [self.navTitle setFont:[UIFont systemFontOfSize:15]];
  }else{
    [self.navTitle setFont:[UIFont systemFontOfSize:17]];
  }
  self.navTitle.text = selectedUfrespo.name;
  
  self.opaqueView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
  self.opaqueView.layer.cornerRadius = 10.0;
  self.tableVw.SKSTableViewDelegate = self;
  self.lbl1.text = selectedUfrespo.cuisine_string;
  self.ratingsView.rating = [selectedUfrespo.rating floatValue];
  self.minOrderLbl.text = [NSString stringWithFormat:@"Min. Order: $ %@",selectedUfrespo.min_order_amount];
  self.deliveryLbl.text = [NSString stringWithFormat:@"Delivery Fee: %@",selectedUfrespo.fee];
  self.waitTimeLbl.text = [NSString stringWithFormat:@"Est. Wait: %@ Minutes",selectedUfrespo.delivery_time];
  if ( [[RequestUtility sharedRequestUtility].selectedOrderType  isEqual: @"PickUp"]) {
    self.deliveryLbl.text = [NSString stringWithFormat:@"Distance: %@",selectedUfrespo.pkDistance];
  }
  cdOperation = [[CuisineDetailOperation alloc]init];
  cdOperation.selectedId = selectedUfrespo.ufp_id;
  sectionArray = [[NSMutableArray alloc]init];
  responseDict = [[NSMutableDictionary alloc]init];
  
  NSArray *arr = [[DBManager getSharedInstance] getALlCartData:[selectedUfrespo.ufp_id intValue]];
  if (arr.count>0) {
    [CartButton setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)arr.count] forState:UIControlStateNormal];
    CartButton.hidden = NO;
  }else{
    [CartButton setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)arr.count] forState:UIControlStateNormal];
    CartButton.hidden = YES;
  }
  

}

-(void)configureRatingsandPricing{
  self.ratingsView.notSelectedImage = [UIImage imageNamed:@"star23.png"];
  //  self.rateView.halfSelectedImage = [UIImage imageNamed:@"kermit_half.png"];
  self.ratingsView.fullSelectedImage = [UIImage imageNamed:@"star12.png"];
  //  self.ratingsView.rating = 3;
  self.ratingsView.editable = NO;
  self.ratingsView.maxRating = 5;
}

-(void)viewDidAppear:(BOOL)animated{
    [self getDetailCuisine];
  NSArray *arr = [[DBManager getSharedInstance] getALlCartData:[selectedUfrespo.ufp_id intValue]];
  if (arr.count>0) {
    CartButton.hidden = NO;
    [CartButton setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)arr.count] forState:UIControlStateNormal];
  }else{
    CartButton.hidden = YES;
  }
  
  
}



- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  label.hidden = YES;
  self.navigationController.navigationBarHidden = YES;
}

-(void)getDetailCuisine{
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  [cdOperation  callAPIWithParamter:nil success:^(BOOL success, id response) {
    
    NSLog(@"%@",response);
    NSDictionary *sectionDictionary = [response valueForKey:@"category_list"];
    if (sectionDictionary.count>0) {
      
      sectionArray = (NSMutableArray*)[sectionDictionary allKeys];
      NSLog(@"%@",response);
      int k =1;
      if (sectionArray.count>0) {
        for (int i =0; i<sectionArray.count; i++) {
          NSArray *respo = [sectionDictionary valueForKey:[sectionArray objectAtIndex:i]];
          NSDictionary *keyDict = [sectionDictionary valueForKey:[sectionArray objectAtIndex:i]];
          NSArray *key = [keyDict allKeys];
          NSMutableArray *cdArray = [[NSMutableArray alloc]init];
          for (int i =0; i<respo.count; i++) {
            CuisineDetailResponse *cdRespo = [[CuisineDetailResponse alloc]init];
            cdRespo.customizable = [[respo valueForKey:[key objectAtIndex:i]]valueForKey:@"customizable"];
            cdRespo.cdescription = [[respo valueForKey:[key objectAtIndex:i]]valueForKey:@"description"];
            cdRespo.cuisine_id = [[respo valueForKey:[key objectAtIndex:i]]valueForKey:@"id"];
            cdRespo.price = [[respo valueForKey:[key objectAtIndex:i]]valueForKey:@"price"];
            cdRespo.sub_category = [[respo valueForKey:[key objectAtIndex:i]]valueForKey:@"sub_category"];
            cdRespo.rest_id = [key objectAtIndex:i ];
            [cdArray addObject:cdRespo];
            k++;
          }
          [responseDict setObject:cdArray forKey:[sectionArray objectAtIndex:i]];
          
          NSLog(@"%@",responseDict);
        }
      }
      NSMutableArray *outerArray = [[NSMutableArray alloc]init];
      for (int i =0; i<responseDict.count; i++) {
        NSMutableArray *innerArray = [[NSMutableArray alloc]init];
        [innerArray addObject:[sectionArray objectAtIndex:i]];
        [innerArray addObjectsFromArray:[responseDict valueForKey:[sectionArray objectAtIndex:i]]];
        [outerArray addObject:innerArray];
        NSLog(@"innerArray %@",innerArray);
        NSLog(@"outer Array %@",outerArray);
      }
      
      NSMutableArray *finalArr = [[NSMutableArray alloc]init];
      [finalArr addObjectsFromArray:outerArray];
      
      self.contents  = [[NSMutableArray alloc]init];
      [self.contents addObject:finalArr];
      NSLog(@"content Array %@",self.contents);
      dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate hideLoadingView];
        [self.tableVw reloadData];
        self.tableVw.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
      });
    }else{
      dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate hideLoadingView];
        [self.tableVw reloadData];
        self.tableVw.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
      });
    }
  } failure:^(BOOL failed, NSString *errorMessage) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [appDelegate hideLoadingView];
    });
  }];
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
  CGFloat retval;
  if (tableView == ppTableView) {
    retval = 20;
  }else{
    retval = 75.0;
  }
  return retval;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  if (tableView == ppTableView) {
    return 1;
  }
  return [self.contents count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (tableView == ppTableView) {
    return [ResponseUtility getSharedInstance].CustomizeMenuArray.count;
  }
  return [self.contents[section] count];
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
  return [self.contents[indexPath.section][indexPath.row] count] - 1;
}

- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 1 && indexPath.row == 0)
  {
    return YES;
  }
  
  return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
      cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = self.contents[indexPath.section][indexPath.row][0];
    cell.expandable = YES;
    UIFont* boldFont = [UIFont boldSystemFontOfSize:18.0];
    [cell.textLabel setFont:boldFont];
    cell.backgroundColor = [UIColor colorWithRed:(213/255.f) green:(213/255.f) blue:(213/255.f) alpha:1.0f];
    cell.textLabel.textColor = [UIColor colorWithRed:188.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0];
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth+10, 2)];/// change size as you need.
    separatorLineView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:separatorLineView];
    retcell = cell;
  }
  return retcell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"DetailTableViewCell";
  
  DetailTableViewCell *cell = (DetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if(cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
  }
  CuisineDetailResponse *resp = self.contents[indexPath.section][indexPath.row][indexPath.subRow];
  cell.titleLbl.text = resp.sub_category;
  cell.detailLbl.text = resp.cdescription;
  NSString *dlength = resp.cdescription;
  if (dlength.length <1) {
    //    cell.titleLbl.frame = CGRectMake(cell.titleLbl.frame.origin.x, 50, cell.titleLbl.frame.size.width, cell.titleLbl.frame.size.height);
    cell.topMargin.constant = -14;
  }else{
    cell.topMargin.constant = 0;
  }
  cell.rateLbl.text = [NSString stringWithFormat:@"$%@",resp.price];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  UIFont* boldFont = [UIFont boldSystemFontOfSize:16.0];
  [cell.titleLbl setFont:boldFont];
  //  cell.backgroundColor = [UIColor grayColor];
  return cell;
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CGFloat retval;
  if (tableView == ppTableView) {
    retval = 35;
  }else{
    retval = 60.0;
  }
  return retval;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"Section: %ld, Row:%ld, Subrow:%ld", (long)indexPath.section, (long)indexPath.row, (long)indexPath.
        subRow);
  
  
  catName = self.contents[indexPath.section][indexPath.row][0];
}

- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"Section: %ld, Row:%ld, Subrow:%ld", (long)indexPath.section, (long)indexPath.row, (long)indexPath.subRow);
  //  [self adPopUpMenu];
  CuisineDetailResponse *resp = self.contents[indexPath.section][indexPath.row][indexPath.subRow];
  didSelectSubRowPrice = [resp.price floatValue];
  NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
  [dict setValue:@"get_customization_option" forKey:@"action"];
  [dict setValue:selectedUfrespo.ufp_id forKey:@"restaurant_id"];
  [dict setValue:resp.cuisine_id forKey:@"sub_category_id"];
  [self getOptionToCustomizedCuisine:dict];
  //  cart.subCategory_Id = [cmenu.c_id integerValue];
  //  cart.category_Name = cmenu.category;
  //  cart.sub_category_Name = cmenu.sub_category;
  subCatName = resp.sub_category;
  subID =resp.cuisine_id;
  newprice = resp.price;
  
}

- (void) handleChecking:(UITapGestureRecognizer *)tapRecognizer {
  CGPoint tapLocation = [tapRecognizer locationInView:ppTableView];
  NSIndexPath *tappedIndexPath = [ppTableView indexPathForRowAtPoint:tapLocation];
  CustomizationMenu *menu = (CustomizationMenu*)[[ResponseUtility getSharedInstance].CustomizeMenuArray objectAtIndex:tappedIndexPath.row];
  if ([selectedCustomCuisineStringArray containsObject:menu.cust_option]) {
    [selectedCustomCuisineStringArray removeObject:menu.cust_option];
    [selectedCustomCuisinePriceArray removeObject:[NSNumber numberWithFloat:menu.cust_price]];
    [selectedCustomCuisineIdArray removeObject:menu.cust_id];
    totalprice = totalprice-menu.cust_price;
    
    lbl4.text= [NSString stringWithFormat:@"$ %.02f",totalprice ];
  }
  else {
    [selectedCustomCuisineStringArray addObject:menu.cust_option];
    [selectedCustomCuisinePriceArray addObject:[NSNumber numberWithFloat:menu.cust_price]];
    [selectedCustomCuisineIdArray addObject:menu.cust_id];
    totalprice = totalprice+menu.cust_price;
    lbl4.text= [NSString stringWithFormat:@"$ %.02f",totalprice];
  }
  [ppTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tappedIndexPath] withRowAnimation: UITableViewRowAnimationFade];
  NSLog(@"%@",selectedCustomCuisineStringArray);
}


-(void)adPopUpMenu{
  
   dispatch_async(dispatch_get_main_queue(), ^{
  
  [selectedCustomCuisineStringArray removeAllObjects];
  [selectedCustomCuisinePriceArray removeAllObjects];
  [selectedCustomCuisineIdArray removeAllObjects];
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screenRect.size.height;
  CGFloat screenWidth = screenRect.size.width;
  coverView = [[UIScrollView alloc] initWithFrame:screenRect];
  coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
  [self.view addSubview:coverView];
  popVw.layer.cornerRadius = 10.0;
  popVw=[[UIView alloc]initWithFrame:CGRectMake(20, 100, screenWidth-40, screenHeight/2+100)];
  [popVw setBackgroundColor:[UIColor whiteColor]];
  
  //  mainView =[[UIView alloc]initWithFrame:CGRectMake(20, 100, screenWidth-40, screenHeight/2+100)];
  //  [mainView setBackgroundColor:[UIColor whiteColor]];
  
  
  
  CustomizationMenu *cmenu;
  if ([ResponseUtility getSharedInstance].CustomizeMenuArray.count>0) {
    cmenu = [[ResponseUtility getSharedInstance].CustomizeMenuArray objectAtIndex:0];
  }
  
  float ppWidth = popVw.frame.size.width;
  UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ppWidth-20, 40)];
  lbl1.textColor = [UIColor redColor];
  lbl1.backgroundColor=[UIColor colorWithRed:(219/255.f) green:(219/255.f) blue:(219/255.f) alpha:1.0f];
  lbl1.textColor=[UIColor redColor];
  lbl1.userInteractionEnabled=NO;
  lbl1.textAlignment = NSTextAlignmentCenter;
  lbl1.text= @"Would you like to choose?";
  lbl1.textColor=[UIColor colorWithRed:188.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0];
  lbl1.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
  [popVw addSubview:lbl1];
  
  UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, ppWidth-20, 25)];
  lbl2.textColor = [UIColor blackColor];
  lbl2.backgroundColor=[UIColor clearColor];
  lbl2.textColor=[UIColor blackColor];
  lbl2.userInteractionEnabled=NO;
  lbl2.text= cmenu.sub_category;
  if (cmenu.sub_category.length==0) {
    lbl2.text = subCatName;
  }
  lbl2.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
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
  UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(10, extendedHeight, lblwidth, 35)];
  lbl3.textColor = [UIColor redColor];
  lbl3.backgroundColor=[UIColor colorWithRed:(161/255.f) green:(158/255.f) blue:(158/255.f) alpha:1.0f];
  lbl3.textColor=[UIColor blackColor];
  lbl3.userInteractionEnabled=NO;
  lbl3.text= @"Total Price";
  lbl3.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
  [popVw addSubview:lbl3];
  
  lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(lbl3.frame.size.width, extendedHeight, lblwidth+10, 35)];
  lbl4.textColor = [UIColor redColor];
  lbl4.backgroundColor=[UIColor colorWithRed:(161/255.f) green:(158/255.f) blue:(158/255.f) alpha:1.0f];
  lbl4.textColor=[UIColor blackColor];
  lbl4.userInteractionEnabled=NO;
  lbl4.textAlignment = NSTextAlignmentRight;
  //  NSString]
  lbl4.text= [NSString stringWithFormat:@"$ %.02f",cmenu.price];
  if (tempArray.count ==0) {
    //  didSelectSubRowPrice
    lbl4.text= [NSString stringWithFormat:@"$ %.02f",didSelectSubRowPrice];
  }
  
  lbl4.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
  [popVw addSubview:lbl4];
  
  extendedHeight = extendedHeight+40;
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
  
  
  //    UIScrollView  *MyScrollVw= [[UIScrollView alloc]initWithFrame:CGRectMake(0 ,0 ,320 ,480)];
  //    coverView.delegate= self;
  [coverView setShowsHorizontalScrollIndicator:NO];
  [coverView setShowsVerticalScrollIndicator:YES];
  coverView.scrollEnabled= YES;
  coverView.userInteractionEnabled= YES;
  //    [yourView addSubview:MyScrollVw];
  coverView.contentSize= CGSizeMake(320 ,extendedHeight+300);
  
  [coverView addSubview:popVw];
   });
}

-(void)cancelOrderBtnClick{
  [coverView removeFromSuperview];
  [popVw removeFromSuperview];
}
-(void)confirmOrderBtnClick{
  [coverView removeFromSuperview];
  [popVw removeFromSuperview];
  [self addValuesToCart];
  //  CartButton.hidden = NO;
}

-(void)showCartView{
  [self getSalesTaxValue ];
  //  http://ymoc.mobisofttech.co.in/android_api/tax.php
  
}


-(void)getSalesTaxValue{
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSString *url = @"http://ymoc.mobisofttech.co.in/android_api/tax.php";
  [utility doPostRequestfor:url withParameters:nil onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      dispatch_async(dispatch_get_main_queue(), ^{
        [self parseUserResponse:responseDictionary];
      });
    }else{
      dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate hideLoadingView];
      });
    }
  }];
  
}

-(void)parseUserResponse:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if ([[ResponseDictionary valueForKey:@"code"]isEqualToString:@"1"]) {
        NSLog(@"login successfull");
        [appDelegate hideLoadingView];
        //        {"code":"1","data":[{"tax":"15"}],"msg":"Data has been found"}
        [ResponseUtility getSharedInstance].salesTaxValue = [[[ResponseDictionary valueForKey:@"data"] objectAtIndex:0]valueForKey:@"tax"];
        CartViewController *obj_clvc  = (CartViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"CartViewControllerId"];
        obj_clvc.selectedRestName = selectedUfrespo.name;
        obj_clvc.selectedUfrespo = selectedUfrespo;
        [self.navigationController pushViewController:obj_clvc animated:YES];
      }else{
        [appDelegate hideLoadingView];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Failed to process your request" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
      }
    });
    
  }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
  
  if([text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    return NO;
  }
  
  return YES;
}


- (IBAction)menuBtnClick:(id)sender {
  
  DisplayRatingsViewController *obj_clvc  = (DisplayRatingsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DisplayRatingsViewControllerId"];
  obj_clvc.restID = self.selectedUfrespo.ufp_id;
  obj_clvc.restName = selectedUfrespo.name;
  [self.navigationController pushViewController:obj_clvc animated:YES];
}

- (IBAction)additionalInfoBtnClick:(id)sender {
  
  AdditionalInfoViewController *obj_clvc  = (AdditionalInfoViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AdditionalInfoViewControllerId"];
  obj_clvc.restID = self.selectedUfrespo.ufp_id;
  [self.navigationController pushViewController:obj_clvc animated:YES];
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
      dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"response:%@",responseDictionary);
         [appDelegate hideLoadingView];
        [self parseSearchDetailsInfoResponse:responseDictionary];
      });
    }else{
      dispatch_async(dispatch_get_main_queue(), ^{
        isCustomizable = NO;
        [appDelegate hideLoadingView];
      });
    }
  }];
}


-(void)parseSearchDetailsInfoResponse:(NSDictionary*)ResponseDictionary{
  
  if (ResponseDictionary) {
    totalprice = 0;
    [ResponseUtility getSharedInstance].CustomizeMenuArray = [[NSMutableArray alloc]init];
    if ([[ResponseDictionary valueForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
      isCustomizable = YES;
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
      totalprice = cMenu.price;
      menuPrice = cMenu.price;
      [[ResponseUtility getSharedInstance].CustomizeMenuArray addObject:cMenu];
    }
    else if ([[ResponseDictionary valueForKey:@"data"] isKindOfClass:[NSArray class]]){
      isCustomizable = YES;
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
        totalprice = cMenu.price;
        menuPrice = cMenu.price;
        [[ResponseUtility getSharedInstance].CustomizeMenuArray addObject:cMenu];
      }
    }else{
      isCustomizable = NO;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      [appDelegate hideLoadingView];
      [self adPopUpMenu];
    });
  }
}

-(void)addValuesToCart{
  
  DBManager *manager = [DBManager getSharedInstance];
  CustomizationMenu *cmenu;
  if ([ResponseUtility getSharedInstance].CustomizeMenuArray.count>0) {
    cmenu = [[ResponseUtility getSharedInstance].CustomizeMenuArray objectAtIndex:0];
  }
  else{
    
  }
  Utility *utilityObj = [[Utility alloc]init];
  USerSelectedCartData *cart = [[USerSelectedCartData alloc]init];
  if (isCustomizable) {
    cart.restaurant_Id = [cmenu.restaurant_id integerValue];
    cart.subCategory_Id = [cmenu.c_id integerValue];
    cart.reasturant_Name = selectedUfrespo.name;
    cart.category_Name = cmenu.category;
    cart.sub_category_Name = cmenu.sub_category;
    cart.cust_id = cmenu.cust_id;
    cart.cust_option = cmenu.cust_option;
    cart.cust_price = [NSString stringWithFormat:@"%f",cmenu.cust_price];
    cart.cust_description = cmenu.cust_description;
    cart.subCategoryPrice = cmenu.price;
    cart.MIN_ORDER = [selectedUfrespo.min_order_amount floatValue];
    cart.delivery_fee = [selectedUfrespo.fee floatValue];
    cart.customizeCuisineString = [selectedCustomCuisineStringArray componentsJoinedByString:@"&"];
    cart.customizeCuisinePrice = [selectedCustomCuisinePriceArray componentsJoinedByString:@"&"];
    cart.customizedCuisineId = [selectedCustomCuisineIdArray componentsJoinedByString:@"&"];
    cart.quantity = @"1";
    cart.TotalFinalPrice = totalprice;
    cart.status = cmenu.status;
    cart.ordertype = [RequestUtility sharedRequestUtility].selectedOrderType;
    cart.instructions = myTextView.text;
    cart.userEnteredAddress = @"";
    cart.rest_Address = selectedUfrespo.address_search;
    //    Utility *utilityObj = [[Utility alloc]init];
    NSString *randStr = [utilityObj getRandomPINString];
    cart.serverCartID = @"0";
    cart.randomCartID = randStr;
    cart.Logo = selectedUfrespo.logo;
  }else{
    cart.restaurant_Id = [selectedUfrespo.ufp_id integerValue];
    cart.reasturant_Name = selectedUfrespo.name;
    
    cart.subCategory_Id = [subID integerValue];
    cart.category_Name = catName;
    cart.sub_category_Name = subCatName;
    cart.cust_id = cmenu.cust_id;
    cart.cust_option = cmenu.cust_option;
    cart.cust_price = [NSString stringWithFormat:@"%f",cmenu.cust_price];
    cart.cust_description = cmenu.cust_description;
    cart.subCategoryPrice = [newprice floatValue];
    
    cart.MIN_ORDER = [selectedUfrespo.min_order_amount floatValue];
    cart.delivery_fee = [selectedUfrespo.fee floatValue];
    cart.customizeCuisineString = [selectedCustomCuisineStringArray componentsJoinedByString:@"&"];
    cart.customizeCuisinePrice = [selectedCustomCuisinePriceArray componentsJoinedByString:@"&"];
    cart.customizedCuisineId = [selectedCustomCuisineIdArray componentsJoinedByString:@"&"];
    cart.quantity = @"1";
    cart.TotalFinalPrice = [newprice floatValue];
    cart.status = cmenu.status;
    //     cart.ordertype = @"PICKUP";
    cart.instructions = myTextView.text;
    cart.ordertype = [RequestUtility sharedRequestUtility].selectedOrderType;
    cart.userEnteredAddress = @"";
    cart.rest_Address = selectedUfrespo.address_search;
    //    Utility *utilityObj = [[Utility alloc]init];
    NSString *randStr = [utilityObj getRandomPINString];
    cart.serverCartID = @"0";
    cart.randomCartID = randStr;
    cart.Logo = selectedUfrespo.logo;
  }
  BOOL isSaved = [manager saveDataIntoCart:cart];
  if (isSaved) {
    CartButton.hidden = NO;
    NSArray *arr = [[DBManager getSharedInstance] getALlCartData:(int)cart.restaurant_Id];
    [self addingValueToCartRequest:cart.restaurant_Id];
    [CartButton setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)arr.count] forState:UIControlStateNormal];
  }
  
  
  NSLog(@"tes");
  
}

-(void)addingValueToCartRequest:(NSInteger)restID{
  Utility *utilityObj = [[Utility alloc]init];
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  NSString *userId=[userdictionary valueForKey:@"user_id"];
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
    for (int i =0; i<arr.count; i++) {
      
      
      USerSelectedCartData *cartData = (USerSelectedCartData*)[arr objectAtIndex:i];
      currentUID = cartData.unique_id;
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
    [self addValuesToCart:addToCartString andUID:currentUID];
  }
}

-(void)addValuesToCart:(NSString*)string andUID:(NSInteger)uid{
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSString *url = @"http://ymoc.mobisofttech.co.in/android_api/add_cart.php";
  [utility doYMOCStringPostRequest:url withParameters:string onComplete:^(bool status, NSDictionary *responseDictionary){
    
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      [self parseAddToCartUserResponse:responseDictionary andUID:uid];
    }else{
      [appDelegate hideLoadingView];
    }
  }];
}


-(void)parseAddToCartUserResponse:(NSDictionary*)ResponseDictionary andUID:(NSInteger)uid{
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
        
      }else{
        [appDelegate hideLoadingView];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[ResponseDictionary valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
      }
    });
    
  }
}

@end
