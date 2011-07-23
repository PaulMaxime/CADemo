//
//  CardLayoutViewController.h
//  CADemo
//
//  Created by Paul Franceus on 7/20/11.
//  Copyright 2011 Google, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CardLayoutView.h"

@interface CardLayoutViewController : UIViewController <CardLayoutDataSource> {
  
}
@property(nonatomic, retain) IBOutlet CardLayoutView *cardLayoutView;
@property(nonatomic, readonly) NSMutableArray *cardViews;

- (NSString *)observableKeyPath;

@end
