//
//  LocationViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Nikhil Boriwale on 11/07/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "LocationViewController.h"
#import <BSKeyboardControls/BSKeyboardControls.h>
#import "LocationViewOperation.h"
#import "Validation.h"
#import "CommonAlertViewController.h"
#import "AppDelegate.h"
#import "FrontHomeScreenViewController.h"
#import "ResponseUtility.h"
#import <GooglePlaces/GooglePlaces.h>
#import "NIDropDown.h"
@interface LocationViewController ()<BSKeyboardControlsDelegate,UITextFieldDelegate,GMSAutocompleteFetcherDelegate,NIDropDownDelegate>{
  
  ResponseUtility *respoUtility;
  UserFiltersResponse *ufpUtility;
   NIDropDown *dropDown;
  GMSAutocompleteFetcher* _fetcher;
}

@property (strong, nonatomic) NSArray *array;


@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@end

@implementation LocationViewController
@synthesize imgView;
- (void)viewDidLoad {
  [super viewDidLoad];
  [self configureAutoCompleteView];
  self.txtEntAddressCityState.text = @"";
  respoUtility = [ResponseUtility getSharedInstance];
  [self.navigationController.navigationBar setTranslucent:YES];
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  self.navigationController.view.backgroundColor = [UIColor clearColor];
  [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
  self.txtEntAddressCityState.delegate = self;
  self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
  self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
  self.txtEntAddressCityState.layer.borderColor=[[UIColor whiteColor]CGColor];
  self.txtEntAddressCityState.layer.borderWidth=2.0;
  NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Enter Address,City,State" attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor] }];
  self.txtEntAddressCityState.attributedPlaceholder = str;
  self.array = @[self.txtEntAddressCityState];
  [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:self.array]];
  [self.keyboardControls setDelegate:self];
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
  [keyboardControls.activeField resignFirstResponder];
  [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
  [self animateTextField:textField up:NO withOffset:textField.frame.origin.y / 2];
  
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
  
  [self.keyboardControls setActiveField:textView];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  
  [textField resignFirstResponder];
  return true;
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up withOffset:(CGFloat)offset
{
  const int movementDistance = -offset;
  const float movementDuration = 0.4f;
  int movement = (up ? movementDistance : -movementDistance);
  [UIView beginAnimations: @"animateTextField" context: nil];
  [UIView setAnimationBeginsFromCurrentState: YES];
  [UIView setAnimationDuration: movementDuration];
  self.view.frame = CGRectOffset(self.view.frame, 0, movement);
  [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)btnFindFood:(id)sender {

  NSString *edtData=self.txtEntAddressCityState.text;
  if ([edtData length] > 0) {
    LocationViewOperation *operation = [[LocationViewOperation alloc] init];
    operation.blnShowAlertMsg = YES;
    operation.AddressCityState = self.txtEntAddressCityState.text;
    respoUtility.enteredAddress = self.txtEntAddressCityState.text;
     [self performSegueWithIdentifier:@"FromLocationHome" sender:nil];
  }else{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Text field can not left blank"
                                                    message:@"Please enter zipcode/address/state/city"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
  }
}

#pragma mark Custom AutoComplete

-(void)configureAutoCompleteView{
  // Set bounds to inner-west Sydney Australia.
  CLLocationCoordinate2D neBoundsCorner = CLLocationCoordinate2DMake(-33.843366, 151.134002);
  CLLocationCoordinate2D swBoundsCorner = CLLocationCoordinate2DMake(-33.875725, 151.200349);
  GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:neBoundsCorner
                                                                     coordinate:swBoundsCorner];
  
  GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
  filter.type = kGMSPlacesAutocompleteTypeFilterEstablishment;
  _fetcher = [[GMSAutocompleteFetcher alloc] initWithBounds:bounds
                                                     filter:filter];
  _fetcher.delegate = self;
  [self.txtEntAddressCityState addTarget:self
                 action:@selector(textFieldDidChange:)
       forControlEvents:UIControlEventEditingChanged];

  imgView.userInteractionEnabled = YES;
  UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
  tapGesture1.numberOfTapsRequired = 1;
//  [tapGesture1 setDelegate:self];
  [imgView addGestureRecognizer:tapGesture1];
}

- (void) tapGesture: (id)sender
{
  [dropDown hideDropDown:self.txtEntAddressCityState];
  [self rel];
}

- (void)textFieldDidChange:(UITextField *)textField {
  NSLog(@"%@", textField.text);
  [_fetcher sourceTextHasChanged:textField.text];
}



#pragma mark - GMSAutocompleteFetcherDelegate
- (void)didAutocompleteWithPredictions:(NSArray *)predictions {
  NSMutableString *resultsStr = [NSMutableString string];
  NSMutableArray *autoArray = [[NSMutableArray alloc]init];
  for (GMSAutocompletePrediction *prediction in predictions) {
    [resultsStr appendFormat:@"%@\n", [prediction.attributedPrimaryText string]];
    [autoArray addObject:[prediction.attributedPrimaryText string]];
  }
  NSArray *passArray = [NSArray arrayWithArray:autoArray];
  if(dropDown == nil) {
    CGFloat f = 200;
    dropDown = [[NIDropDown alloc]showDropDown:self.txtEntAddressCityState :&f :passArray :nil :@"down"];
    dropDown.delegate = self;
  }
  else {
    [dropDown hideDropDown:self.txtEntAddressCityState];
    [self rel];
  }
}

- (void)didFailAutocompleteWithError:(NSError *)error {
  if(dropDown == nil) {
    CGFloat f = 200;
    dropDown = [[NIDropDown alloc]showDropDown:self.txtEntAddressCityState :&f :nil :nil :@"down"];
    dropDown.delegate = self;
  }
  else {
    [dropDown hideDropDown:self.txtEntAddressCityState];
    [self rel];
  }
}


#pragma mark drop down
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
  [self btnFindFood:self];
  [self rel];
}

-(void)rel{
  dropDown = nil;
}

@end
