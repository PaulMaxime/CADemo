//
//  DemoCardView.m
//  CADemo
//
//  Created by Paul Franceus on 7/20/11.
//
//  MIT License
//
//  Copyright (c) 2011 Paul Franceus
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>

#import "DemoCardView.h"
#import "DismissControl.h"
#import "GraphicsUtils.h"
#import "CardLayoutViewController.h"

@interface DemoCardView ()

@property(nonatomic, retain) UITapGestureRecognizer *tapRecognizer;
@property(nonatomic, retain) DismissControl *dismissControl;
@property(nonatomic, retain) UIView *actualDemoView;

@end

@implementation DemoCardView

@synthesize parentController = parentController_;
@synthesize zoomedIn = zoomedIn_;
@synthesize tapRecognizer = tapRecognizer_;
@synthesize dismissControl = dismissControl_;
@synthesize demoView = demoView_;
@synthesize actualDemoView = actualDemoView_;

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
  [demoView_ release];
  [actualDemoView_ release];
}


- (void)layoutSubviews {
  actualDemoView_.bounds = self.bounds;
  actualDemoView_.center = [GraphicsUtils centerOfRect:self.bounds];
}


- (void)setDemoView:(id<DemoCardSubview>)demoView {
  [demoView_ autorelease];
  demoView_ = [demoView retain];
  [actualDemoView_ autorelease];
  if ([demoView isKindOfClass:[UIView class]]) {
    actualDemoView_ = (UIView *)[demoView retain];
  } else if ([demoView isKindOfClass:[UIViewController class]]) {
    actualDemoView_ = [((UIViewController *)demoView).view retain];
  }
  [actualDemoView_ removeFromSuperview];
  actualDemoView_.userInteractionEnabled = NO;
  [self addSubview:actualDemoView_];
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
    [actualDemoView_ setUserInteractionEnabled:YES];
    if ([demoView_ respondsToSelector:@selector(startAnimating)]) {
      [demoView_ startAnimating];
    }
  }
}

- (void)viewTapped {
  // Zoom in the view and remove the tap recognizer.
  [self removeGestureRecognizer:tapRecognizer_];
  
  // Make sure we are the topmost view.
  NSInteger cardCount = [self.parentController.cardViews count];
  [self.parentController.cardLayoutView insertSubview:self atIndex:cardCount - 1];
  if ([demoView_ respondsToSelector:@selector(displayName)]) {
    self.parentController.navigationItem.title = demoView_.displayName;
  }
  CGRect layoutFrame = self.parentController.cardLayoutView.frame;
  
  [UIView beginAnimations:@"zoom in" context:NULL];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:0.4];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
  

  self.center = [GraphicsUtils centerOfRect:layoutFrame];
  self.transform = CGAffineTransformIdentity;

  zoomedIn_ = YES;
  
  [UIView commitAnimations];
}

- (void)dismissTapped {
  self.parentController.navigationItem.title = nil;
  if ([demoView_ respondsToSelector:@selector(stopAnimating)]) {
    [demoView_ stopAnimating];
  }
  [actualDemoView_ setUserInteractionEnabled:NO];
  [self addGestureRecognizer:tapRecognizer_];
  [dismissControl_ removeFromSuperview];
  CALayer *layer = self.layer;
  layer.shadowOpacity = 0;
  zoomedIn_ = NO;
  [self.parentController.cardLayoutView setNeedsLayout];
}

@end
