//
//  SublayerTransformView.m
//  CADemo
//
//  Created by Paul Franceus on 7/20/11. Based on Core Animation Demo by 
//  Bob McCune http://bobmccune.com/
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

#import <QuartzCore/QuartzCore.h>

#import "SublayerTransformView.h"

#import "GraphicsUtils.h"

@interface SublayerTransformView ()

- (void)setUp;

@property(nonatomic, assign) CGFloat shortSide;

@end

@implementation SublayerTransformView

@synthesize shortSide = shortSide_;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setUp];
  }
  return self;
}

- (NSString *)displayName {
	return @"3D Perspective and Transforms";
}

- (void)addLayersWithColors:(NSArray *)colors {
  CGRect bounds = self.bounds;
  shortSide_ = MIN(bounds.size.width, bounds.size.height);
  CGSize dimensions = CGSizeMake(shortSide_ * .5, shortSide_ * .5);
  CGRect layerBounds = CGRectMake(0, 0, dimensions.width, dimensions.height);
  CGFloat zPosition = 0;
	for (UIColor *color in colors) {
		CALayer *layer = [CALayer layer];
		layer.backgroundColor = color.CGColor;
		layer.bounds = layerBounds;
		layer.position = [GraphicsUtils centerOfRect:bounds];
		layer.opacity = 0.65;
		layer.cornerRadius = 10;
		layer.borderColor = [UIColor whiteColor].CGColor;
		layer.borderWidth = 1.0;
		layer.shadowOffset = CGSizeMake(0, 2);
		layer.shadowOpacity = 0.35;
		layer.shadowColor = [UIColor darkGrayColor].CGColor;
		layer.shouldRasterize = YES;
    layer.zPosition = zPosition;
    zPosition += 90;
		[rootLayer_ addSublayer:layer];
	}
}

- (void)setUp {
	rootLayer_ = [CALayer layer];
  // Apply perspective transform
  rootLayer_.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
	rootLayer_.sublayerTransform = CATransform3DMakePerspective(1500);
	rootLayer_.frame = self.bounds;
	[self.layer addSublayer:rootLayer_];
	
	NSArray *colors = [NSArray arrayWithObjects:
      [UIColor redColor], [UIColor greenColor], [UIColor purpleColor], nil];
	[self addLayersWithColors:colors];
}

- (void)rotateLayers {
  // Create basic animation to rotate around the Y and Z axes
	CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	transformAnimation.toValue =
      [NSValue valueWithCATransform3D:CATransform3DMakeRotation(DEGREES_TO_RADIANS(150), 0, 1, 1)];
	transformAnimation.duration = 1.5;
	transformAnimation.autoreverses = YES;
	transformAnimation.repeatCount = HUGE_VALF;
	transformAnimation.timingFunction =
      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
  // TODO pure laziness here too.
  int increment = shortSide_ / 4;
	int tx = -increment;
  // Loop through the sublayers and attach the animations
	for (CALayer *layer in [rootLayer_ sublayers]) {
		[layer addAnimation:transformAnimation forKey:nil];
		
    // Create animation to translate along the X axis
		CABasicAnimation *translateAnimation =
        [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
		translateAnimation.fromValue = [NSValue valueWithCATransform3D:layer.transform];
		translateAnimation.toValue = [NSNumber numberWithFloat:tx];
		translateAnimation.duration = 1.5;
		translateAnimation.autoreverses = YES;
		translateAnimation.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		translateAnimation.repeatCount = HUGE_VALF;
		[layer addAnimation:translateAnimation forKey:nil];
		tx += increment;
	}
}

- (void)startAnimating {
  [self rotateLayers];
}

- (void)stopAnimating {
  for (CALayer *layer in [rootLayer_ sublayers]) {
    [layer removeAllAnimations];
  }
}

@end
