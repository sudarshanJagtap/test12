//
//  InvestmentViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sunny Gupta on 28/10/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "InvestmentViewController.h"
#import <QuartzCore/QuartzCore.h>
#define kOFFSET_FOR_KEYBOARD 100.0
@interface InvestmentViewController ()<UITextViewDelegate>

@end

@implementation InvestmentViewController
@synthesize scrollView;
- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWasShown:)
                                               name:UIKeyboardDidShowNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification object:nil];
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

  self.CheckboxFirst.selected = YES;
  [self.CheckboxFirst addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
  self.investTf.userInteractionEnabled=NO;

  self.checkBoxSecond.selected = NO;
  [self.checkBoxSecond addTarget:self action:@selector(checkBoxSelectedNext:) forControlEvents:UIControlEventTouchUpInside];

  self.asapCheckbox.selected = YES;
  [self.asapCheckbox addTarget:self action:@selector(AsapcheckSelectedNext:) forControlEvents:UIControlEventTouchUpInside];

  UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
  [keyboardDoneButtonView sizeToFit];
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStylePlain target:self
                                                                action:@selector(doneClicked:)];
  [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
  self.contactTf.keyboardType = UIKeyboardTypeNumberPad;
  self.zipcodeTf.keyboardType = UIKeyboardTypeNumberPad;
  self.contactTf.inputAccessoryView = keyboardDoneButtonView;
  self.zipcodeTf.inputAccessoryView = keyboardDoneButtonView;
  
}

- (IBAction)doneClicked:(id)sender
{
  NSLog(@"Done Clicked.");
  [self.view endEditing:YES];
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
  [textField resignFirstResponder];
  
  return YES;
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  return YES;
}


- (IBAction)backButton:(id)sender
{
  
  [self.navigationController popViewControllerAnimated:YES];
  
}

#pragma mark textView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
  if ([textView.text isEqualToString:@"Comments"]) {
    textView.text = @"";
    textView.textColor = [UIColor blackColor]; //optional
  }
  [textView becomeFirstResponder];
  [self animateTextview:textView up:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
  if ([textView.text isEqualToString:@""]) {
    textView.text = @"Comments";
    textView.textColor = [UIColor lightGrayColor]; //optional
  }
  [textView resignFirstResponder];
  [self animateTextview:textView up:NO];
}

- (void) animateTextview: (UITextView*) textview up: (BOOL) up
{
//  int animatedDistance;
//  
//  int moveUpValue = textview.frame.origin.y+ textview.frame.size.height+100;
//  UIInterfaceOrientation orientation =
//  [[UIApplication sharedApplication] statusBarOrientation];
//  if (orientation == UIInterfaceOrientationPortrait ||
//      orientation == UIInterfaceOrientationPortraitUpsideDown)
//  {
//    
//    animatedDistance = 216-(self.view.frame.size.height-moveUpValue-5);
//  }
//  else
//  {
//    animatedDistance = 162-(320-moveUpValue-5);
//  }
//  
//  if(animatedDistance>0)
//  {
//    const int movementDistance = animatedDistance;
//    const float movementDuration = 0.3f;
//    int movement = (up ? -movementDistance : movementDistance);
//    [UIView beginAnimations: nil context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//    [UIView commitAnimations];
//  }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
  
  if([text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    return NO;
  }
  
  return YES;
}

#pragma mark textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self animateTextField:textField up:YES];
  self.scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y);

}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
  [self animateTextField:textField up:NO];
}


- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
//  int animatedDistance;
//  
//  int moveUpValue = textField.frame.origin.y+ textField.frame.size.height+100;
//  UIInterfaceOrientation orientation =
//  [[UIApplication sharedApplication] statusBarOrientation];
//  if (orientation == UIInterfaceOrientationPortrait ||
//      orientation == UIInterfaceOrientationPortraitUpsideDown)
//  {
//    
//    animatedDistance = 216-(520-moveUpValue-5);
//  }
//  else
//  {
//    animatedDistance = 162-(320-moveUpValue-5);
//  }
//  
//  if(animatedDistance>0)
//  {
//    const int movementDistance = animatedDistance;
//    const float movementDuration = 0.3f;
//    int movement = (up ? -movementDistance : movementDistance);
//    [UIView beginAnimations: nil context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//    [UIView commitAnimations];
//  }
}

- (void)keyboardWasShown:(NSNotification*)notification
{
//  NSDictionary *info = [notification userInfo];
//  CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//  keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
//  
//  UIEdgeInsets contentInset = self.scrollView.contentInset;
//  contentInset.bottom = keyboardRect.size.height-100;
//  self.scrollView.contentInset = contentInset;
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
//  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//  self.scrollView.contentInset = contentInsets;
}

@end
