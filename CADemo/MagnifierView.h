//
//  MagnifierView.h
//  Editions
//
//  Created by Paul Franceus on 7/22/09.
//  Copyright 2009 Google, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// This class presents a magnified view of an underlying view, managed by
// the |OverlayView| superclass at the point touched by a user.
// It is supplied with an image by the superclass, which can either be a
// directly supplied image or an image of the parent view.
@interface MagnifierView : UIView {
 @private
  NSTimer *magnifyTimer_;  // Timer used to start magnifier
  BOOL isShowingMagnifier_;  // Is the magnifier being displayed?
  CALayer *layer_;  // The layer representing the magnifier itself.
  CALayer *imageLayer_;  // Layer that contains the image to be magnified.
  CGPoint touchPoint_;  // Where we have touched.
  CGFloat magnificationFactor_;  // How much we want to magnify the image.
  CGSize viewSize_;  // Size of the view.
  CGSize imageViewSize_;  // Size of the image view
  CGSize magnifierSize_;  // Size of the magnifier.
}

@property(nonatomic,assign) CGPoint touchPoint;
@property(nonatomic,assign) float magnificationFactor;

- (void)setSourceImage:(UIImage *)image;

@end
