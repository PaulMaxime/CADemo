//
//  DismissControl.m
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

#import "DismissControl.h"

#import <QuartzCore/QuartzCore.h>

static const CGFloat kBezelHeight = 20.0;
static const CGFloat kBezelWidth = 20.0;  // square control
static const CGSize kShadowOffset = {2.0, 2.0};
static const CGFloat kShadowOpacity = 0.5;
static const CGFloat kShadowRadius = 2.0;
static const CGFloat kTargetInset = 2.0;
static const CGFloat kTargetLineWidth = 2.0;

@implementation DismissControl

@synthesize textBackground = textBackground_;
@synthesize textForeground = textForeground_;
@synthesize text = text_;

@synthesize bezelColor = bezelColor_;
@synthesize targetColor = targetColor_;
@synthesize targetBackgroundColor = targetBackgroundColor_;

@synthesize target = target_;

- (void)setUp {
  // Set up the shadow.
  CALayer *layer = [self layer];
  [layer setBackgroundColor:[[UIColor clearColor] CGColor]];
  [layer setShadowOpacity:kShadowOpacity];
  [layer setShadowOffset:kShadowOffset];

  // Set up the colors.
  [self setTextBackground:[UIColor whiteColor]];
  [self setTextForeground:[UIColor blackColor]];
  [self setBackgroundColor:[UIColor clearColor]];
  [self setBezelColor:[UIColor whiteColor]];
  [self setTargetColor:[UIColor whiteColor]];
  [self setTargetBackgroundColor:[UIColor blackColor]];

  // Set up the gesture recognizer.
  SEL sel = @selector(controlDidTap:);
  UITapGestureRecognizer *tapGesture =
      [[[UITapGestureRecognizer alloc] initWithTarget:self
                                               action:sel] autorelease];
  [tapGesture setNumberOfTapsRequired:1];
  [tapGesture setNumberOfTouchesRequired:1];
  [self addGestureRecognizer:tapGesture];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setUp];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
  self = [super initWithCoder:decoder];
  if (self) {
    [self setUp];
  }
  return self;
}

- (void)dealloc {
  [self setTextBackground:nil];
  [self setTextForeground:nil];
  [self setText:nil];

  [self setBezelColor:nil];
  [self setTargetColor:nil];
  [self setTargetBackgroundColor:nil];

  [self setTarget:nil];
  [super dealloc];
}

- (CGRect)bezelRect {
  // NB: The bezel rect is square.
  return CGRectMake(0, 0, kBezelWidth, kBezelHeight);
}

- (void)drawRect:(CGRect)rect {
  UIBezierPath *shadowPath = [UIBezierPath bezierPath];

  // Draw the label.
  if (text_) {
    UIFont *font = [UIFont boldSystemFontOfSize:11];
    CGSize size = [text_ sizeWithFont:font];
    CGRect tRect = CGRectMake(0, 0,
                              size.width + kBezelWidth * 1.5, kBezelHeight);
    UIBezierPath *tPath =
        [UIBezierPath bezierPathWithRoundedRect:tRect
                              byRoundingCorners:UIRectCornerAllCorners
                                    cornerRadii:CGSizeMake(kBezelWidth / 2,
                                                           kBezelHeight / 2)];
    [[self textBackground] setFill];
    [tPath fill];
    [shadowPath appendPath:tPath];
    tRect.origin.y += (tRect.size.height - size.height) / 2;
    tRect.origin.x += kBezelWidth;
    [textForeground_ setFill];
    [text_ drawInRect:tRect withFont:font];
  }

  // Draw the bezel.
  CGRect bRect = [self bezelRect];
  [[self bezelColor] setFill];
  UIBezierPath *bezelPath = [UIBezierPath bezierPathWithOvalInRect:bRect];
  [bezelPath fill];
  [shadowPath appendPath:bezelPath];
  [[self layer] setShadowPath:[shadowPath CGPath]];

  // Draw the target background.
  bRect = CGRectInset(bRect, kTargetInset, kTargetInset);
  [[self targetBackgroundColor] setFill];
  UIBezierPath *backgroundPath = [UIBezierPath bezierPathWithOvalInRect:bRect];
  [backgroundPath fill];

  // Draw the X.
  bRect = CGRectInset(bRect, kTargetInset * 2, kTargetInset * 2);
  UIBezierPath *xPath = [UIBezierPath bezierPath];
  [xPath moveToPoint:CGPointMake(CGRectGetMinX(bRect), CGRectGetMinY(bRect))];
  [xPath addLineToPoint:CGPointMake(CGRectGetMaxX(bRect),
                                    CGRectGetMaxY(bRect))];
  [xPath moveToPoint:CGPointMake(CGRectGetMaxX(bRect), CGRectGetMinY(bRect))];
  [xPath addLineToPoint:CGPointMake(CGRectGetMinX(bRect),
                                    CGRectGetMaxY(bRect))];
  [[self targetColor] setStroke];
  [xPath setLineWidth:kTargetLineWidth];
  [xPath stroke];

}

#pragma mark - Control

- (void)setTarget:(id)target action:(SEL)sel {
  if (target_ != target) {
    [target_ release];
    target_ = [target retain];
  }
  action_ = sel;
}

- (void)controlDidTap:(UITapGestureRecognizer*)tapGesture {
  CGPoint pt = [tapGesture locationInView:self];
  if (!CGRectContainsPoint([self bezelRect], pt)) {
    return;
  }
  if (target_) {
    if ([target_ respondsToSelector:action_]) {
      [target_ performSelector:action_ withObject:self];
    }
  }
}

@end
