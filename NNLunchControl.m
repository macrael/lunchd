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
		NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:@"xxxNONE",@"name",
									 defaultResturants,@"restaurants",nil];
		
		[defaults registerDefaults:appDefaults];
		
		if ([[defaults stringForKey:@"name"] isEqualToString:@"xxxNONE"]){
			NSLog(@"NO NAME YET, SETTING TO MACRAE");
			[defaults setObject:@"MacRae" forKey:@"name"];
		}
		
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
	
	//probably want to set up a timer that will keep checking in? 
	//or are they all pushing info out. 
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
	NSLog(@"Looking for column %@",aTableColumn);
	if ([[aTableColumn identifier] isEqualToString:@"nameCol"]){
		return [[restaurants objectAtIndex:rowIndex]name];
	}
	
	if ([[aTableColumn identifier] isEqualToString:@"buttonCol"]){
		return nil;
	}
	NSLog(@"WHAT? BadCOl");
	return nil;
}

@end
