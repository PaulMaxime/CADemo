//
//  GIPDismissControl.h
//
//  Created by Jeremy Faller on 4/13/11.
//  Copyright 2011 Google, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


// A generic dismiss control -- like the control in springboard that comes
// up to delete applications.
@interface DismissControl : UIView {
 @private
  UIColor *textBackground_;
  UIColor *textForeground_;
  NSString *text_;

  UIColor *bezelColor_;
  UIColor *targetColor_;
  UIColor *targetBackgroundColor_;

  id target_;
  SEL action_;
}

@property(nonatomic, readwrite, retain) UIColor *textBackground;
@property(nonatomic, readwrite, retain) UIColor *textForeground;
@property(nonatomic, readwrite, copy) NSString *text;

@property(nonatomic, readwrite, retain) UIColor *bezelColor;
@property(nonatomic, readwrite, retain) UIColor *targetColor;
@property(nonatomic, readwrite, retain) UIColor *targetBackgroundColor;

@property(nonatomic, readwrite, retain) id target;

- (void)setTarget:(id)target action:(SEL)sel;

@end
