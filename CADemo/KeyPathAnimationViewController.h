//
//  KeyPathAnimationViewController.h
//  CADemo
//
//  Created by Paul Franceus on 7/23/11.
//  Copyright 2011 Google, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DemoCardView.h"

@class KeyPathAnimationView;

@interface KeyPathAnimationViewController : UIViewController <DemoCardSubview>
 

@property (nonatomic, retain) IBOutlet UIButton *goButton;
@property (nonatomic, retain) IBOutlet KeyPathAnimationView *keyPathView;


- (IBAction)runAnimation:(id)sender;

@end
  
