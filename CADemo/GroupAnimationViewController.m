//
//  GroupAnimationViewController.m
//  CADemo
//
//  Created by Paul Franceus on 7/25/11.
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


#import "GroupAnimationViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation GroupAnimationViewController

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    self.view.frame = frame;
    self.view.clipsToBounds = YES;
    images_ = [[NSArray arrayWithObjects:
               @"Browser.png", @"Calculator.png", @"Calendar.png", @"Chat.png",
               @"Clock.png", @"Graph.png", @"iPod.png", @"Maps.png", @"Notes.png",
               @"Phone.png", @"Settings.png", @"Weather.png", @"Wheel.png", nil] retain];
    sranddev();
  }
  return self;
}

- (void)dealloc {
  [self stopAnimating];
}

#pragma mark - Animate a layer.

- (void)dropLayer {
  if (++counter_ > 100) {
    counter_ = 100;
    [[self.view.layer.sublayers objectAtIndex:0] removeFromSuperlayer];
  }
  CGRect bounds = self.view.bounds;
  CALayer *layer = [CALayer layer];

  CGFloat size = 64 + (rand() % 2) * 32;
  layer.bounds = CGRectMake(0, 0, size, size);
  layer.position = CGPointMake(rand() % (int)bounds.size.width, rand() % (int)bounds.size.height);
  NSString *imageName = [images_ objectAtIndex:rand() % [images_ count]];
  layer.contents = (id)[UIImage imageNamed:imageName].CGImage;
  [self.view.layer addSublayer:layer];
  self.view.layer.sublayerTransform = CATransform3DMakePerspective(1000);
  
  CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
  fade.fromValue = [NSNumber numberWithFloat:0];
  fade.toValue = [NSNumber numberWithFloat:1.0];
  fade.duration = 2.0;
  
  CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
  scale.fromValue = [NSNumber numberWithFloat:4.0];
  scale.toValue = [NSNumber numberWithFloat:1.0];
  scale.duration = 2.0;
  
  CABasicAnimation *flip = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
  flip.fromValue = [NSNumber numberWithFloat:3 * M_PI];
  flip.toValue = [NSNumber numberWithFloat:0];
  flip.duration = 2.0;

  CABasicAnimation *z = [CABasicAnimation animationWithKeyPath:@"zPosition"];
  z.fromValue = [NSNumber numberWithFloat:200];
  z.toValue = [NSNumber numberWithFloat:0];
  z.duration = 2.0;
  
  CAAnimationGroup *group = [CAAnimationGroup animation];
  group.animations = [NSArray arrayWithObjects:fade, scale, flip, z, nil];
  group.duration = 2.0;
  group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
  
  [layer addAnimation:group forKey:@"drop and fade in"];
}
#pragma mark -
#pragma mark DemoCardSubview methods

- (NSString *)displayName {
  return @"Group Animations";
}

- (void)startAnimating {
  [self dropLayer];
  
  dropTimer_ = [[NSTimer scheduledTimerWithTimeInterval:0.3
                                                target:self
                                              selector:@selector(dropLayer)
                                              userInfo:nil
                                               repeats:YES] retain];
}

- (void)stopAnimating {
  [dropTimer_ invalidate];
  [dropTimer_ release];
}


@end
