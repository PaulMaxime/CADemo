//
//  BasicAnimationsViewController.m
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

#import "BasicAnimationsViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface BasicAnimationsViewController ()

@property(nonatomic, retain) NSMutableArray *layers;

@end
@implementation BasicAnimationsViewController

@synthesize layers = layers_;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    self.view.frame = frame;
    layers_ = [[NSMutableArray alloc] init];
    CGRect bounds = self.view.bounds;
    NSArray *images = [NSArray arrayWithObjects:
                       @"Browser.png", @"Calculator.png", @"Calendar.png", @"Chat.png",
                       @"Clock.png", @"Graph.png", @"iPod.png", @"Maps.png", @"Notes.png",
                       @"Phone.png", @"Settings.png", @"Weather.png", @"Wheel.png", nil];
    NSInteger imageCount = [images count];
    NSInteger rows = 7;
    NSInteger columns = 6;
    CGFloat inset = 60;
    CGFloat space = 50;
    CGFloat width = (bounds.size.width - (inset * 2) - (space * (columns - 1))) / columns;
    
    CALayer *mainLayer = self.view.layer;
    mainLayer.backgroundColor = [UIColor blackColor].CGColor;
    
    int imageIndex = 0;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < columns; c++) {
        CALayer *layer = [CALayer layer];
        layer.contents = (id)[UIImage imageNamed:[images objectAtIndex:imageIndex]].CGImage;
        layer.bounds = CGRectMake(0, 0, width, width);
        layer.edgeAntialiasingMask = kCALayerTopEdge|kCALayerBottomEdge|kCALayerLeftEdge|kCALayerRightEdge;
        [mainLayer addSublayer:layer];
        [layers_ addObject:layer];
        layer.position = CGPointMake(inset + c * (space + width) + width * 0.5,
                                     44 + inset + r * (space + width) + width * 0.5);
        imageIndex = ++imageIndex % imageCount;
      }
    }

  }
  return self;
}

- (void)dealloc {
  [layers_ release];
  [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
  [super viewDidLoad];
  
}

- (void)viewDidUnload {
  [layers_ makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
  [super viewDidUnload];
}

- (IBAction)startWobbling:(id)sender {
  for (CALayer *layer in layers_) {
    [layer removeAllAnimations];
    CABasicAnimation *wobble = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    wobble.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    wobble.duration = 0.1 + (rand() % 10) * 0.005;
    wobble.repeatCount = HUGE_VALF;
    wobble.autoreverses = YES;
    wobble.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(5)];
    wobble.toValue = [NSNumber numberWithFloat:-DEGREES_TO_RADIANS(5)];
    [layer addAnimation:wobble forKey:@"transform.rotation.z"];
  }
}

- (IBAction)startPulsing:(id)sender {
  for (CALayer *layer in layers_) {
    [layer removeAllAnimations];
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    pulse.duration = 0.5 + (rand() % 10) * 0.05;
    pulse.repeatCount = HUGE_VALF;
    pulse.autoreverses = YES;
    pulse.fromValue = [NSNumber numberWithFloat:.8];
    pulse.toValue = [NSNumber numberWithFloat:1.5];
    [layer addAnimation:pulse forKey:@"transform.scale"];
  }
}

- (IBAction)stop:(id)sender {
  for (CALayer *layer in layers_) {
    [layer removeAllAnimations];
  }
}

#pragma mark -
#pragma mark DemoCardSubview methods

- (NSString *)displayName {
  return @"Basic Animations";
}

- (void)startAnimating {
  [self startWobbling:self];
}

- (void)stopAnimating {
  [self stop:self];
}

@end
