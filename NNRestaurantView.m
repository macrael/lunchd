//
//  NNRestaurantView.m
//  lunchd
//
//  Created by MacRae Linton on 3/26/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import "NNRestaurantView.h"


@implementation NNRestaurantView

- (id)initWithFrame:(NSRect)frame andController:(id)controller{
    self = [super initWithFrame:frame];
    if (self) {
		NSLog(@"I HAVE BEEN Cratered");
		[self setAutoresizingMask:NSViewWidthSizable];
		
		NSRect aFrame;
		aFrame.origin = (NSPoint){ 10, 15};
		aFrame.size = (NSSize){70,30};
		voteButton = [[NSButton alloc] initWithFrame:aFrame];
		[voteButton setButtonType:NSMomentaryLightButton];
		[voteButton setBezelStyle:NSRoundedBezelStyle];
		[voteButton setTitle:@"Vote"];
		[voteButton setAction:@selector(voteButtonPress:)];
		[voteButton setTarget:controller];
		
		aFrame.origin = (NSPoint){ frame.size.width - 80, 15};
		aFrame.size = (NSSize){70,30};
		vetoButton = [[NSButton alloc] initWithFrame:aFrame];
		[vetoButton setButtonType:NSMomentaryLightButton];
		[vetoButton setBezelStyle:NSRoundedBezelStyle];
		[vetoButton setTitle:@"Veto"];
		[vetoButton setAutoresizingMask:NSViewMaxXMargin];
		[vetoButton setAction:@selector(vetoButtonPress:)];
		[vetoButton setTarget:controller];

		aFrame.origin = (NSPoint){ 80, 15};
		aFrame.size = (NSSize){140,25};		
		nameField = [[NSTextField alloc] initWithFrame:aFrame];
		[nameField setBordered:NO];
		[nameField setEditable:NO];
		[nameField setDrawsBackground:NO];
		[nameField setStringValue:@"NO NAME YET"];
		
		[self addSubview:nameField];
		[self addSubview:voteButton];
		[self addSubview:vetoButton];
		
	}
    return self;
}

- (void)setRepresentedRestaurant:(NNRestaurant *)restaurant
{
	if (representedRestaurant == restaurant){
		return;
	}
	[representedRestaurant release];
	representedRestaurant = [restaurant retain];
	
	[representedRestaurant addObserver:self
							forKeyPath:@"votes"
							   options:0
							   context:NULL];
	[self updateState];
}

- (NNRestaurant *)representedRestaurant
{
	return representedRestaurant;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	NSLog(@"KEYPATH CHANGE");
    if ([keyPath isEqual:@"votes"]) {
		[self updateState];
    }else{
		[super observeValueForKeyPath:keyPath
							 ofObject:object
							   change:change
							  context:context];
	}
}

- (void)updateState
{
	if (!representedRestaurant){
		NSLog(@"NOTHING TO UPDATE WITH?");
	}
	
	[nameField setStringValue:[representedRestaurant name]];
	int votes = [representedRestaurant votes];
	if (votes <= -1){
		[vetoButton setEnabled:NO];
		[voteButton setEnabled:NO];
		[nameField setTextColor:[NSColor grayColor]];
	}else {
		[vetoButton setEnabled:YES];
		[voteButton setEnabled:YES];
		[nameField setTextColor:[NSColor blackColor]];
	}
	if ([representedRestaurant hasYourVote]){
		[voteButton setEnabled:NO];
	}
}

@end


@implementation NNPersonView

- (id)initWithFrame:(NSRect)frame andController:(id)controller{
    self = [super initWithFrame:frame];
    if (self) {
		NSLog(@"I HAVE BEEN Cratered");
		[self setAutoresizingMask:NSViewWidthSizable];
		
		NSRect aFrame;
		
		aFrame.origin = (NSPoint){ 30, 15};
		aFrame.size = (NSSize){140,25};		
		nameField = [[NSTextField alloc] initWithFrame:aFrame];
		[nameField setBordered:NO];
		[nameField setEditable:NO];
		[nameField setDrawsBackground:NO];
		[nameField setStringValue:@"NO NAME YET"];
		
		[self addSubview:nameField];
		
	}
    return self;
}

- (void)setRepresentedPerson:(NNPerson *)person
{
	if (representedPerson == person){
		return;
	}
	[representedPerson release];
	representedPerson = [person retain];
	
	[representedPerson addObserver:self
							forKeyPath:@"state"
							   options:0
							   context:NULL];
	[self updateState];
}

- (NNPerson *)representedPerson
{
	return representedPerson;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	NSLog(@"KEYPATH CHANGE");
    if ([keyPath isEqual:@"state"]) {
		[self updateState];
    }else{
		[super observeValueForKeyPath:keyPath
							 ofObject:object
							   change:change
							  context:context];
	}
}

- (void)updateState
{
	if (!representedPerson){
		NSLog(@"NOTHING TO UPDATE WITH?");
	}
	
	[nameField setStringValue:[representedPerson name]];
	int state = [representedPerson state];
	if (state == NNNotComingState){
		[nameField setTextColor:[NSColor grayColor]];
	}
	if (state == NNComingState) {
		[nameField setTextColor:[NSColor greenColor]];
	}
	if (state == NNUndefinedState){
		[nameField setTextColor:[NSColor blackColor]];
	}
	NSLog(@"Person %@ has state %d",[representedPerson name],state);
}

@end