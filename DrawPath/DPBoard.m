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
@synthesize brickTimer;
@synthesize parentView;


-(id)init
{
  if (self = [super init])
  {
   self.initialBricksArray = [[NSMutableArray alloc] init];
   self.colorArray =[NSArray arrayWithObjects:[UIColor redColor],[UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor orangeColor], nil];
  }
  return self;
}

-(void) drawBoard:(id)parent

{
  parentView = (UIView*)parent;
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
  self.brickTimer = [NSTimer scheduledTimerWithTimeInterval:ANIMATION_DURATION
                                                target:self
                                              selector:@selector(drawRectangleFromStack:)
                                              userInfo:nil
                                               repeats:YES
                     ];
  
}

-(void) drawRectangleFromStack :(id) sender
{
  NSLog(@"TIMER WORKING");
  if ([self.initialBricksArray count] > 0)
  {
    DPBrick *brick = [self.initialBricksArray objectAtIndex:[self.initialBricksArray count]-1];
    [self drawRectangle:brick.frameX:brick.frameY :brick.assignedColor:brick.rowNumber:brick.colNumber];
    
    
    [self.initialBricksArray removeLastObject];
  }
  else
  {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Oynamaya Hazır mısın?" delegate:nil cancelButtonTitle:@"Başla" otherButtonTitles: nil];
    [alert show];
    
    [self.brickTimer invalidate];
    self.brickTimer = nil;
  }
}

-(void) drawRectangle:(int)x
                     :(int)y
                     :(UIColor*)color
                     :(int)rowNumber
                     :(int)colNumber
{
  
  DPBrick* thisBrick =[DPBrick alloc];
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    thisBrick =[[DPBrick alloc]initWithFrame:CGRectMake(x,y,IPAD_BOX_WIDTH,IPAD_BOX_HEIGHT)];
  }
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    thisBrick =[[DPBrick alloc]initWithFrame:CGRectMake(x,y,BOX_WIDTH,BOX_HEIGHT)];
  }
  
  
  thisBrick.colNumber = colNumber;
  thisBrick.rowNumber = rowNumber;
  
  thisBrick.backgroundColor = color;
  thisBrick.assignedColor = color;
  thisBrick.alpha = 0;
  
  CGPoint center = CGPointMake(thisBrick.center.x,thisBrick.center.y-ANIMATION_DISTANCE);
  
  thisBrick.center = center;
  
  
  
  center = CGPointMake(thisBrick.center.x,thisBrick.center.y+ANIMATION_DISTANCE);
  
  [UIView animateWithDuration: ANIMATION_DURATION
                   animations: ^{
                     thisBrick.alpha = 1;
                     thisBrick.center = center;
                   }
                   completion: ^(BOOL finished) {
                     
                     //[self.car removeFromSuperview];
                   }
   ];
  [parentView addSubview:thisBrick];
}

+(void)hoverBrick:(id)sender{
  
  UIButton *button = (UIButton *) sender;
  button.backgroundColor= [UIColor blackColor];
  CGColorRef colorRef = button.backgroundColor.CGColor;
  NSString *boxColor = [CIColor colorWithCGColor:colorRef].stringRepresentation;
  NSLog(@"%@", boxColor);
  
}


@end
