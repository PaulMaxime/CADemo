//
//  TransitionTypeViewController.m
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


#import "TransitionTypeViewController.h"


@implementation TransitionTypeViewController

@synthesize delegate = delegate_;
@synthesize selectedType = selectedType_;

- (id)init{
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    // http://iphonedevwiki.net/index.php/CATransition
    types_ = [[NSArray alloc] initWithObjects:
              kCATransitionFade,
              kCATransitionMoveIn,
              kCATransitionPush,
              kCATransitionReveal,
              @"cameraIris",
              @"cameraIrisHollowOpen",
              @"cameraIrisHollowClose",
              @"cube",
              @"alignedCube",
              @"flip",
              @"alignedFlip",
              @"oglFlip",
              @"rotate",
              @"pageCurl",
              @"pageUnCurl",
              @"rippleEffect",
              @"suckEffect",
              nil];
  }
  return self;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [types_ count];
}

- (CGSize)contentSizeForViewInPopover {
  return CGSizeMake(320, 44 * [types_ count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
	NSString *string = [types_ objectAtIndex:indexPath.row];
	cell.textLabel.text = string;	
	if (indexPath.row == selectedIndex_) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	selectedIndex_ = indexPath.row;
	[delegate_ transitionTypeController:self didSelectType:self.selectedType];
	[tableView reloadData];
	[self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)selectedType {
	return [types_ objectAtIndex:selectedIndex_];
}

@end
