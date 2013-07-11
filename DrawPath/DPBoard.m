//
//  DPBoard.m
//  DrawPath
//
//  Created by Tolga Seremet on 7/11/13.
//  Copyright (c) 2013 Tolga Seremet. All rights reserved.
//

#import "DPBoard.h"
#import "Constants.h"
#import "DPBrick.h"

@implementation DPBoard

@synthesize colorArray;
@synthesize initialBricksArray;



-(id)init
{
  if (self = [super init])
  {
   self.initialBricksArray = [[NSMutableArray alloc] init];
   self.colorArray =[NSArray arrayWithObjects:[UIColor redColor],[UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor orangeColor], nil];
  }
  return self;
}

-(void) drawBoard

{
  
  for (int i = 0; i<ROW_COUNT ; i++) {
    for (int j = 0; j<COL_COUNT; j++)
    {
      if (j !=0 && j%COL_COUNT == 0) continue;
      else
      {
        NSUInteger randomIndex = arc4random() % [self.colorArray count];
        DPBrick *brick = [DPBrick alloc];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
          brick.frameX=(j*IPAD_BOX_WIDTH+FRAME_LEFT_PADDING);
          brick.frameY=(i*IPAD_BOX_HEIGHT+FRAME_TOP_PADDING);
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
          brick.frameX=(j*BOX_WIDTH+FRAME_LEFT_PADDING);
          brick.frameY=(i*BOX_HEIGHT+FRAME_TOP_PADDING);
        }
        brick.assignedColor = colorArray[randomIndex];
        brick.rowNumber = i;
        brick.colNumber = j;
        [self.initialBricksArray addObject:brick];
      }
    }
  }
}


@end
