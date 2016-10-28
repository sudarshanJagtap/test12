//
//  LeaderShipViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sunny Gupta on 28/10/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "LeaderShipViewController.h"

@interface LeaderShipViewController ()

@end

@implementation LeaderShipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *urlString = @"https://www.ymoc.com/android_api/leadership.php";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.mywebView loadRequest:urlRequest];
    [self.view addSubview:self.mywebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
