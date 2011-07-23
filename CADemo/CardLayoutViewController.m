//
//  CardLayoutViewController.m
//  CADemo
//
//  Created by Paul Franceus on 7/20/11.
//  Copyright 2011 Google, Inc. All rights reserved.
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
  CGRect cardFrame = CGRectMake(0, 0, 200, 200);
  for (int i = 0; i < 12; i++) {
    DemoCardView *cardView = [[[DemoCardView alloc] initWithFrame:cardFrame] autorelease];
    cardView.parentController = self;
    cardView.demoView = [[UIView alloc] initWithFrame:cardFrame];
    cardView.demoView.backgroundColor = [UIColor colorWithHue:.5 saturation:.5 brightness:.5 alpha:1];
    [cardViews_ addObject:cardView];
  }
  ((DemoCardView *)[cardViews_ objectAtIndex:8]).demoView =
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
