//
//  AddReviewsViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 10/5/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "AddReviewsViewController.h"
#import "AppDelegate.h"
#import "RequestUtility.h"
#import "DBManager.h"
 #import <QuartzCore/QuartzCore.h>
#import "AppConstant.h"
@interface AddReviewsViewController ()<UITextViewDelegate>{
  AppDelegate *appDelegate;
}

@end

@implementation AddReviewsViewController
@synthesize uData;
- (void)viewDidLoad {
  [super viewDidLoad];
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  self.titleTxtView.text = [userdictionary valueForKey:@"user_full_name"];
  [self configureRatingsandPricing];
  [[self.titleTxtView layer] setBorderColor:[[UIColor grayColor] CGColor]];
  [[self.titleTxtView layer] setBorderWidth:1.3];
  [[self.titleTxtView layer] setCornerRadius:10];
  [[self.commentTxtVw layer] setBorderColor:[[UIColor grayColor] CGColor]];
  [[self.commentTxtVw layer] setBorderWidth:1.3];
  [[self.commentTxtVw layer] setCornerRadius:10];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)addReviews:(NSDictionary *)params{
  
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];  
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
  NSString *String = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSLog(@"additional info string \n = %@",String);
  
  [utility doYMOCStringPostRequest:kOrder_review withParameters:String onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      dispatch_async(dispatch_get_main_queue(), ^{
      [appDelegate hideLoadingView];
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
    NSString *code = [ResponseDictionary valueForKey:@"code"];
    if ([code isEqualToString:@"1"]) {
      dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Review added successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
      });
      
    }else{
      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Failed to added review. Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      [alert show];
    }
    
  }else{
    dispatch_async(dispatch_get_main_queue(), ^{
      appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      [appDelegate hideLoadingView];
    });
  }
}

-(void)configureRatingsandPricing{
  self.qualityOfFoodRW.notSelectedImage = [UIImage imageNamed:@"red_star_empty.png"];
  self.qualityOfFoodRW.fullSelectedImage = [UIImage imageNamed:@"abc_ic_star_black_36dp.png"];
  self.qualityOfFoodRW.editable = YES;
  self.qualityOfFoodRW.maxRating = 5;
  
  self.cleanlinessRW.notSelectedImage = [UIImage imageNamed:@"red_star_empty.png"];
  self.cleanlinessRW.fullSelectedImage = [UIImage imageNamed:@"abc_ic_star_black_36dp.png"];
  self.cleanlinessRW.editable = YES;
  self.cleanlinessRW.maxRating = 5;
  
  self.tasteRW.notSelectedImage = [UIImage imageNamed:@"unchecked_heart.png"];
  self.tasteRW.fullSelectedImage = [UIImage imageNamed:@"checked_heart.png"];
  self.tasteRW.editable = YES;
  self.tasteRW.maxRating = 10;
}

- (IBAction)backNavBtnClick:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)submitBtnClick:(id)sender{
  
  if ((self.commentTxtVw.text.length>0)&&(self.commentTxtVw.text.length>0)) {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:self.userId forKey:@"user_id"];
    [dict setValue:self.uData.order_id forKey:@"order_id"];
    [dict setValue:self.uData.restaurant_id forKey:@"restaurant_id"];
    [dict setValue:self.titleTxtView.text forKey:@"title"];
    [dict setValue:self.commentTxtVw.text forKey:@"comment"];
    NSString *quality_rating = [NSString stringWithFormat:@"%.f",self.qualityOfFoodRW.rating];
    NSString *clean_rating = [NSString stringWithFormat:@"%.f",self.cleanlinessRW.rating];
    NSString *taste_rating = [NSString stringWithFormat:@"%.f",self.tasteRW.rating];
    [dict setValue:quality_rating forKey:@"quality_rating"];
    [dict setValue:clean_rating forKey:@"clean_rating"];
    [dict setValue:taste_rating forKey:@"taste_rating"];
    [dict setValue:@"order_review" forKey:@"action"];
    [self addReviews:dict];
  }else{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please add review comments" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
  }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
  
  if([text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    return NO;
  }
  
  return YES;
}



- (void)viewWillAppear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
  CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  [UIView animateWithDuration:0.3 animations:^{
    CGRect f = self.view.frame;
    f.origin.y = -keyboardSize.height;
    self.view.frame = f;
  }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
  [UIView animateWithDuration:0.3 animations:^{
    CGRect f = self.view.frame;
    f.origin.y = 0.0f;
    self.view.frame = f;
  }];
}

@end
