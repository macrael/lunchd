//
//  NNLunchControl.h
//  lunchd
//
//  Created by MacRae Linton on 3/9/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NNRestaurant.h"
#import "NNPerson.h"


@interface NNLunchControl : NSObject {
	IBOutlet NSTableView *peopleTable;
	IBOutlet NSTableView *restaurantsTable;
	
	NSMutableArray *people;
	NSMutableArray *restaurants;
	NSString *myName;
}

- (void)addRestaurant:(NSString *)newRestaurant;

- (void)imIn:(id)sender;
- (void)imOut:(id)sender;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;

- (void)checkInWithAll:(id)sender;

//- (NSMenu *)applicationDockMenu:(NSApplication *)sender;

@end
