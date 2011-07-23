//
//  CardLayoutViewController.m
//  CADemo
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

#import "CardLayoutViewController.h"

#import "DemoCardView.h"
#import "SettingsViewController.h"
#import "SublayerTransformView.h"

@interface CardLayoutViewController ()

@property(nonatomic, retain) UISegmentedControl *layoutControl;
@property(nonatomic, retain) UIBarButtonItem *settingsItem;
@property(nonatomic, retain) UIPopoverController *settingsPopover;

- (void)setParametersForOrientation:(UIInterfaceOrientation)orientation;
@end

@implementation CardLayoutViewController

@synthesize cardViews = cardViews_;
@synthesize cardLayoutView = cardLayoutView_;
@synthesize layoutControl = layoutControl_;
@synthesize settingsItem = settingsItem_;
@synthesize settingsPopover = settingsPopover_;

- (void)dealloc {
  [cardViews_ release];
  [layoutControl_ release];
  [settingsPopover_ release];
  [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setParametersForOrientation:self.interfaceOrientation];
  cardViews_ = [[NSMutableArray alloc] init];
  cardLayoutView_.inset = CGSizeMake(30, 30);
  cardLayoutView_.spacing = CGSizeMake(30, 30);
  cardLayoutView_.animationDuration = 0.4;
  
  layoutControl_ = [[UISegmentedControl alloc] initWithItems:
                    [NSArray arrayWithObjects:@"Grid", @"Circle", nil]];
  layoutControl_.segmentedControlStyle = UISegmentedControlStyleBar;
  layoutControl_.selectedSegmentIndex = 0;
  [layoutControl_ addTarget:self
                    action:@selector(updateLayout)
          forControlEvents:UIControlEventValueChanged];

  UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                         target:nil
                                                                         action:nil];
  UIBarButtonItem *layoutItem = [[[UIBarButtonItem alloc] initWithCustomView:layoutControl_]
                                  autorelease];
  self.toolbarItems = [NSArray arrayWithObjects:space, layoutItem, space, nil];
  [self.navigationController setToolbarHidden:NO animated:NO];
  
  settingsItem_ = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                   style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action:@selector(loadSettingsPopover)];
  self.navigationItem.rightBarButtonItem = settingsItem_;
  
  // Every view is always sized to fit the screen. If it's shrunk, it's due to the view transform.
  CGRect layoutFrame = cardLayoutView_.frame;
  CGRect cardFrame = CGRectMake(0, 0, layoutFrame.size.width - 40, layoutFrame.size.height - 148);
  for (int i = 0; i < 12; i++) {
    DemoCardView *cardView = [[[DemoCardView alloc] initWithFrame:cardFrame] autorelease];
    cardView.parentController = self;
    cardView.demoView = [[UIView alloc] initWithFrame:cardFrame];
    cardView.demoView.backgroundColor = [UIColor colorWithHue:.6 saturation:.5 brightness:.5 alpha:1];
    [cardViews_ addObject:cardView];
  }
  ((DemoCardView *)[cardViews_ objectAtIndex:2]).demoView =
      [[SublayerTransformView alloc] initWithFrame:cardFrame];
  [cardLayoutView_ setNeedsLayout];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

#pragma mark -
#pragma mark Interface actions

- (void)updateLayout {
  NSInteger index = [layoutControl_ selectedSegmentIndex];
  if (index == 0) {
    cardLayoutView_.layout = kCardLayoutGrid;
  } else {
    cardLayoutView_.layout = kCardLayoutCircle;
  }
  [cardLayoutView_ setNeedsLayout];
}

- (void)loadSettingsPopover {
  if (!settingsPopover_) {
    SettingsViewController *settingsController = [[SettingsViewController alloc] init];
    settingsPopover_ = [[UIPopoverController alloc]
        initWithContentViewController:settingsController];
  }
  [settingsPopover_ presentPopoverFromBarButtonItem:settingsItem_
                           permittedArrowDirections:UIPopoverArrowDirectionAny
                                           animated:YES];
  
}

#pragma mark -
#pragma mark User interface rotation.

- (void)setParametersForOrientation:(UIInterfaceOrientation)orientation {
  if (UIInterfaceOrientationIsPortrait(orientation)) {
    cardLayoutView_.rows = 4;
    cardLayoutView_.columns = 3;
  } else if (UIInterfaceOrientationIsLandscape(orientation)) {
    cardLayoutView_.rows = 3;
    cardLayoutView_.columns = 4;
  }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
  cardLayoutView_.animationDuration = duration;
  [self setParametersForOrientation:toInterfaceOrientation];
  
  // TODO: Set the bounds of all the views to the new shape.
  
  [cardLayoutView_ setNeedsLayout];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark CardLayoutDataSource

- (NSString *)observableKeyPath {
  return @"cardViews";
}

@end
