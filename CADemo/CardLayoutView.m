//
//  CardLayoutView.m
//  CADemo
//
//  Created by Paul Franceus on 7/20/11.
//  Copyright 2011 Google, Inc. All rights reserved.
//

#import "CardLayoutView.h"
#import "DemoCardView.h"

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
  subviewSize_ = CGSizeMake(100, 100);
  
  [UIView beginAnimations:@"circleView" context:NULL];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:animationDuration_];
  
  CGFloat midx = CGRectGetMidX(bounds);
  CGFloat midy = CGRectGetMidY(bounds);
  CGPoint center = CGPointMake(midx, midy);
  CGSize size = bounds.size;
  CGFloat offset = 0.5 * MIN(size.width - subviewSize_.width - inset_.width,
                             size.height - subviewSize_.height - inset_.height);
    
  NSArray *newViews = [self viewsFromDataSource];
  CGFloat angle = 2 * M_PI / [newViews count];
  for (DemoCardView *view in newViews) {
    if (!view.isZoomedIn) {
      CGFloat xOffset = offset * cosf(angle * index);
      CGFloat yOffset = offset * sinf(angle * index);
      
      view.center = CGPointMake(center.x + xOffset, center.y + yOffset);
      view.bounds = CGRectMake(0, 0, subviewSize_.width, subviewSize_.height);
      view.transform = CGAffineTransformMakeRotation(angle * index);
      
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
  
  subviewSize_.width = (bounds.size.width - (2 * inset_.width) - ((columns_ - 1) * spacing_.width)) / columns_;
  subviewSize_.height = (bounds.size.height - (2 * inset_.height) - ((rows_ - 1) * spacing_.height)) / rows_;
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
      
      CGRect newFrame = CGRectMake(
          inset_.width + col * (subviewSize_.width + spacing_.width),
          inset_.height + row * (subviewSize_.height + spacing_.height),
          subviewSize_.width, subviewSize_.height);
      
      view.center = CGPointMake(newFrame.origin.x + 0.5 * newFrame.size.width,
                                newFrame.origin.y + 0.5 * newFrame.size.height);
      view.bounds = CGRectMake(0, 0, newFrame.size.width, newFrame.size.height);
      view.transform = CGAffineTransformIdentity;
      
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
