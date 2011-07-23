//
//  CardLayoutView.h
//  CADemo
//
//  Created by Paul Franceus on 7/20/11.
//  Copyright 2011 Google, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardLayoutDataSource <NSObject>

- (NSString *)observableKeyPath;

@end

typedef enum {
  kCardLayoutGrid,
  kCardLayoutCircle,
  kCardLayoutRandom
} CardLayout;

@interface CardLayoutView : UIView

@property(nonatomic, assign) IBOutlet id dataSource;
@property(nonatomic, readwrite) CardLayout layout;
@property(nonatomic, assign) CGSize inset;
@property(nonatomic, assign) CGSize spacing;
@property(nonatomic, assign) NSUInteger rows;
@property(nonatomic, assign) NSUInteger columns;
@property(nonatomic, assign) NSTimeInterval animationDuration;


@end

