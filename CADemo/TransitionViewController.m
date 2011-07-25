//
//  TransitionViewController.m
//  CADemo
//
//  Created by Paul Franceus on 7/24/11.
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

#import "TransitionViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "TransitionTypeViewController.h"
#import "TransitionDirectionViewController.h"

@interface TransitionViewController ()

@property(nonatomic, retain) TransitionTypeViewController *typeViewController;
@property(nonatomic, retain) TransitionDirectionViewController *directionViewController;
@property(nonatomic, retain) UIPopoverController *typePopover;
@property(nonatomic, retain) UIPopoverController *directionPopover;

@end


@implementation TransitionViewController
@synthesize toolbar = toolbar_;
@synthesize transitionButton = transitionButton_;
@synthesize directionButton = directionButton_;
@synthesize imageView = imageView_;
@synthesize typeViewController = typeViewController_;
@synthesize directionViewController = directionViewController_;
@synthesize typePopover = typePopover_;
@synthesize directionPopover = directionPopover_;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
      self.view.frame = frame;
      transition_ = [[CATransition animation] retain];
      transition_.type = typeViewController_.selectedType;
      transition_.subtype = directionViewController_.selectedDirection;
      transition_.duration = .75;
      transition_.timingFunction =
          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
      transition_.removedOnCompletion = YES;
    }
    return self;
}

- (void)dealloc {
  [images_ release];
  [transition_ release];
  [imageView_ release];
  [repeatTimer_ invalidate];
  [repeatTimer_ release];
  [toolbar_ release];
  [transitionButton_ release];
  [directionButton_ release];
  [typePopover_ release];
  [typeViewController_ release];
  [directionPopover_ release];
  [directionViewController_ release];
  [super dealloc];
}

- (void)animate {
	if (++imageIndex_ >= [images_ count]) {
		imageIndex_ = 0;
	}
  
	self.imageView.layer.contents = (id)[UIImage imageNamed:[images_ objectAtIndex:imageIndex_]].CGImage;
  [self.imageView.layer addAnimation:transition_ forKey:@"Transition"];
}

#pragma mark -
#pragma mark DemoCardSubview methods

- (NSString *)displayName {
  return @"Core Animation Transitions";
}

- (void)startAnimating {
  repeatTimer_ = [[NSTimer scheduledTimerWithTimeInterval:3
                                                   target:self
                                                 selector:@selector(animate)
                                                 userInfo:nil
                                                  repeats:YES] retain];
}

- (void)stopAnimating {
  [repeatTimer_ invalidate];
  [repeatTimer_ release];
  repeatTimer_ = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  images_ = [[NSArray arrayWithObjects:@"glacier.jpg", @"moab.jpg", @"paris.JPG", @"rainbow.jpg", 
             @"redrock.jpg", @"sydney.jpg", nil] retain];
  self.typeViewController = [[TransitionTypeViewController alloc] init];
  self.typeViewController.delegate = self;
  self.typePopover = [[[UIPopoverController alloc]
                      initWithContentViewController:self.typeViewController] autorelease];
  
  self.directionViewController = [[TransitionDirectionViewController alloc] init];
  self.directionViewController.delegate = self;
  self.directionPopover = [[[UIPopoverController alloc]
                            initWithContentViewController:self.directionViewController] autorelease];
  self.imageView.layer.contents = (id)[UIImage imageNamed:[images_ objectAtIndex:0]].CGImage;
  self.imageView.backgroundColor = [UIColor blackColor];
  self.view.layer.backgroundColor = [UIColor blackColor].CGColor;
}

- (void)viewDidUnload {
  [self setDirectionButton:nil];
  [self setTransitionButton:nil];
  [self setToolbar:nil];
  [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

- (IBAction)showTransitionPopover:(id)sender {
  [self.typePopover presentPopoverFromBarButtonItem:sender
                           permittedArrowDirections:UIPopoverArrowDirectionAny
                                           animated:YES];
}

- (IBAction)showDirectionPopover:(id)sender {
  [self.directionPopover presentPopoverFromBarButtonItem:sender
                                permittedArrowDirections:UIPopoverArrowDirectionAny
                                                animated:YES];
}

#pragma mark -
#pragma mark Delegate methods.

- (void)transitionTypeController:(TransitionTypeViewController *)controller
                   didSelectType:(NSString *)type {
  [self.typePopover dismissPopoverAnimated:YES];
  transition_.type = typeViewController_.selectedType;
}

- (void)transitionDirectionController:(TransitionDirectionViewController *)controller
                   didSelectDirection:(NSString *)direction {
  [self.directionPopover dismissPopoverAnimated:YES];
  transition_.subtype = directionViewController_.selectedDirection;
}

@end
