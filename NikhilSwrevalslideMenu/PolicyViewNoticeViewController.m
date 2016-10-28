//
//  PolicyViewNoticeViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sunny Gupta on 28/10/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "PolicyViewNoticeViewController.h"
#import "PrivacyOpreationController.h"

@interface PolicyViewNoticeViewController ()

@end

@implementation PolicyViewNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"About Us";
    
    
    
    NSString *urlString = @"https://www.ymoc.com/android_api/privacy_notice.php";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest:urlRequest];
    [self.view addSubview:self.myWebView];
   
    
    /*[self.myWebView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@"https://www.ymoc.com/android_api/privacy_notice.php"]];*/
    
    
    
    /*NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"https://www.ymoc.com/android_api/privacy_notice.php" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.myWebView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];*/
    
    
    
    /*NSURL *url = [[NSURL alloc]initFileURLWithPath:@"https://www.ymoc.com/android_api/privacy_notice.php"];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
    //[self.myWebView loadHTMLString:@"https://www.ymoc.com/android_api/privacy_notice.php" baseURL:nil];
    
   /* PrivacyOpreationController *operation = [[PrivacyOpreationController alloc] init];
    [operation callAPIWithParamter:nil success:^(BOOL success, id response) {
        if (response)
        {
           // NSDictionary *dict = [response valueForKey:@"about_us"];
           // NSString *strAboutUs  = [dict valueForKey:@"about_us"];
           
        }
        
    } failure:^(BOOL failed, NSString *errorMessage) {
        
    }];*/
    

    
    
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

- (IBAction)BackButtonAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
