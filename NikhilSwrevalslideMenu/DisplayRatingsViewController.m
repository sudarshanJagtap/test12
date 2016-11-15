//
//  DisplayRatingsViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 9/27/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "DisplayRatingsViewController.h"
#import "AppDelegate.h"
#import "RequestUtility.h"
#import "DisplayRatingTableViewCell.h"
#import "AppConstant.h"

@interface DisplayRatingsViewController (){
  
  AppDelegate *appDelegate;
  NSString *totalRatingStar;
  NSString *totalRatingCount;
  UILabel *noRestoLabel;
}

@end

@implementation DisplayRatingsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableVw.hidden = YES;
  self.ratingLbl.hidden = YES;
  self.globalRatingView.hidden = YES;
  noRestoLabel = [[UILabel alloc] init];
  [ResponseUtility getSharedInstance].UserRatingsArray = [[NSMutableArray alloc]init];
  [self configureRatingsandPricing];
  self.RestTitleLbl.text = [NSString stringWithFormat:@"Reviews for %@",self.restName];
  NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
  [dict setValue:self.restID forKey:@"restaurant_id"];
  [dict setValue:@"restaurant_review" forKey:@"action"];
  [self getAllReviews:dict];
}

-(void)configureRatingsandPricing{
  self.globalRatingView.notSelectedImage = [UIImage imageNamed:@"star23.png"];
  //  self.globalRatingView.halfSelectedImage = [UIImage imageNamed:@"kermit_half.png"];
  self.globalRatingView.fullSelectedImage = [UIImage imageNamed:@"star12.png"];
  //self.globalRatingView.rating = 2;
  self.globalRatingView.editable = NO;
  self.globalRatingView.maxRating = 5;
}

- (IBAction)backNavBtnClick:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)getAllReviews:(NSDictionary *)params{
  
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
  NSString *String = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSLog(@"getAllReviews string \n = %@",String);
  
  [utility doYMOCStringPostRequest:kRestaurant_review withParameters:String onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"getAllReviews response:%@",responseDictionary);
      [appDelegate hideLoadingView];
      [self parseReviews:responseDictionary];
    }else{
      [appDelegate hideLoadingView];
    }
  }];
}

-(void)parseReviews:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
    NSString *code = [ResponseDictionary valueForKey:@"code"];
    [ResponseUtility getSharedInstance].UserRatingsArray = [[NSMutableArray alloc]init];
    if ([code isEqualToString:@"1"]) {
      
      if ([[[ResponseDictionary valueForKey:@"data"] valueForKey:@"reviews"]isKindOfClass:[NSDictionary class]]) {
        UserReviews *oData = [[UserReviews alloc]init];
        oData.title = [ResponseDictionary valueForKey:@"title"];
        oData.comment = [ResponseDictionary valueForKey:@"comment"];
        oData.rating = [ResponseDictionary valueForKey:@"rating"];
        oData.created = [ResponseDictionary valueForKey:@"created"];
        [[ResponseUtility getSharedInstance].UserRatingsArray addObject:oData];
      }
      else if ([[[ResponseDictionary valueForKey:@"data"]valueForKey:@"reviews"] isKindOfClass:[NSArray class]]){
        NSArray *valuesAr = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"reviews"];
        for (NSArray *respo in valuesAr){
          UserReviews *oData = [[UserReviews alloc]init];
          oData.title = [respo valueForKey:@"title"];
          oData.comment = [respo valueForKey:@"comment"];
          oData.rating = [respo valueForKey:@"rating"];
          oData.created = [respo valueForKey:@"created"];
          [[ResponseUtility getSharedInstance].UserRatingsArray addObject:oData];
        }
      }
      totalRatingCount = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"total_rating_count"];
      totalRatingStar = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"total_rating_star"];
      dispatch_async(dispatch_get_main_queue(), ^{
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate hideLoadingView];
        self.globalRatingView.rating = [totalRatingStar intValue];
        self.ratingLbl.text = [NSString stringWithFormat:@"%@ rating(s)",totalRatingCount];
        [self.tableVw reloadData];
        self.tableVw.hidden = NO;
        self.ratingLbl.hidden = NO;
        self.globalRatingView.hidden = NO;
      });
    }else{
      
      dispatch_async(dispatch_get_main_queue(), ^{
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate hideLoadingView];
        [self.tableVw reloadData];
        self.tableVw.hidden = YES;
        self.ratingLbl.hidden = YES;
        self.globalRatingView.hidden = YES;
        [self showNoReviews];
      });
    }
    
    
  }else{
    dispatch_async(dispatch_get_main_queue(), ^{
      appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      [appDelegate hideLoadingView];
      [self.tableVw reloadData];
      self.tableVw.hidden = YES;
      self.ratingLbl.hidden = YES;
      self.globalRatingView.hidden = YES;
      [self showNoReviews];
    });
  }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [[ResponseUtility getSharedInstance].UserRatingsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"DisplayRatingTableViewCell";
  
  DisplayRatingTableViewCell *cell = (DisplayRatingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if(cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DisplayRatingTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    UserReviews *oData = (UserReviews*)[[ResponseUtility getSharedInstance].UserRatingsArray objectAtIndex:indexPath.row];
    cell.nameLbl.text = [NSString stringWithFormat:@"%@",oData.title];
    cell.commentLbl.text= [NSString stringWithFormat:@"%@",oData.comment ];
    cell.dateLbl.text= [NSString stringWithFormat:@"%@",oData.created];
    NSString *temp = [oData.title substringToIndex:1];
    cell.initialLbl.text= [NSString stringWithFormat:@"%@",temp];
    cell.ratingsVw.rating= [oData.rating intValue];
  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
}

-(void)showNoReviews{
  
  self.tableVw.hidden = YES;
  self.ratingLbl.hidden = YES;
  self.globalRatingView.hidden = YES;
  noRestoLabel.hidden = NO;
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screenRect.size.width;
  CGFloat screenHeight = screenRect.size.height;
  [noRestoLabel setFrame:CGRectMake(screenWidth/2-100, screenHeight/2-20, screenWidth, 40)];
  noRestoLabel.backgroundColor=[UIColor clearColor];
  noRestoLabel.textColor=[UIColor redColor];
  noRestoLabel.userInteractionEnabled=NO;
  noRestoLabel.text= @"No Reviews Available";
  [self.view addSubview:noRestoLabel];
  [self.view bringSubviewToFront:noRestoLabel];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
