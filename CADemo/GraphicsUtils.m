//
//  GraphicsUtils.m
//  CADemo
//
//  Created by Paul Franceus on 7/23/11.
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

#import "GraphicsUtils.h"

@implementation GraphicsUtils

+ (CGFloat)scaleForSize:(CGSize)size inRect:(CGRect)rect {
  CGFloat hScale = rect.size.width / size.width;
  CGFloat vScale = rect.size.height / size.height;
  
  return  MIN(hScale, vScale);
}

+ (CGRect)centerSize:(CGSize)size inRect:(CGRect)rect {
  CGFloat scale = [GraphicsUtils scaleForSize:size inRect:rect];
  CGRect result;
  result.size = CGSizeMake(size.width * scale, size.height * scale);
  result.origin = CGPointMake(rect.origin.x + 0.5 * (rect.size.width - size.width),
                              rect.origin.y + 0.5 * (rect.size.height - size.height));
  return result;
}

+ (CGPoint)centerOfRect:(CGRect)rect {
  CGFloat midx = CGRectGetMidX(rect);
  CGFloat midy = CGRectGetMidY(rect);
  return CGPointMake(midx, midy);
}
@end
