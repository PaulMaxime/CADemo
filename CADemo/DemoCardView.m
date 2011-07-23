//
//  DemoCardView.m
//  CADemo
//
//  Created by Paul Franceus on 7/20/11.
//  Copyright 2011 Google, Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DemoCardView.h"
#import "DismissControl.h"
#import "CardLayoutViewController.h"

@interface DemoCardView ()

@property(nonatomic, retain) UITapGestureRecognizer *tapRecognizer;
@property(nonatomic, retain) DismissControl *dismissControl;

@end

@implementation DemoCardView

@synthesize parentController = parentController_;
@synthesize zoomedIn = zoomedIn_;
@synthesize tapRecognizer = tapRecognizer_;
@synthesize dismissControl = dismissControl_;
@synthesize demoView = demoView_;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      CALayer *layer = self.layer;
      layer.cornerRadius = 5.0;
      layer.backgroundColor = [UIColor whiteColor].CGColor;
      layer.opaque = YES;
      layer.shadowOffset = CGSizeMake(4, 8);
      layer.shadowRadius = 3;
      
      dismissControl_ = [[DismissControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
      [dismissControl_ setTarget:self action:@selector(dismissTapped)];
      
      tapRecognizer_ = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                               action:@selector(viewTapped)];
      [self addGestureRecognizer:tapRecognizer_];
      zoomedIn_ = NO;
      
    }
    return self;
}

- (void)dealloc {
  [tapRecognizer_ release];
  [dismissControl_ release];
}


- (void)layoutSubviews {
  [UIView beginAnimations:@"layout" context:NULL];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:0.4];
  
  CGRect newFrame = CGRectInset(self.bounds, 3, 3);
  demoView_.bounds = CGRectMake(0, 0, newFrame.size.width, newFrame.size.height);
  demoView_.center = CGPointMake(newFrame.origin.x + newFrame.size.width * 0.5,
                            newFrame.origin.y + newFrame.size.height * 0.5);
  [UIView commitAnimations];
}


- (void)setDemoView:(UIView *)demoView {
  [demoView_ removeFromSuperview];
  [demoView_ autorelease];
  demoView_ = [demoView retain];
  [self addSubview:demoView_];
  [self setNeedsLayout];
}

- (void)animationDidStop:(NSString *)animation 
                finished:(BOOL)flag
                 context:(void *)context {
  // Add the shadow.
  if ([animation isEqualToString:@"zoom in"]) {
    CALayer *layer = self.layer;
    [CATransaction setAnimationDuration:0];
    layer.shadowOpacity = 0.5;
    
    // Add the close box to the view
    CGPoint origin = [self convertPoint:self.bounds.origin
                                 toView:self.parentController.view];
    dismissControl_.center = origin;
    [self.parentController.view insertSubview:dismissControl_
                                 belowSubview:self];
    [demoView_ setUserInteractionEnabled:YES];
  }
}

- (void)viewTapped {
  // Zoom in the view and remove the tap recognizer.
  [self removeGestureRecognizer:tapRecognizer_];
  
  // Make sure we are the topmost view.
  NSInteger cardCount = [self.parentController.cardViews count];
  [self.parentController.cardLayoutView insertSubview:self atIndex:cardCount - 1];
   
   CGRect layoutFrame = self.parentController.cardLayoutView.frame;
  
  [UIView beginAnimations:@"zoom in" context:NULL];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:0.4];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
  
  self.bounds = CGRectMake(0, 0, layoutFrame.size.width - 40, layoutFrame.size.height - 40);
  self.center = CGPointMake(layoutFrame.origin.x + layoutFrame.size.width * 0.5,
                            layoutFrame.origin.y + layoutFrame.size.height * 0.5);
  self.transform = CGAffineTransformIdentity;

  zoomedIn_ = YES;
  
  [UIView commitAnimations];
}

- (void)dismissTapped {
  [demoView_ setUserInteractionEnabled:NO];
  [self addGestureRecognizer:tapRecognizer_];
  [dismissControl_ removeFromSuperview];
  CALayer *layer = self.layer;
  layer.shadowOpacity = 0;
  zoomedIn_ = NO;
  [self.parentController.cardLayoutView setNeedsLayout];
}

@end
