//
//  BasicAnimationsViewController.h
//  CADemo
//
//  Created by Paul Franceus on 7/25/11.
//  Copyright 2011 Google, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DemoCardView.h"

@interface BasicAnimationsViewController : UIViewController <DemoCardSubview> {

}

- (IBAction)startWobbling:(id)sender;
- (IBAction)startPulsing:(id)sender;
- (IBAction)stop:(id)sender;

@end
