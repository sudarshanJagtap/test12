//
//  ViewOrderTableViewCell.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 9/6/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "ViewOrderTableViewCell.h"

@implementation ViewOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation viewOrderCustomView

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setupView];
    
  }
  return self;
}

- (instancetype)init {
  
  self = [super init];
  
  if (self) {
    
    [self setupView];
  }
  return self;
}

- (void)awakeFromNib {
  
  [super awakeFromNib];
  [self setupView];
  
}

- (void)setupView {
  
  //float y;
  float width;
  if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
    //        float screenHeight =[self screenSize].height;
    //        y = screenHeight - self.frame.size.height;
    self.frame = CGRectMake(0, 0, 1024, 50);
    
  }else{
    //        float screenHeight =[self screenSize].height;
    //        y = screenHeight - self.frame.size.height;
    width = [self screenSize].width;
    CGRect footerFrame = self.frame;
    footerFrame.origin.x = 0;
    footerFrame.origin.y = 60;
    footerFrame.size.width = width;
    footerFrame.size.height = 40;
    self.frame = footerFrame;
  }
}
- (CGSize)screenSize
{
  CGSize screenSize = [UIScreen mainScreen].bounds.size;
  if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
    return CGSizeMake(screenSize.height, screenSize.width);
  } else {
    return screenSize;
  }
}


@end