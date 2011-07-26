//
//  MoviePlayerViewController.m
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

#import "MoviePlayerViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "GraphicsUtils.h"

@implementation MoviePlayerViewController

@synthesize player = player_;
@synthesize playerLayer = playerLayer_;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    self.view.frame = frame;
  }
  return self;
}

- (void)dealloc {
	[self.player pause];
	[player_ release];
	[super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor darkGrayColor];
  
	// Setup AVPlayer
  // You've been rickrolled.
	NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"rickroll" ofType:@"mp4"];
	self.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:moviePath]];
	
	// Create and configure AVPlayerLayer
	self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
	self.playerLayer.bounds = CGRectMake(0, 0, 600, 300);
	self.playerLayer.position = CGPointMake(355, 400);
	self.playerLayer.borderColor = [UIColor darkGrayColor].CGColor;
  self.playerLayer.borderWidth = 10.0;
	self.playerLayer.shadowOffset = CGSizeMake(0, 3);
	self.playerLayer.shadowOpacity = 0.80;
  
  // Add perspective transform
	self.view.layer.sublayerTransform = CATransform3DMakePerspective(1000);	
	[self.view.layer addSublayer:self.playerLayer];	
}

// Rotate the layer around the Y-axis as slider value is changed
-(void)sliderValueChanged:(UISlider *)sender{
	self.playerLayer.transform = CATransform3DMakeRotation([sender value], 0, 1, 0);
}

// Animate spinning video around X-axis
- (void)spinIt:(id)sender {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
	animation.duration = 1.25f;
	animation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(360)];
	[self.playerLayer addAnimation:animation forKey:@"spinAnimation"];
}

- (NSString *)displayName {
  return @"Movie in a layer";
}

- (void)startAnimating {
  [self.player play];
}

- (void)stopAnimating {
  [self.player pause];
}

@end
