//
//  NNCustomCells.h
//  lunchd
//
//  Created by MacRae Linton on 3/24/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NNRestaurant.h"
#import "NNPerson.h"

@interface NNRestaurantCell : NSCell {
	int downbutton; //0 is none, -1 for veto, 1 for vote.
}


@end


@interface NNPersonCell : NSCell {
	
}

@end