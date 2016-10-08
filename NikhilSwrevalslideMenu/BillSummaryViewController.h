//
//  BillSummaryViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/31/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

@interface BillSummaryViewController : UIViewController<PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate, UIPopoverControllerDelegate>

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;


@property (weak, nonatomic) IBOutlet UILabel *subTotalAmount;
@property (weak, nonatomic) IBOutlet UILabel *salesTaxAmount;
@property (weak, nonatomic) IBOutlet UILabel *deliveryFeeAmount;
@property (weak, nonatomic) IBOutlet UILabel *couponAmount;
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;

@property (weak, nonatomic) IBOutlet UILabel *hSubTotalLbl;
@property (weak, nonatomic) IBOutlet UILabel *hSalesTaxLbl;
@property (weak, nonatomic) IBOutlet UILabel *hDeliveryFeeLbl;
@property (weak, nonatomic) IBOutlet UILabel *hCouponAmountLbl;
@property (weak, nonatomic) IBOutlet UILabel *htotalAmountLbl;

@property (weak, nonatomic) IBOutlet UIView *HTotalAmountView;

@property (weak, nonatomic) IBOutlet UILabel *addressChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *addAddressBtn;
@property (weak, nonatomic) IBOutlet UIButton *paybtn;

@property (weak, nonatomic) IBOutlet UILabel *paymentOptionNamePayPalLbl;
@property (weak, nonatomic) IBOutlet UIButton *payPalPaymentOptionBtn;


- (IBAction)payPalPaymentOptionBtnClick:(id)sender;
- (IBAction)payBtnClick:(id)sender;
- (IBAction)addAddressBtnClick:(id)sender;
- (IBAction)backNavigationClick:(id)sender;

@property(nonatomic,strong)NSString *subTotalPassed;
@property(nonatomic,strong)NSString *salesTaxPassed;
@property(nonatomic,strong)NSString *deliveryFeePassed;
@property(nonatomic,strong)NSString *totalAmountPassed;
@property(nonatomic,strong)NSDictionary *bfPaymentDictionary;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hDeliveryFeeConstriant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deliveryFeeConstriant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hCouponAmountConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponAmountConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hAddressChangeConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addAdressBtnHeightConstraint;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addHeightConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addAddressBtnHeightConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deliveryFeeLblHeightConstriant;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deliveryFeeAmountHeightConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalAmountTopConstraint;

@end
