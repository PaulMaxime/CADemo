//
//  KeyPathAnimationViewController.m
//  CADemo
//
//  Created by Paul Franceus on 7/23/11.
//  Copyright 2011 Google, Inc. All rights reserved.
//

#import "KeyPathAnimationViewController.h"

#import "KeyPathAnimationView.h"

@implementation KeyPathAnimationViewController

@synthesize goButton = goButton_;
@synthesize keyPathView = keyPathView_;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
      // Custom initialization
      self.view.frame = frame;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewDidUnload {
  [self setGoButton:nil];
  [self setKeyPathView:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
  [goButton_ release];
  [keyPathView_ release];
  [super dealloc];
}

- (IBAction)runAnimation:(id)sender {
  [keyPathView_ runAnimation];
}

#pragma mark -
#pragma mark DemoCardSubview methods

- (NSString *)displayName {
  return @"Key Frame Animation";
}

- (void)startAnimating {
  
}

- (void)stopAnimating {
  
}

@end
