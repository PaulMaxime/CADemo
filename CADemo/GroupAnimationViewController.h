//
//  GroupAnimationViewController.h
//  CADemo
//
//  Created by Paul Franceus on 7/25/11.
//  Copyright 2011 Google, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DemoCardView.h"

@interface GroupAnimationViewController : UIViewController <DemoCardSubview> {
  NSTimer *dropTimer_;
  NSArray *images_;
}
@end
