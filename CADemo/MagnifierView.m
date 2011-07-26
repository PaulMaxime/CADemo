//
//  MagnifierView.m
//  Editions
//
//  Created by Paul Franceus on 7/22/09.
//  Copyright 2009 Google, Inc. All rights reserved.
//

#import "MagnifierView.h"
#import "GraphicsUtils.h"

@implementation MagnifierView

@synthesize touchPoint=touchPoint_;
@synthesize magnificationFactor=magnificationFactor_;

static float const kDefaultMagnificationFactor = 2.0;
static CGPoint const kImageOffset = {0.5, 0.8};
static CGPoint const kViewOffset = {0.0, 30.0};
static CGSize const kMagnifierFraction = {0.3, 0.3};

- (id)initWithFrame:(CGRect)frame {
  magnifierSize_ = CGSizeMake(frame.size.width * kMagnifierFraction.width,
                              frame.size.width * kMagnifierFraction.height);
  CGRect portal = CGRectMake(0, 0, magnifierSize_.width, magnifierSize_.height);
  self = [super initWithFrame:portal];
  if (self) {
    self.userInteractionEnabled = YES;
    viewSize_ = frame.size;
    magnificationFactor_ = kDefaultMagnificationFactor;
    layer_ = [[self layer] retain];
    [layer_ setBounds:portal];
    [layer_ setCornerRadius:10.0];
    [layer_ setMasksToBounds:YES];
    [layer_ setBorderColor:[[UIColor grayColor] CGColor]];
    [layer_ setBorderWidth:4.0];
    imageLayer_ = [[CALayer alloc] init];
    [imageLayer_ setAnchorPoint:CGPointMake(0, 0)];
    imageViewSize_ = CGSizeMake(viewSize_.width * magnificationFactor_,
                                viewSize_.height * magnificationFactor_);
    [imageLayer_ setBounds:CGRectMake(
        0, 0, imageViewSize_.width, imageViewSize_.height)];
    [layer_ addSublayer:imageLayer_];
  }
  return self;
}

#pragma mark Magnify methods.

- (void)showMagnifierAtPoint:(CGPoint)touchPoint {
  layer_.hidden = NO;
  [self setTouchPoint:touchPoint];
  [self setNeedsLayout];
}

#pragma mark -
#pragma mark touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint originalTouch = [touch locationInView:self.superview];
  [self showMagnifierAtPoint:originalTouch]; 
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint originalTouch = [touch locationInView:self.superview];
  [self showMagnifierAtPoint:originalTouch];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [self touchesEnded:touches withEvent:event];
}

- (void)setSourceImage:(UIImage *)image {
  [imageLayer_ setContents:(id)[image CGImage]];
}

- (void)layoutSubviews {
  // Position the layer on the screen.
  CGPoint position = CGPointMake(
      touchPoint_.x + kViewOffset.x,
      touchPoint_.y - magnifierSize_.height * 0.5 - kViewOffset.y);
  position.x = [GraphicsUtils clamp:position.x
                               from:magnifierSize_.width * 0.5
                                 to:viewSize_.width - magnifierSize_.width * 0.5];
  position.y =  [GraphicsUtils clamp:position.y
                                from:magnifierSize_.height * 0.5
                                  to:viewSize_.height - magnifierSize_.height * 0.5];
    
  // Position the image within the magnifier.
  CGPoint imagePosition = CGPointMake(
      -touchPoint_.x * magnificationFactor_ + magnifierSize_.width * kImageOffset.x,
      -touchPoint_.y * magnificationFactor_ + magnifierSize_.height * kImageOffset.y);
  imagePosition.x = [GraphicsUtils clamp:imagePosition.x
                                    from:-imageViewSize_.width + magnifierSize_.width
                                      to:0];
  imagePosition.y = [GraphicsUtils clamp:imagePosition.y
                                    from:-imageViewSize_.height + magnifierSize_.height
                                      to:0];
    
  // Turn off implicit animations so that things happen immediately.
  [CATransaction setDisableActions:YES];
  [layer_ setPosition:position];
  [imageLayer_ setPosition:imagePosition];
}

- (void)dealloc {
  [layer_ release];
  [imageLayer_ release];
  [super dealloc];
}

@end
