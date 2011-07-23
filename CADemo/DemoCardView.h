//
//  DemoCardView.h
//  CADemo
//
//  Created by Paul Franceus on 7/20/11.
//  Copyright 2011 Google, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardLayoutViewController;

@interface DemoCardView : UIView

@property(nonatomic, assign) CardLayoutViewController *parentController;
@property(nonatomic, assign, getter = isZoomedIn) BOOL zoomedIn;
@property(nonatomic, retain) UIView *demoView;

@end
