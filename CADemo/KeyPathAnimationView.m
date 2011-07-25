//
//  KeyPathAnimationView.m
//  CADemo
//
//  Created by Paul Franceus on 7/23/11.
//  Copyright 2011 Google, Inc. All rights reserved.
//

#import "KeyPathAnimationView.h"
@interface KeyPathAnimationView () 

@property(nonatomic, retain) NSMutableArray *touchPoints;
@property(nonatomic, retain) UITapGestureRecognizer *tapRecognizer;
@property(nonatomic, retain) CALayer *movingLayer;

@end

@implementation KeyPathAnimationView

@synthesize touchPoints = touchPoints_;
@synthesize tapRecognizer = tapRecognizer_;
@synthesize movingLayer = movingLayer_;

- (void)awakeFromNib {
  self.touchPoints = [NSMutableArray array];
  tapRecognizer_ = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(viewTapped)];
  [self addGestureRecognizer:tapRecognizer_];
}

- (void)dealloc {
  [touchPoints_ release];
  [tapRecognizer_ release];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
  for (NSValue *loc in touchPoints_) {
    CGPoint location = [loc CGPointValue];
    [@"+" drawAtPoint:location withFont:[UIFont systemFontOfSize:24]];
  }
}
                                         
#pragma mark - 
#pragma mark Event handling

- (void)viewTapped {
  CGPoint location = [tapRecognizer_ locationInView:self];
  [touchPoints_ addObject:[NSValue valueWithCGPoint:location]];
  [self setNeedsDisplay];
}

#pragma mark -
#pragma mark KeyPathAnimationViewController methods

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
  [touchPoints_ removeAllObjects];
  [self setNeedsDisplay];
}

- (void)runAnimation {
  NSInteger points = [touchPoints_ count];
  if (points > 0) {
    CALayer *layer = self.layer;
    
    if (self.movingLayer) {
      [movingLayer_ removeFromSuperlayer];
    }
    self.movingLayer = [CALayer layer];
    self.movingLayer.bounds = CGRectMake(0, 0, 60, 60);
    self.movingLayer.cornerRadius = 10;
    self.movingLayer.backgroundColor = [UIColor redColor].CGColor;
    self.movingLayer.position = [[touchPoints_ objectAtIndex:0] CGPointValue];
    [layer addSublayer:self.movingLayer];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.removedOnCompletion = YES;
    animation.duration = 0.5 * points;
    animation.calculationMode = kCAAnimationCubicPaced;
    animation.rotationMode = kCAAnimationRotateAuto;
    animation.values = touchPoints_;
    animation.delegate = self;
    
    [self.movingLayer addAnimation:animation forKey:@"followPath"];
    
    // Make sure the animation sticks after it's done.
    self.movingLayer.position = [[touchPoints_ lastObject] CGPointValue];
  }  
}

@end
