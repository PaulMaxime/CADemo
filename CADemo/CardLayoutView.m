//
//  CardLayoutView.m
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

#import "CardLayoutView.h"
#import "DemoCardView.h"
#import "GraphicsUtils.h"

@interface CardLayoutView ()

@property CGSize subviewSize;

@end

@implementation CardLayoutView

@synthesize dataSource = dataSource_;
@synthesize layout = layout_;
@synthesize inset = inset_;
@synthesize spacing = spacing_;
@synthesize rows = rows_;
@synthesize columns = columns_;
@synthesize animationDuration = animationDuration_;
@synthesize subviewSize = subviewSize_;

- (void)awakeFromNib {
  [self.dataSource addObserver:self
                    forKeyPath:[self.dataSource observableKeyPath]
                       options:NSKeyValueObservingOptionNew
                       context:NULL];
  self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1.0];
}


- (void)dealloc {
  [self.dataSource removeObserver:self forKeyPath:[self.dataSource observableKeyPath]];
  [super dealloc];
}

#pragma mark -
#pragma mark Data Source methods

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  [self setNeedsLayout];
}

- (NSArray *)viewsFromDataSource {
  return [self.dataSource valueForKeyPath:[self.dataSource observableKeyPath]];
}

- (void)removeUnneededSubviews {
  NSArray *views = [self viewsFromDataSource];
  for (UIView *view in self.subviews) {
    if (![views containsObject:view]) {
      [view removeFromSuperview];
    }
  }
}

- (void)updateCircle {
  CGRect bounds = self.bounds;
  NSUInteger index = 0;
    
  [UIView beginAnimations:@"circleView" context:NULL];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:animationDuration_];
  
  CGPoint center = [GraphicsUtils centerOfRect:bounds];
  CGSize size = bounds.size;
  CGFloat offset = 0.5 * MIN(size.width - subviewSize_.width - inset_.width,
                             size.height - subviewSize_.height - inset_.height);
  
  // This is pure laziness. I should figure out the correct size based on the screen size.
  subviewSize_ = CGSizeMake(125, 125);

  NSArray *newViews = [self viewsFromDataSource];
  CGFloat angle = 2 * M_PI / [newViews count];
  for (DemoCardView *view in newViews) {
    if (!view.isZoomedIn) {
      CGFloat xOffset = offset * cosf(angle * index);
      CGFloat yOffset = offset * sinf(angle * index);
      
      view.center = CGPointMake(center.x + xOffset, center.y + yOffset);
      CGRect newBounds = CGRectMake(0, 0, subviewSize_.width, subviewSize_.height);
      CGFloat scale = [GraphicsUtils scaleForSize:view.bounds.size inRect:newBounds];
      CGAffineTransform scaleAndRotate =
          CGAffineTransformRotate(CGAffineTransformMakeScale(scale, scale), angle * index + M_PI_2);
      view.transform = scaleAndRotate;
      
      if (![self.subviews containsObject:view]) {
        [self addSubview:view];
      }
    }
    index++;
  }
  [UIView commitAnimations];  
}

- (void)updateGrid {
  CGRect bounds = self.bounds;
  
  subviewSize_.width = (bounds.size.width - (2 * inset_.width) - ((columns_ - 1) * spacing_.width))
      / columns_;
  subviewSize_.height = (bounds.size.height - (2 * inset_.height) - ((rows_ - 1) * spacing_.height))
      / rows_;
  NSUInteger index = 0;
  
  [UIView beginAnimations:@"gridView" context:NULL];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:animationDuration_];
  
  NSArray *newViews = [self viewsFromDataSource];
  for (DemoCardView *view in newViews) {
    if (!view.isZoomedIn) {
      NSUInteger row = index / columns_;
      NSUInteger col = index % columns_;
      row = row % rows_;
      
      // Compute the new rect 
      CGRect newFrame = CGRectMake(
          inset_.width + col * (subviewSize_.width + spacing_.width),
          inset_.height + row * (subviewSize_.height + spacing_.height),
          subviewSize_.width, subviewSize_.height);
      
      // Use the transform to resize the view. Move it by setting the center.
      CGFloat scale = [GraphicsUtils scaleForSize:self.bounds.size inRect:newFrame];
      view.center = [GraphicsUtils centerOfRect:newFrame];
      view.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
      
      if (![self.subviews containsObject:view]) {
        [self addSubview:view];
      }
    }
    index++;
  }
  
  [UIView commitAnimations];
  
}

- (void)layoutSubviews {
  [self removeUnneededSubviews];
  
  if (layout_ == kCardLayoutGrid) {    
    [self updateGrid];
  } else if (layout_ == kCardLayoutCircle) {
    [self updateCircle];
  }
}
@end
