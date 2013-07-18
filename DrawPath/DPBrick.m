//
//  DPBrick.m
//  DrawPath
//
//  Created by Tolga Seremet on 7/11/13.
//  Copyright (c) 2013 Tolga Seremet. All rights reserved.
//

#import "DPBrick.h"
#import "Constants.h"

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
@synthesize brickImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        }
    return self;
}

-(void)setImage:(NSString*)imageName
{
  self.brickImage = [UIImage imageNamed:imageName];
  UIImageView *imgView = [[UIImageView alloc] initWithImage:self.brickImage];
  imgView.frame = CGRectMake(0,0,BOX_WIDTH,BOX_HEIGHT);
  [self addSubview:imgView];
}


@end
