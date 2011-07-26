//
//  DismissControl.h
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
