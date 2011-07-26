//
//  MagnifierViewController.h
//  Editions
//
//  Created by Paul Franceus on 11/23/09.
//  Copyright 2009 Google Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DemoCardView.h"

@class MagnifierView;

@interface MagnifierViewController : UIViewController <DemoCardSubview> {
 @private
  UIImageView *imageView_;
  MagnifierView *magnifierView_;
}

@end
