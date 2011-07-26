//
//  MagnifierViewController.m
//  Editions
//
//  Created by Paul Franceus on 11/23/09.
//  Copyright 2009 Google Inc. All rights reserved.
//

#import "MagnifierViewController.h"
#import "MagnifierView.h"

@interface MagnifierViewController ()

@property(nonatomic, assign) CGRect frame;

@end

@implementation MagnifierViewController

@synthesize frame = frame_;

#pragma mark View controller methods.

- (id)initWithFrame:(CGRect)frame {
  self = [super init];
  if (self) {
    frame_ = frame;
  }
  return self;
}

- (void)loadView {
  imageView_ = [[UIImageView alloc] initWithFrame:frame_];
  magnifierView_ = [[MagnifierView alloc] initWithFrame:frame_];
  
  self.view = imageView_;
  [imageView_ addSubview:magnifierView_];
  
  UIImage *image = [UIImage imageNamed:@"sydney.jpg"];
  imageView_.image = image;
  imageView_.userInteractionEnabled = NO;
  [magnifierView_ setSourceImage:image];
}

- (void)dealloc {
  [magnifierView_ removeFromSuperview];
  [magnifierView_ release];
  [super dealloc];
}

#pragma mark -
#pragma mark DemoCardSubview methods

- (NSString *)displayName {
  return @"Magnifier using CALayers";
}

- (void)startAnimating {
  
}

- (void)stopAnimating {
  
}


@end
