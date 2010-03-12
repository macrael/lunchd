//
//  NNLunchControl.m
//  lunchd
//
//  Created by MacRae Linton on 3/9/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import "NNLunchControl.h"


@implementation NNLunchControl

- (id) init
{
	self = [super init];
	if (self){
		NSLog(@"INININIT");
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSArray *defaultResturants = [NSArray arrayWithObjects:@"Cafe Macs",@"Wahoo's",@"In'n'out",
									 @"Thai Pepper",@"Rio",@"BBQ",nil];
		NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys: defaultResturants,@"restaurants",nil];
		
		[defaults registerDefaults:appDefaults];
		
		people = [[NSMutableArray alloc] init];
		restaurants = [[NSMutableArray alloc] init];
		
		NSArray *resturantNames = [defaults arrayForKey:@"restaurants"];
		for (NSString *rName in resturantNames){
			NNRestaurant *r = [[NNRestaurant alloc] initWithName:rName];
			[restaurants addObject:r];
		}
		
	}
	return self;
}

- (void) dealloc
{
	[people release];
	[restaurants release];
	[super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	NSLog(@"GAMEON");
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults stringForKey:@"name"]  == NULL){
		//setup getting the name. 
		NSLog(@"NO NAME YET, SETTING TO MACRAE");
		[defaults setObject:@"MacRae" forKey:@"name"];
	}
	
	//This may need to be synced. Otherwise you could restart the app and use 
	//your veto over and over again.
	usedVeto = NO;
	
	//probably want to set up a timer that will keep checking in? 
	//or are they all pushing info out. 
}

// ------- CONTROL FUNCTIONS
// TOP LEVEL:
- (IBAction)imIn:(id)sender
{
	NSLog(@"YOU ARE IN");
}
- (IBAction)imOut:(id)sender
{
	NSLog(@"YOU ARE OUT");
}


//Add resturant goes to top of list. 
//When a resturant is chosen, it gets pushed to the bottom. 
- (IBAction)restaurantClickAction:(id)sender
{
	NSLog(@"THERE IS THE CLICK(T)?");
}

- (void)voteForRestaurant:(NNRestaurant *)restaurant
{
	if ([restaurant state] == NNVetoedState){
		NSLog(@"ERROR: Should not be able to vote for a vetoed restraunt.");
		return;
	}
	[restaurant setState:NNVotedForState];
	[restaurants removeObject:restaurant];
	[restaurants insertObject:restaurant atIndex:0];
}

- (void)vetoRestaurant:(NNRestaurant *)restaurant
{
	if (usedVeto){
		NSLog(@"YOU CAN'T VETO TWICE!");
		//put in good error.
		return;
	}
	[restaurant setState:NNVetoedState];
	[restaurants removeObject:restaurant];
	[restaurants addObject:restaurant];
	usedVeto = YES;
}



- (void)checkInWithAll:(id)sender
{
	NSLog(@"CHEKING IN");
}

// ------- TABLE VIEW DATA SOURCE

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	if (aTableView == restaurantsTable){
		return [restaurants count];
	}
	else if (aTableView == peopleTable){
		return [people count];
	}
	NSLog(@"WHAT??? BAD TABLE %@",aTableView);
	return -1;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	if (aTableView == restaurantsTable){
		if ([[aTableColumn identifier] isEqualToString:@"nameCol"]){
			return [[restaurants objectAtIndex:rowIndex]name];
		}
		
		if ([[aTableColumn identifier] isEqualToString:@"buttonCol"]){
			return [[restaurants objectAtIndex:rowIndex] stateImage];
		}
	}else if (aTableView == peopleTable) {
		return nil;	
	}
	NSLog(@"WHAT? BadCOl");
	return nil;
}


// ---------- TABLE VIEW DELEGATE



@end
