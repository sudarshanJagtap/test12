//
//  InvestmentViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sunny Gupta on 28/10/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "InvestmentViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface InvestmentViewController ()<UITextViewDelegate>

@end

@implementation InvestmentViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.textViewDescription.layer.borderWidth=5;
  self.textViewDescription.layer.borderColor=[UIColor blackColor].CGColor;
  
  self.commentTextView.delegate = self;
  self.commentTextView.text = @"Comments";
  self.commentTextView.textColor = [UIColor lightGrayColor];
  
  [[self.commentTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
  [[self.commentTextView layer] setBorderWidth:1.3];
  
  
  self.Enquiryview.layer.borderWidth = 5.0f;
  self.Enquiryview.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
  
  UIColor *color = [UIColor grayColor];
  self.Enquiryview.layer.shadowColor = [color CGColor];
  self.Enquiryview.layer.shadowRadius = 10.0f;
  self.Enquiryview.layer.shadowOpacity = 1;
  self.Enquiryview.layer.shadowOffset = CGSizeZero;
  self.Enquiryview.layer.masksToBounds = NO;
  
  //    self.CheckboxFirst = [[UIButton alloc] initWithFrame:CGRectMake(5,5 ,10,10)];
  //    [self.CheckboxFirst setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
  //    [self.CheckboxFirst setBackgroundImage:[UIImage imageNamed:@"checkBx"] forState:UIControlStateSelected];
  self.CheckboxFirst.selected = YES;
  [self.CheckboxFirst addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
  //    [self.investTf addSubview:self.CheckboxFirst];
  self.investTf.userInteractionEnabled=NO;
  
  
  
  //    [self.checkBoxSecond setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
  //    [self.checkBoxSecond setBackgroundImage:[UIImage imageNamed:@"checkBx"] forState:UIControlStateNormal];
  self.checkBoxSecond.selected = NO;
  [self.checkBoxSecond addTarget:self action:@selector(checkBoxSelectedNext:) forControlEvents:UIControlEventTouchUpInside];
  //    [self.investTf addSubview:self.checkBoxSecond];
  
  
  
  
  
  //    self.asapCheckbox=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 15, 15)];
  //    [self.asapCheckbox setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
  //    [self.asapCheckbox setBackgroundImage:[UIImage imageNamed:@"checkBx"] forState:UIControlStateNormal];
  self.asapCheckbox.selected = YES;
  [self.asapCheckbox addTarget:self action:@selector(AsapcheckSelectedNext:) forControlEvents:UIControlEventTouchUpInside];
  // [self. addSubview:self.asapCheckbox];
  
  
}




-(void)AsapcheckSelectedNext:(id)sender{
  
  
  if([self.asapCheckbox isSelected]==YES)
  {
    [self.asapCheckbox setSelected:NO];
    [self.asapCheckbox setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
  }
  else{
    [self.asapCheckbox setSelected:YES];
    [self.asapCheckbox setBackgroundImage:[UIImage imageNamed:@"checkBx"] forState:UIControlStateNormal];
  }
  
}



-(void)checkboxSelected:(id)sender{
  
  
  if([self.CheckboxFirst isSelected]==YES)
  {
    [self.CheckboxFirst setSelected:NO];
    [self.CheckboxFirst setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
    [self.checkBoxSecond setBackgroundImage:[UIImage imageNamed:@"checkBx"] forState:UIControlStateNormal];
  }
  else{
    [self.CheckboxFirst setSelected:YES];
    [self.CheckboxFirst setBackgroundImage:[UIImage imageNamed:@"checkBx"] forState:UIControlStateNormal];
    [self.checkBoxSecond setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
  }
  
}


-(void)checkBoxSelectedNext:(id)sender{
  
  
  if([self.checkBoxSecond isSelected]==YES)
  {
    [self.checkBoxSecond setSelected:NO];
    [self.checkBoxSecond setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
    [self.CheckboxFirst setBackgroundImage:[UIImage imageNamed:@"checkBx"] forState:UIControlStateNormal];
  }
  else{
    [self.checkBoxSecond setSelected:YES];
    [self.checkBoxSecond setBackgroundImage:[UIImage imageNamed:@"checkBx"] forState:UIControlStateNormal];
    [self.CheckboxFirst setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
  }
  
}




- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  //    [self.nameTf becomeFirstResponder];
  //     [self.emailIdTf becomeFirstResponder];
  //    [self.contactTf resignFirstResponder];
  //    [self.streetNameTf resignFirstResponder];
  //    [self.houseNoTf resignFirstResponder];
  //    [self.zipcodeTf resignFirstResponder];
  //    [self.cityTf resignFirstResponder];
  //    [self.textViewDescription resignFirstResponder];
  
  [textField resignFirstResponder];
  
  return YES;
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  return YES;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)backButton:(id)sender
{
  
  [self.navigationController popViewControllerAnimated:YES];
  
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
  if ([textView.text isEqualToString:@"Comments"]) {
    textView.text = @"";
    textView.textColor = [UIColor blackColor]; //optional
  }
  [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
  if ([textView.text isEqualToString:@""]) {
    textView.text = @"Comments";
    textView.textColor = [UIColor lightGrayColor]; //optional
  }
  [textView resignFirstResponder];
}

@end
