//
//  NNRestaurantView.h
//  lunchd
//
//  Created by MacRae Linton on 3/26/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NNRestaurant.h"


@interface NNRestaurantView : NSView {
	NSTextField *nameField;
	NSButton *voteButton;
	NSButton *vetoButton;
	
	NNRestaurant *representedRestaurant;
}
- (id)initWithFrame:(NSRect)frame andController:(id)controller;

- (void)setRepresentedRestaurant:(NNRestaurant *)restaurant;
- (NNRestaurant *)representedRestaurant;

//This takes the state in the object and redraws.
//gets called by observing the votes attribute on the represented restaurant
- (void)updateState;


@end
