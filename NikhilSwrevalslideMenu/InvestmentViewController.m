//
//  InvestmentViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sunny Gupta on 28/10/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "InvestmentViewController.h"

@interface InvestmentViewController ()

@end

@implementation InvestmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textViewDescription.layer.borderWidth=1.0f;
    self.textViewDescription.layer.borderColor=[UIColor blackColor].CGColor;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"about_us_background"]];
    
    self.CheckboxFirst = [[UIButton alloc] initWithFrame:CGRectMake(5,5 ,10,10)];
    [self.CheckboxFirst setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
    [self.CheckboxFirst setBackgroundImage:[UIImage imageNamed:@"checkBx"] forState:UIControlStateSelected];
    [self.CheckboxFirst addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.investTf addSubview:self.CheckboxFirst];
    self.investTf.userInteractionEnabled=NO;
    
    
    
    [self.checkBoxSecond setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
    [self.checkBoxSecond setBackgroundImage:[UIImage imageNamed:@"checkBx"] forState:UIControlStateNormal];
    [self.checkBoxSecond addTarget:self action:@selector(checkBoxSelectedNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.investTf addSubview:self.checkBoxSecond];
    
    

    
    
    self.asapCheckbox=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 15, 15)];
    [self.asapCheckbox setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
    [self.asapCheckbox setBackgroundImage:[UIImage imageNamed:@"checkBx"] forState:UIControlStateNormal];
    [self.asapCheckbox addTarget:self action:@selector(checkSelectedNext:) forControlEvents:UIControlEventTouchUpInside];
   // [self. addSubview:self.asapCheckbox];
    
    
}




-(void)checkSelectedNext:(id)sender{
    
    
    if([self.asapCheckbox isSelected]==YES)
    {
        [self.asapCheckbox setSelected:NO];
    }
    else{
        [self.asapCheckbox setSelected:YES];
    }
    
}



-(void)checkboxSelected:(id)sender{
    
    
    if([self.CheckboxFirst isSelected]==YES)
    {
        [self.CheckboxFirst setSelected:NO];
    }
    else{
        [self.CheckboxFirst setSelected:YES];
    }
    
}


-(void)checkBoxSelectedNext:(id)sender{
    
    
    if([self.checkBoxSecond isSelected]==YES)
    {
        [self.checkBoxSecond setSelected:NO];
    }
    else{
        [self.checkBoxSecond setSelected:YES];
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nameTf becomeFirstResponder];
     [self.emailIdTf becomeFirstResponder];
    [self.contactTf resignFirstResponder];
    [self.streetNameTf resignFirstResponder];
    [self.houseNoTf resignFirstResponder];
    [self.zipcodeTf resignFirstResponder];
    [self.cityTf resignFirstResponder];
    [self.textViewDescription resignFirstResponder];
    
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
@end
