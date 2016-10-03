//
//  Constant.h
//  NikhilSwrevalslideMenu
//
//  Created by Nikhil Boriwale on 12/07/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define customWidth 150.0


#define kServiceNameNear                    @"all_nplace.php"
#define kServiceNameAmenities               @"all_amenity.php"
#define kServiceNameGalleryPhotos           @"all_gallery.php"
#define kServiceNameGallery                 @"image_folder.php"
#define kServiceNameChangePassword          @"change_password.php"
#define kServiceNameReceipt                 @"getrecipt.php"
#define kServiceNameStoreList               @"getstore.php"
#define kServiceNameBankDetails             @"getbank_detail.php"
#define kServiceNameMaintenace              @"all_maintenance.php"
#define kServiceNameNotice                  @"all_notice.php"
#define kServiceNameCommittee               @"all_committee.php"
#define kServiceNameEvents                  @"all_events.php"
#define kServiceNameDirectory               @"all_users.php"
#define kServiceNameHelpLine                @"all_helpline.php"
#define kServiceNameAboutUs                 @"getabout_us.php"
#define kServiceNameInfo                    @"register.php"
#define kServiceNameDirectoryCheck          @"directory_check.php"
#define kserviceCreateSociety               @"createsociety.php"
#define kServiceNameSocietyList             @"all_society.php"
#define kServiceNameHowToUse                @"howtouse.php"
#define kServiceVerificationCode            @"mobile_verify.php"
#define kServiceForgotPassword              @"forgotpass.php"
#define kServiceNameRegistration              @"registration.php"
#define kServiceNameAllServiceList            @"nearestServiceCenter.php"
#define kServiceNameAllStoreList              @"nearestStore.php"
#define kServiceNameViewProfile               @"viewprofile.php"
#define kParamNameAddress @"address"
#define kParamNamePassword @"password"

//YMOC App
#define kServiceNameLogin                    @"filter_on_address.php"
#define kServiceNameCuisine                    @"cuisine_name.php" 
#define kServiceNameDirectryURL              @"user_filter.php"
#define kParamNameFilter @"filter_val"
#define kParamNameRating @"rating"

#define kParamNamefeature @"feature"
#define kParamNameaddress @"address"
#define kParamNameall_cuisine @"all_cuisine"
#define kParamNamesorting @"sorting"
#define kParamNamedelivery_status @"delivery_status"
#define kParamNameaction1 @"action1"


#define kServiceNameGetAllCities              @"getallcity.php"
#define KserviceNameGetAllImagesOffer         @"Get_offerimages.php"
#define kServiceNameNewExclusiveOffer         @"newexclusive_offer.php"
#define kServiceNameUpdateProfile             @"updateprofile.php"
//#define kServiceNameAboutUs                   @"getAbout_us.php"
#define kServiceNameContactUs                 @"getContact_us.php"
#define kServiceNameEnquiry                   @"enquiry.php"
#define kServiceNameStoreFeedback             @"feedback_store.php"
#define kServiceNameServiceCentreFeedback     @"feedback_servicecenter.php"
#define kServiceNmaeForgotPassword            @"forgetpassword.php"
#define kServiceNameMobileVerification            @"mobile_verification.php"
//#define urlForImage                           @"http://45.55.164.39/unicorn/uploads"
#define urlForImageDirectory                            @"http://socyto.com/socyto/profile_pic/"
#define urlForImageStoreList                @"http://socyto.com/socyto/img/store/"
#define urlForImageCommittee                @"http://socyto.com/socyto/img/committee/"
#define urlForGallery                       @"http://socyto.com/socyto/img/uploaded/"
#define urlForReceipt                       @"http://socyto.com/socyto/img/recipt/"
#define urlForNearBy                        @""
#define HelveticaLight [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];



#define IS_IPAD    (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
#define IS_IPHONE !IS_IPAD

#define IS_IPHONE_6_PLUS  ([[UIScreen mainScreen] bounds].size.height == 736  && IS_IPHONE)?TRUE:FALSE
#define IS_IPHONE_6  ([[UIScreen mainScreen] bounds].size.height == 667 && IS_IPHONE )?TRUE:FALSE
#define IS_IPHONE_5  ([[UIScreen mainScreen] bounds].size.height == 568 && IS_IPHONE)?TRUE:FALSE
#define IS_IPHONE_4  ([[UIScreen mainScreen] bounds].size.height == 480 && IS_IPHONE)?TRUE:FALSE

#define IS_iOS8  SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")
#define IS_iOS7  SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#define IS_LESS_THAN_iOS8 SYSTEM_VERSION_LESS_THAN(@"8.0")
#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&([UIScreen mainScreen].scale == 2.0))

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define   kNSUserDefaults  [NSUserDefaults standardUserDefaults]
#define kAutoLogin @"autoLogin"


#endif /* Constant_h */
