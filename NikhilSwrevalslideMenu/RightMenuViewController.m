//
//  RightMenuViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sunny Gupta on 16/07/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "RightMenuViewController.h"
#import "AppDelegate.h"
#import "CuisineOperation.h"
#import "FilterOperations.h"
#import "RequestUtility.h"
#import "DBManager.h"
@interface RightMenuViewController ()<RateViewDelegate>{
  
  FilterOperations *fOperation;
  NSArray *featureArray;
  NSMutableArray *selectedRowsArray;
  RequestUtility *reqUtility;
  UIDatePicker *datePicker;
  UIBarButtonItem *rightBtn;
  UIView *pkVw;
  int counter ;
  NSDate *selectedDate;
  UIImageView *imgAccessoryvw;
}

@end

@implementation RightMenuViewController{
  NSMutableArray *arrayName;
  NSMutableArray *arrayCuisine;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.resetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  NSString *userId=[userdictionary valueForKey:@"user_id"];
  NSString *userFullName=[userdictionary valueForKey:@"user_name"];
  if (userId.length>0) {
    self.asapDisplayLbl.hidden = NO;
    self.asapChkBx.hidden = NO;
    self.asapLbl.hidden = NO;
  }else{
    self.asapDisplayLbl.hidden = YES;
    self.asapChkBx.hidden = YES;
    self.asapLbl.hidden = YES;
  }
  counter = 0;
  NSDate *now = [NSDate date];
  selectedDate =now;
  self.asapDisplayLbl.text=@"";
  self.pickerMainView.hidden = YES;
  reqUtility = [RequestUtility sharedRequestUtility];
  if (reqUtility.isAsap) {
    [self.asapChkBx setBackgroundImage:[UIImage imageNamed: @"checkBx.png"] forState:UIControlStateNormal];
    NSString *str=[NSString stringWithFormat:@"%@ %@",reqUtility.asapSchedule_date,reqUtility.asapSchedule_time];
    //assign text to label
    self.asapDisplayLbl.text=reqUtility.asapFormatedDisplayDate;
    
  }
  selectedRowsArray = [[NSMutableArray alloc]init];
  fOperation = [FilterOperations getSharedInstance];
  [self configureRatingsandPricing];
  self.moreFiltersView.hidden = YES;
  self.title =@"Filters";
  fOperation.selectedCusinesArray = [[NSMutableArray alloc]init];
  fOperation.selectedFeaturesArray = [[NSMutableArray alloc]init];
  featureArray = [[NSArray alloc]initWithObjects:@"Open Now",@"Free Delivery",@"Customized Menu",nil];
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  arrayName = [[NSMutableArray alloc]init];
  arrayCuisine = [[NSMutableArray alloc]init];
  CuisineOperation *operation = [[CuisineOperation alloc] init];
  operation.blnShowAlertMsg = YES;
  operation.AddressCityState = @"";
  [operation  callAPIWithParamter:nil success:^(BOOL success, id response) {
    NSDictionary *dictionary = [[NSDictionary alloc]init];
    
    arrayName = [response valueForKey:@"data"];
    
    for (int i = 0 ; i < [arrayName count]; i++)
    {
      dictionary = [arrayName objectAtIndex:i];
      
      [arrayCuisine addObject:[dictionary valueForKey:@"cuisine"]];
    }
    [appDelegate hideLoadingView];
    [self.tblViewIteam reloadData];
    
  } failure:^(BOOL failed, NSString *errorMessage) {
    [appDelegate hideLoadingView];
  }];
  
}

- (IBAction)backNavBtnClk:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = YES;
}


-(void)viewDidAppear:(BOOL)animated{
//  [reqUtility.selectedCusinesArray removeAllObjects];
  
//  [reqUtility.selectedFeaturesArray removeAllObjects];
//  reqUtility.min_order_amount = @"no";
  [selectedRowsArray addObjectsFromArray:reqUtility.selectedCusinesArray];
  [self.tblViewIteam reloadData];
  [self updateDollarView];
  [self updateCheckBox];
  self.ratingsView.rating =reqUtility.ratings;
  reqUtility.delivery_status = 0;
  reqUtility.sorting = @"no";
  if ([reqUtility.selectedFeaturesArray containsObject:[[RequestUtility sharedRequestUtility] getFeaturNamefromSelectedTag:0]]) {
  [self.btn1  setBackgroundImage:[UIImage imageNamed: @"checkBx.png"] forState:UIControlStateNormal];
  }else{
   [self.btn1  setBackgroundImage:[UIImage imageNamed: @"uncheckBx.png"] forState:UIControlStateNormal];
  }

//  [reqUtility.selectedFeaturesArray addObject:@"open_now_status"];
  self.navigationController.navigationBarHidden = YES;
}

-(void)updateCheckBox{
  if([reqUtility.selectedFeaturesArray containsObject:@"open_now_status"]){
  [self.btn1  setBackgroundImage:[UIImage imageNamed: @"checkBx.png"] forState:UIControlStateNormal];
  }
    if([reqUtility.selectedFeaturesArray containsObject:@"free_delivery"]){
    [self.btn2  setBackgroundImage:[UIImage imageNamed: @"checkBx.png"] forState:UIControlStateNormal];
    }
    if([reqUtility.selectedFeaturesArray containsObject:@"customize_food"]){
      [self.btn3  setBackgroundImage:[UIImage imageNamed: @"checkBx.png"] forState:UIControlStateNormal];
    }
}

-(void)updateDollarView{
  if ( [reqUtility.min_order_amount  isEqual: @"10"]) {
     self.dollarView.rating =1;
  }
  if ( [reqUtility.min_order_amount  isEqual: @"100"]) {
    self.dollarView.rating =2;
  }
  if ( [reqUtility.min_order_amount  isEqual: @"1000"]) {
    self.dollarView.rating =3;
  }
  if ( [reqUtility.min_order_amount  isEqual: @"10000"]) {
    self.dollarView.rating =4;
  }
  if ( [reqUtility.min_order_amount  isEqual: @"100000"]) {
    self.dollarView.rating =5;
  }
  if ( [reqUtility.min_order_amount  isEqual: @"no"]) {
    self.dollarView.rating =0;
  }
}


-(void)configureRatingsandPricing{
  self.ratingsView.notSelectedImage = [UIImage imageNamed:@"blankStar.png"];
  self.ratingsView.fullSelectedImage = [UIImage imageNamed:@"Star.jpeg"];
  self.ratingsView.rating = 0;
  self.ratingsView.editable = YES;
  self.ratingsView.maxRating = 5;
  self.ratingsView.delegate = self;
  
  self.dollarView.notSelectedImage = [UIImage imageNamed:@"oDollar.png"];
  self.dollarView.fullSelectedImage = [UIImage imageNamed:@"Dollar.png"];
  self.dollarView.rating = 0;
  self.dollarView.editable = YES;
  self.dollarView.maxRating = 5;
  self.dollarView.delegate = self;
  
}
- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
  if (rateView == self.ratingsView) {
    fOperation.ratings = (int)rating;
    reqUtility.ratings = (int)rating;
    NSLog(@"Ratings = %d",reqUtility.ratings);
  }else{
    int price = (int)rating;
    if (price ==1) {
      fOperation.pricing = 10;
      reqUtility.min_order_amount = @"10";
    }
    if (price ==2) {
      fOperation.pricing = 100;
            reqUtility.min_order_amount = @"100";
    }
    if (price ==3) {
      fOperation.pricing = 1000;
            reqUtility.min_order_amount = @"1000";
    }
    if (price ==4) {
      fOperation.pricing = 10000;
            reqUtility.min_order_amount = @"10000";
    }
    if (price ==5) {
      fOperation.pricing = 100000;
            reqUtility.min_order_amount = @"100000";
    }
    if (price ==0) {
      fOperation.pricing = 0;
      reqUtility.min_order_amount = @"0";
    }
    NSLog(@"pricing = %@",reqUtility.min_order_amount);
  }
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return [arrayCuisine count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *simpleTableIdentifier = @"casianCellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
  }
  cell.textLabel.text = [arrayCuisine objectAtIndex:indexPath.row];
  cell.textLabel.textColor = [UIColor colorWithRed:(180/255.f) green:(0/255.f) blue:(47/255.f) alpha:1.0f];
  cell.backgroundColor = [UIColor clearColor];
  
  
  if ([selectedRowsArray containsObject:[arrayCuisine objectAtIndex:indexPath.row]]) {
    cell.imageView.image = [UIImage imageNamed:@"checkBx1.png"];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
//    imgAccessoryvw=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 17)];
//    imgAccessoryvw.image=[UIImage imageNamed:@"star12.png"];
//    cell.accessoryView=imgAccessoryvw;
  }
  else {
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.imageView.image = [UIImage imageNamed:@"uncheckBx1.png"];
//    imgAccessoryvw=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 17)];
//    imgAccessoryvw.image=[UIImage imageNamed:@"star23.png"];
//    cell.accessoryView=imgAccessoryvw;
  }
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleChecking:)];
  [cell addGestureRecognizer:tap];
  cell.userInteractionEnabled = YES;
  float screenWidth = [[UIScreen mainScreen] bounds].size.width;
  
  UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
  separatorLineView.backgroundColor = [UIColor colorWithRed:(196/255.f) green:(196/255.f) blue:(196/255.f) alpha:1.0f];
  [cell.contentView addSubview:separatorLineView];
  UIFont *myFont = [ UIFont fontWithName: @"System Bold" size: 40.0 ];
  cell.textLabel.font  = myFont;
  [cell setIndentationLevel:2];
  return cell;
}

- (void) handleChecking:(UITapGestureRecognizer *)tapRecognizer {
  CGPoint tapLocation = [tapRecognizer locationInView:self.tblViewIteam];
  NSIndexPath *tappedIndexPath = [self.tblViewIteam indexPathForRowAtPoint:tapLocation];
  
  if ([selectedRowsArray containsObject:[arrayCuisine objectAtIndex:tappedIndexPath.row]]) {
    [selectedRowsArray removeObject:[arrayCuisine objectAtIndex:tappedIndexPath.row]];
    [reqUtility.selectedCusinesArray removeObject:[arrayCuisine objectAtIndex:tappedIndexPath.row]];
  }
  else {
    [reqUtility.selectedCusinesArray addObject:[arrayCuisine objectAtIndex:tappedIndexPath.row]];
    [selectedRowsArray addObject:[arrayCuisine objectAtIndex:tappedIndexPath.row]];
  }
  [self.tblViewIteam reloadRowsAtIndexPaths:[NSArray arrayWithObject:tappedIndexPath] withRowAnimation: UITableViewRowAnimationFade];
  NSLog(@"%@",reqUtility.selectedCusinesArray);
}

- (IBAction)applyButtonClicked:(id)sender {

  [self.rmdelegate delegateDelivery];
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resetAllCuisine:(id)sender {
  [selectedRowsArray removeAllObjects];
  [reqUtility.selectedCusinesArray removeAllObjects];
  [reqUtility.selectedFeaturesArray removeAllObjects];
  reqUtility.min_order_amount = @"no";
  reqUtility.ratings = 0;
  reqUtility.delivery_status = 0;
  reqUtility.sorting = @"no";
  [reqUtility.selectedFeaturesArray addObject:@"open_now_status"];
  
 [self updateDollarView];
  [self updateCheckBox];
  self.ratingsView.rating =reqUtility.ratings;

  [self.tblViewIteam reloadData];
}

- (IBAction)moreFiltersCheckBoxClicked:(id)sender {
  
  UIButton *tappedButton = (UIButton*)sender;
  int selectedTag = (int)tappedButton.tag;
  if([tappedButton.currentBackgroundImage isEqual:[UIImage imageNamed:@"uncheckBx.png"]])
  {
    [sender  setBackgroundImage:[UIImage imageNamed: @"checkBx.png"] forState:UIControlStateNormal];
    if (selectedTag != 3) {
      [reqUtility.selectedFeaturesArray addObject:[[RequestUtility sharedRequestUtility] getFeaturNamefromSelectedTag:selectedTag]];
    }else{
      [self datePickerBtnAction:self];
            reqUtility.isAsap = YES;
    }
  }
  else
  {
    [sender  setBackgroundImage:[UIImage imageNamed: @"uncheckBx.png"] forState:UIControlStateNormal];
    if (selectedTag != 3) {
      [reqUtility.selectedFeaturesArray removeObject:[[RequestUtility sharedRequestUtility] getFeaturNamefromSelectedTag:selectedTag]];
    }else{
      self.asapDisplayLbl.text=@"";
      self.pickerMainView.hidden = YES;
      reqUtility.isAsap = NO;
      reqUtility.asapSchedule_date = @"00:00:00";
      reqUtility.asapSchedule_time = @"00:00";
    }
  }
  NSLog(@"Selected features array = %@",fOperation.selectedFeaturesArray);
}

- (IBAction)segmentClicked:(id)sender {
  UISegmentedControl *s = (UISegmentedControl *)sender;
  
  if (s.selectedSegmentIndex == 1)
  {
    [self.resetBtn setTitle:@"Reset All" forState:UIControlStateNormal];
    
    self.moreFiltersView.hidden = NO;
  }else{
    [self.resetBtn setTitle:@"Reset All Cuisines" forState:UIControlStateNormal];
    self.moreFiltersView.hidden = YES;
  }
}

-(IBAction)datePickerBtnAction:(id)sender
{
  self.pickerMainView.hidden = NO;
  self.dateDisplayLbl.text = @"Today";
  NSDate *mydate = [NSDate date];
  NSTimeInterval secondsInEightHours = 4 * 60 * 60;
  NSDate *dateFourHoursAhead = [mydate dateByAddingTimeInterval:secondsInEightHours];
  [self.DatetimePicker setDate:dateFourHoursAhead];
  [self.DatetimePicker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
}

-(void)LabelTitle:(id)sender
{
  NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
  dateFormat.dateStyle=NSDateFormatterMediumStyle;
  [dateFormat setDateFormat:@"MM/dd/yy"];
  NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
  //assign text to label
  self.asapDisplayLbl.text=str;
}

- (IBAction)prevBtnClick:(id)sender {
  if (counter>0) {
    counter--;
  }
  if (counter ==0) {
    self.dateDisplayLbl.text = @"Today";
     [self getWeekday:counter];
  }if (counter ==1) {
    self.dateDisplayLbl.text = @"Tommorow";
     [self getWeekday:counter];
  }if (counter ==2) {
    self.dateDisplayLbl.text = [self getWeekday:counter];
  }
  if (counter ==3) {
    self.dateDisplayLbl.text = [self getWeekday:counter];
  }
  
 
  
}

- (IBAction)nextBtnClick:(id)sender {
 
  if (counter>3) {
    
  }else{
    counter++;
  }
  if (counter ==0) {
    self.dateDisplayLbl.text = @"Today";
//     NSString *test =
    [self getWeekday:counter];
  }if (counter ==1) {
    self.dateDisplayLbl.text = @"Tommorow";
//    NSString *test =
    [self getWeekday:counter];
  }if (counter ==2) {
    self.dateDisplayLbl.text = [self getWeekday:counter];
  }
  if (counter ==3) {
    self.dateDisplayLbl.text = [self getWeekday:counter];
  }
  
}

-(NSString*)getWeekday:(int)count{
  NSCalendar *calendar = [NSCalendar currentCalendar];
      NSDateComponents *comps = [NSDateComponents new];
      comps.day = count;
      NSDate *sevenDays = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
//      NSDate *now = [NSDate date];
      selectedDate = sevenDays;
      NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
      [weekday setDateFormat: @"EEEE"];
      NSLog(@"The day of the week is: %@", [weekday stringFromDate:sevenDays]);
  return [weekday stringFromDate:sevenDays];
}

- (IBAction)doneBtnClick:(id)sender {
  self.pickerMainView.hidden = YES;
  NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
  dateFormat.dateStyle=NSDateFormatterMediumStyle;
  [dateFormat setDateFormat:@"dd:MM:yy"];
//  NSString *date = [dateFormat stringFromDate:selectedDate];
  NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
  [outputFormatter setDateFormat:@"hh:mm a"]; //24hr time format
  NSString *timeStr = [outputFormatter stringFromDate:self.DatetimePicker.date];
  NSString *str=[NSString stringWithFormat:@"%@ %@",[dateFormat  stringFromDate:selectedDate],timeStr];
  //assign text to label
  self.asapDisplayLbl.text=str;
  reqUtility.asapSchedule_date = [dateFormat  stringFromDate:selectedDate];
  reqUtility.asapSchedule_time = timeStr;
  
  
//  ASAP
  
  
  NSDateFormatter *dateFormatasap=[[NSDateFormatter alloc]init];
  dateFormatasap.dateStyle=NSDateFormatterMediumStyle;
  [dateFormatasap setDateFormat:@"yyyy-MM-dd"];
  //  NSString *date = [dateFormat stringFromDate:selectedDate];
  NSDateFormatter *outputFormatterasap = [[NSDateFormatter alloc] init];
  [outputFormatterasap setDateFormat:@"hh:mm"]; //24hr time format
  NSString *timeStr1 = [outputFormatterasap stringFromDate:self.DatetimePicker.date];
  NSString *str1=[NSString stringWithFormat:@"%@ %@",[dateFormatasap  stringFromDate:selectedDate],timeStr1];
  //assign text to label
  reqUtility.asapSchedule_datePassed = [dateFormatasap  stringFromDate:selectedDate];
  reqUtility.asapSchedule_timePassed = timeStr1;
  
  
//  ASAP ends

  NSString *weekday = [self getWeekDayfromStrResponse:[dateFormat  stringFromDate:selectedDate]];
  NSString *month = [self getMonthToDisplayfromStrResponse:[dateFormat stringFromDate:selectedDate]];
  NSString *cdate = [self getDateToDisplayfromStrResponse:[dateFormat stringFromDate:selectedDate]];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy"];
  NSString *currentYear = [formatter stringFromDate:[NSDate date]];
  if ([self.dateDisplayLbl.text isEqualToString:@"Today"]) {
    weekday = @"Today";
  }else if ([self.dateDisplayLbl.text isEqualToString:@"Tommorow"]) {
    weekday = @"Tommorow";
  }
  NSString *displyStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",weekday,month,cdate,currentYear,timeStr];
   self.asapDisplayLbl.text=displyStr;
  reqUtility.asapFormatedDisplayDate = displyStr;
  reqUtility.asapDisplayLbl = displyStr;
  
  NSString *displyStr1 = [NSString stringWithFormat:@"%@ %@ %@ %@",month,cdate,currentYear,timeStr];
  reqUtility.StoredAsapDisplayStr = displyStr1;
}

-(NSString*)getWeekDayfromStrResponse:(NSString*)str{
  
  NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
  // this is imporant - we set our input date format to match our input string
  // if format doesn't match you'll get nil from your string, so be careful
  [dateFormatter1 setDateFormat:@"dd:MM:yy"];
  NSDate *dateFromString = [[NSDate alloc] init];
  // voila!
  dateFromString = [dateFormatter1 dateFromString:str];
  
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  [df setDateFormat:@"dd:MM:yy"];
  NSCalendar* cal = [NSCalendar currentCalendar];
  NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:dateFromString];
  NSInteger day =  [comp weekday];
  NSString *weekDaystr;
  switch (day) {
      
    case 1:
      weekDaystr = @"SUN";
      break;
    case 2:
      weekDaystr = @"MON";
      break;
    case 3:
      weekDaystr = @"TUE";
      break;
    case 4:
      weekDaystr = @"WED";
      break;
    case 5:
      weekDaystr = @"THU";
      break;
    case 6:
      weekDaystr = @"FRI";
      break;
    case 7:
      weekDaystr = @"SAT";
      break;
    default:
      break;
  }
  return weekDaystr;
}


-(NSString*)getDateToDisplayfromStrResponse:(NSString*)str{
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  [df setDateFormat:@"dd:MM:yy"];
  NSDate *myDate = [df dateFromString: str];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"dd"];
  NSString *strDate = [formatter stringFromDate:myDate];
  return strDate;
}

-(NSString*)getMonthToDisplayfromStrResponse:(NSString*)str{
  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  [df setDateFormat:@"MM"];
  NSDate *myDate = [df dateFromString: str];
  
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  //Get Month
  [formatter setDateFormat:@"MM"];
  NSString *strMonth = [formatter stringFromDate:myDate];
  NSArray *mst = [str componentsSeparatedByString:@":"];
  return [self MonthNameString:[[mst objectAtIndex:1] intValue]];
//  return strMonth;
}

-(NSString*)MonthNameString:(int)monthNumber
{
  NSDateFormatter *formate = [NSDateFormatter new];
  
  NSArray *monthNames = [formate standaloneMonthSymbols];
  
  NSString *monthName = [monthNames objectAtIndex:(monthNumber - 1)];
  
  return monthName;
}

@end
