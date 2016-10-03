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

@interface LocationViewController ()<BSKeyboardControlsDelegate,GMSAutocompleteViewControllerDelegate,UISearchBarDelegate,UITextFieldDelegate,GMSAutocompleteFetcherDelegate>{
  
  ResponseUtility *respoUtility;
  UserFiltersResponse *ufpUtility;
}

@property (strong, nonatomic) NSArray *array;


@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@end

@implementation LocationViewController

- (void)viewDidLoad {
  [super viewDidLoad];
//  [self placeAutocomplete];
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
  [self tap:self];
//  [self.keyboardControls setActiveField:textField];
//  [self animateTextField:textField up:YES withOffset:textField.frame.origin.y / 2];
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

//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate showLoadingViewWithString:@"Loading..."];
    LocationViewOperation *operation = [[LocationViewOperation alloc] init];
    operation.blnShowAlertMsg = YES;
    operation.AddressCityState = self.txtEntAddressCityState.text;
    respoUtility.enteredAddress = self.txtEntAddressCityState.text;
     [self performSegueWithIdentifier:@"FromLocationHome" sender:nil];
//    [operation  callAPIWithParamter:nil success:^(BOOL success, id response) {
//      
//      NSDictionary *dictionary = [[NSDictionary alloc]init];
//      
//      self.array = [response valueForKey:@"data"];
//      respoUtility.UserFiltersResponseArray = [[NSMutableArray alloc]init];
//      for (int i = 0 ; i < [self.array count]; i++)
//      {
//        dictionary = [self.array objectAtIndex:i];
//        ufpUtility = [[UserFiltersResponse alloc]init];
//        ufpUtility.address_search = [dictionary valueForKey:@"address_search"];
//        ufpUtility.closing_time = [dictionary valueForKey:@"closing_time"];
//        ufpUtility.cuisine_string = [dictionary valueForKey:@"cuisine_string"];
//        ufpUtility.day = [dictionary valueForKey:@"day"];
//        ufpUtility.delivery_facility = [dictionary valueForKey:@"delivery_facility"];
//        ufpUtility.delivery_time = [dictionary valueForKey:@"delivery_time"];
//        ufpUtility.end_dist = [dictionary valueForKey:@"end_dist"];
//        ufpUtility.fee = [dictionary valueForKey:@"fee"];
//        ufpUtility.ufp_id = [dictionary valueForKey:@"id"];
//        ufpUtility.logo = [dictionary valueForKey:@"logo"];
//        ufpUtility.min_order_amount = [dictionary valueForKey:@"min_order_amount"];
//        ufpUtility.name = [dictionary valueForKey:@"name"];
//        ufpUtility.opening_status = [dictionary valueForKey:@"opening_status"];
//        ufpUtility.opening_time = [dictionary valueForKey:@"opening_time"];
//        ufpUtility.rating = [dictionary valueForKey:@"rating"];
//        ufpUtility.restaurant_status = [dictionary valueForKey:@"restaurant_status"];
//        ufpUtility.start_dist = [dictionary valueForKey:@"start_dist"];        
//        [respoUtility.UserFiltersResponseArray addObject:ufpUtility];
//      }
//
//      [appDelegate hideLoadingView];
//      [self dismissViewControllerAnimated:YES completion:NULL];
//      NSString *cityValue = self.txtEntAddressCityState.text;
//      [[NSUserDefaults standardUserDefaults] setObject:cityValue forKey:@"city"];
//      [[NSUserDefaults standardUserDefaults] synchronize];
//      [self performSegueWithIdentifier:@"FromLocationHome" sender:nil];
//    } failure:^(BOOL failed, NSString *errorMessage) {
//      [appDelegate hideLoadingView];
//    }];
  }else{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Text field can not left blank"
                                                    message:@"Please enter zipcode/address/state/city"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
  }
}

- (IBAction)tap:(id)sender {
  GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
  acController.delegate = self;
  [acController.view setFrame:CGRectMake(50, 50, 200, 200)];
  acController.view.backgroundColor = [UIColor blackColor ];

  [UIColor colorWithRed:(213/255.f) green:(213/255.f) blue:(213/255.f) alpha:1.0f];
  [UIColor colorWithRed:188.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0];
  [UIColor colorWithRed:112/255.0 green:170.0/255.0 blue:157.0/255.0 alpha:1.0];
  acController.tableCellBackgroundColor = [UIColor colorWithRed:112/255.0 green:170.0/255.0 blue:157.0/255.0 alpha:1.0];;
  acController.tableCellSeparatorColor = [UIColor whiteColor];
  acController.primaryTextColor = [UIColor whiteColor];
  acController.secondaryTextColor = [UIColor whiteColor];
   acController.primaryTextHighlightColor = [UIColor whiteColor];
  [self presentViewController:acController animated:YES completion:nil];
  
}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
  [self dismissViewControllerAnimated:NO completion:nil];
  // Do something with the selected place.
  NSLog(@"Place name %@", place.name);
  NSLog(@"Place address %@", place.formattedAddress);
  NSLog(@"Place attributions %@", place.attributions.string);
  self.txtEntAddressCityState.text = place.formattedAddress;
  [self btnFindFood:self];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
  [self dismissViewControllerAnimated:YES completion:nil];
  // TODO: handle the error.
  NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
  [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  [searchBar resignFirstResponder];
  // Do the search...
}


//- (void)placeAutocomplete {
//  
//  GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
//  filter.type = kGMSPlacesAutocompleteTypeFilterEstablishment;
//  GMSPlacesClient *_placesClient = [[GMSPlacesClient alloc]init];
//  [_placesClient autocompleteQuery:@"pune"
//                            bounds:nil
//                            filter:filter
//                          callback:^(NSArray *results, NSError *error) {
//                            if (error != nil) {
//                              NSLog(@"Autocomplete error %@", [error localizedDescription]);
//                              return;
//                            }
//                            
//                            for (GMSAutocompletePrediction* result in results) {
//                              NSLog(@"\nResult '%@' ", result.attributedFullText.string);
//                            }
//                          }];
//}
//{
//  UITextField *_textField;
//  UITextView *_resultText;
//  GMSAutocompleteFetcher* _fetcher;
//}
//
//- (void)viewDidLoad {
//  [super viewDidLoad];
//  
//  self.view.backgroundColor = [UIColor whiteColor];
//  self.edgesForExtendedLayout = UIRectEdgeNone;
//  
//  // Set bounds to inner-west Sydney Australia.
//  CLLocationCoordinate2D neBoundsCorner = CLLocationCoordinate2DMake(-33.843366, 151.134002);
//  CLLocationCoordinate2D swBoundsCorner = CLLocationCoordinate2DMake(-33.875725, 151.200349);
//  GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:neBoundsCorner
//                                                                     coordinate:swBoundsCorner];
//  
//  // Set up the autocomplete filter.
//  GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
//  filter.type = kGMSPlacesAutocompleteTypeFilterEstablishment;
//  
//  // Create the fetcher.
//  _fetcher = [[GMSAutocompleteFetcher alloc] initWithBounds:bounds
//                                                     filter:filter];
//  _fetcher.delegate = self;
//  
//  // Set up the UITextField and UITextView.
//  _textField = [[UITextField alloc] initWithFrame:CGRectMake(5.0f,
//                                                             0,
//                                                             self.view.bounds.size.width - 5.0f,
//                                                             44.0f)];
//  _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//  [_textField addTarget:self
//                 action:@selector(textFieldDidChange:)
//       forControlEvents:UIControlEventEditingChanged];
//  _resultText =[[UITextView alloc] initWithFrame:CGRectMake(0,
//                                                            45.0f,
//                                                            self.view.bounds.size.width,
//                                                            self.view.bounds.size.height - 45.0f)];
//  _resultText.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
//  _resultText.text = @"No Results";
//  _resultText.editable = NO;
//  [self.view addSubview:_textField];
//  [self.view addSubview:_resultText];
//}
//
//- (void)textFieldDidChange:(UITextField *)textField {
//  NSLog(@"%@", textField.text);
//  [_fetcher sourceTextHasChanged:textField.text];
//}
//
//#pragma mark - GMSAutocompleteFetcherDelegate
//- (void)didAutocompleteWithPredictions:(NSArray *)predictions {
//  NSMutableString *resultsStr = [NSMutableString string];
//  for (GMSAutocompletePrediction *prediction in predictions) {
//    [resultsStr appendFormat:@"%@\n", [prediction.attributedPrimaryText string]];
//  }
//  _resultText.text = resultsStr;
//}
//
//- (void)didFailAutocompleteWithError:(NSError *)error {
//  _resultText.text = [NSString stringWithFormat:@"%@", error.localizedDescription];
//}
//
@end
