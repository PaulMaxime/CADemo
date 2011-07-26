//
//  MoviePlayerViewController.h
//  CADemo
//
//  Created by Paul Franceus on 7/25/11.
//  Copyright 2011 Google, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoCardView.h"

@class AVPlayer;
@class AVPlayerLayer;

@interface MoviePlayerViewController : UIViewController <DemoCardSubview> {
  AVPlayer *player_;
  AVPlayerLayer *playerLayer_;
}
@property(nonatomic, retain) AVPlayer *player;
@property(nonatomic, retain) AVPlayerLayer *playerLayer;

- (IBAction)sliderValueChanged:(UISlider *)sender;
- (IBAction)spinIt:(id)sender;

@end
