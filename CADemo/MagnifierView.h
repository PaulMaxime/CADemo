//
//  MagnifierView.h
//  Editions
//
//  Created by Paul Franceus on 7/22/09.
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


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// This class presents a magnified view of an underlying view, at the point touched by a user.
// It is supplied with an image by the superclass, which can either be a
// directly supplied image or an image of the parent view.
@interface MagnifierView : UIView {
 @private
  CALayer *layer_;  // The layer representing the magnifier itself.
  CALayer *imageLayer_;  // Layer that contains the image to be magnified.
  CGPoint touchPoint_;  // Where we have touched.
  CGFloat magnificationFactor_;  // How much we want to magnify the image.
  CGSize viewSize_;  // Size of the view.
  CGSize imageViewSize_;  // Size of the image view
  CGSize magnifierSize_;  // Size of the magnifier.
}

@property(nonatomic,assign) CGPoint touchPoint;
@property(nonatomic,assign) float magnificationFactor;

- (void)setSourceImage:(UIImage *)image;

@end
