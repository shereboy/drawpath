//
//  DPBrick.m
//  DrawPath
//
//  Created by Tolga Seremet on 7/11/13.
//  Copyright (c) 2013 Tolga Seremet. All rights reserved.
//

#import "DPBrick.h"

@implementation DPBrick

@synthesize colNumber;
@synthesize rowNumber;
@synthesize oldColNumber;
@synthesize oldRowNumber;
@synthesize assignedColor;
@synthesize frameWidth;
@synthesize frameHeight;
@synthesize frameX;
@synthesize frameY;
@synthesize queueId;
@synthesize isNewlyAdded;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


@end
