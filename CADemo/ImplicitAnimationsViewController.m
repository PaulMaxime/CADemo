//
//  MIT License
//
//  Copyright (c) 2011 Bob McCune http://bobmccune.com/
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
#import "ImplicitAnimationsViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "GraphicsUtils.h"

@interface ImplicitAnimationsViewController ()

@property(nonatomic,assign) CGPoint initialPosition;
@property(nonatomic,assign) CGPoint movedPosition;
@property(nonatomic,retain) UIColor *initialColor;
@property(nonatomic,retain) UIColor *changedColor;
@end

@implementation ImplicitAnimationsViewController

@synthesize initialPosition, movedPosition, initialColor, changedColor;

- (NSString *)displayName {
	return @"Animatable Properties";
}

- (void)startAnimating {
  
}

- (void)stopAnimating {
  
}

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithNibName:nil bundle:nil])) {
    self.view.frame = frame;
		layer = [CALayer layer];
		layer.bounds = CGRectMake(0, 0, 300, 300);
    self.initialPosition = [GraphicsUtils centerOfRect:frame];
    self.movedPosition = CGPointMake(self.initialPosition.x + 100, self.initialPosition.y + 150);
		layer.position = [GraphicsUtils centerOfRect:frame];
    self.initialColor = [UIColor colorWithHue:0.1 saturation:.4 brightness:.9 alpha:1.0];
    self.changedColor = [UIColor colorWithHue:0.8 saturation:.9 brightness:.6 alpha:1.0];
		layer.backgroundColor = self.initialColor.CGColor;
		layer.borderColor = [UIColor blackColor].CGColor;
		layer.opacity = 1.0f;
		[self.view.layer addSublayer:layer];		
	}
	return self;
}

- (void)dealloc {
  [initialColor release];
  [changedColor release];
  [super dealloc];
}

- (void)viewDidLoad {
  [super viewDidLoad];
	self.actionsSwitch.on = NO;
}

- (IBAction)toggleColor {
	[CATransaction setDisableActions:actionsSwitch.on];
	layer.backgroundColor = (layer.backgroundColor == self.initialColor.CGColor) ? 
      self.changedColor.CGColor : self.initialColor.CGColor;
}

- (IBAction)toggleCornerRadius {
	[CATransaction setDisableActions:actionsSwitch.on];
	layer.cornerRadius = (layer.cornerRadius == 0.0f) ? 60.0f : 0.0f;
}

- (IBAction)toggleBorder {
	[CATransaction setDisableActions:actionsSwitch.on];
	layer.borderWidth = (layer.borderWidth == 0.0f) ? 10.0f : 0.0f;
}

- (IBAction)toggleOpacity {
	[CATransaction setDisableActions:actionsSwitch.on];
	layer.opacity = (layer.opacity == 1.0f) ? 0.3f : 1.0f;
}

- (IBAction)toggleBounds {
	[CATransaction setDisableActions:actionsSwitch.on];
  CGRect bounds = layer.bounds;
  bounds.size.width += layer.bounds.size.width == layer.bounds.size.height ? 150 : -150;
  layer.bounds = bounds;
}

- (IBAction)togglePosition {
	[CATransaction setDisableActions:actionsSwitch.on];
	layer.position = 
      layer.position.x == self.initialPosition.x ? self.movedPosition : self.initialPosition;
}

@synthesize actionsSwitch;

@end
