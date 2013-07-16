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
#import "DPDropBrick.h"
#import "DPMove.h"

@implementation DPBoard

@synthesize colorArray;
@synthesize initialBricksArray;
@synthesize dropBricksArray;
@synthesize dropBrickCount;
@synthesize brickTimer;
@synthesize parentView;
@synthesize brickWidth;
@synthesize brickHeight;
@synthesize queueIndex;
@synthesize counts;
@synthesize pathBrickStack;


-(id)init
{
  if (self = [super initWithFrame:CGRectMake(FRAME_LEFT_PADDING,FRAME_TOP_PADDING,COL_COUNT*BOX_HEIGHT,ROW_COUNT*BOX_WIDTH)])
  {
    self.queueIndex = 1;
    self.initialBricksArray = [[NSMutableArray alloc] init];
    self.dropBricksArray = [[NSMutableArray alloc] init];
    self.dropBrickCount = [[NSMutableArray alloc]init];
    self.pathBrickStack = [[NSMutableArray alloc] init];
    
    
    for(short i =0; i<COL_COUNT; i++)
      [self.dropBrickCount addObject:[NSNumber numberWithInt:0]];
    
    self.colorArray =[NSArray arrayWithObjects:[UIColor redColor],[UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor orangeColor], nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
      self.brickWidth = BOX_WIDTH;
      self.brickHeight = BOX_HEIGHT;
    }
    else
    {
      self.brickWidth = IPAD_BOX_WIDTH;
      self.brickHeight = IPAD_BOX_HEIGHT;
    }
    
  }
  return self;
}

-(void) resetDropCounts
{
  for(short i =0; i<COL_COUNT; i++)
    [self.dropBrickCount replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
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
        DPBrick *brick = [[DPBrick alloc]init];
        
        brick.frameX=(j*self.brickWidth+FRAME_LEFT_PADDING);
        brick.frameY=(i*self.brickHeight+FRAME_TOP_PADDING);
        
        brick.assignedColor = colorArray[randomIndex];
        brick.rowNumber = i;
        brick.colNumber = j;
        brick.queueId = self.queueIndex++;
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
    [self drawRectangle:brick.frameX:brick.frameY :brick.assignedColor:brick.rowNumber:brick.colNumber:brick.queueId:YES];
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
                     :(int) queueId
                     :(BOOL)animated
{
  
  DPBrick* thisBrick =[DPBrick alloc];
  
  thisBrick =[[DPBrick alloc]initWithFrame:CGRectMake(x,y,self.brickWidth,self.brickHeight)];
  
  thisBrick.colNumber = colNumber;
  thisBrick.rowNumber = rowNumber;
  thisBrick.oldRowNumber = rowNumber;
  
  thisBrick.backgroundColor = color;
  thisBrick.assignedColor = color;
  thisBrick.queueId = queueId;
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,40,40)];
  label.text = [NSString stringWithFormat:@"%d%@%d", rowNumber, @" : ",colNumber];
  
  if(animated)
  {
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
                     }
     ];
  }
  
  [self addSubview:thisBrick];
}

+(void)hoverBrick:(id)sender{
  
  UIButton *button = (UIButton *) sender;
  button.backgroundColor= [UIColor blackColor];
}


-(void) addToDropArray: (id) sender
{
  DPBrick *brick = (DPBrick *) sender;
  
  for(DPBrick *tmpBrick in self.subviews)
    if([tmpBrick isKindOfClass:[DPBrick class]])
    {
      if(tmpBrick.colNumber == brick.colNumber && tmpBrick.frame.origin.y < brick.frame.origin.y)
      {
        if(tmpBrick.rowNumber<0)
          NSLog(@"%@%d%@%d%@%d",@"adding", tmpBrick.rowNumber, @":" ,tmpBrick.colNumber, @":",tmpBrick.queueId);
        BOOL isIncremented = NO;
        for(DPDropBrick* dropBrick in self.dropBricksArray)
        {
          if(tmpBrick.queueId == dropBrick.brickToDrop.queueId)
          {
            dropBrick.stepsToDrop++;
            dropBrick.brickToDrop.rowNumber++;
            isIncremented = YES;
            
          }
        }
        if(!isIncremented)
        {
          DPDropBrick* tmpDropBrick = [[DPDropBrick alloc]init];
          tmpDropBrick.brickToDrop = tmpBrick;
          tmpDropBrick.stepsToDrop = 1;
          tmpDropBrick.brickToDrop.rowNumber++;
          
          [self.dropBricksArray addObject: tmpDropBrick];
        }
      }
    }
}

-(void) refreshBoard:(NSMutableArray *)brickStack
{
  for(DPBrick *brick in brickStack )
  {
    [self.dropBrickCount replaceObjectAtIndex:brick.colNumber withObject:[NSNumber numberWithInt:[[self.dropBrickCount objectAtIndex:brick.colNumber] intValue]+1]];
    NSUInteger randomIndex = arc4random() % [self.colorArray count];
    
    [self drawRectangle:
     brick.frame.origin.x  :
     FRAME_TOP_PADDING-brickHeight*[[self.dropBrickCount objectAtIndex:brick.colNumber] intValue] :
     colorArray[randomIndex] :
     -[[self.dropBrickCount objectAtIndex:brick.colNumber] intValue] :
     brick.colNumber :
     self.queueIndex++:
     false];  //add to top
  }
  
  for(DPBrick *brick in brickStack)
  {
    [self addToDropArray:brick];
  }
  [self dropBricks];
}



-(void) dropBricks
{
  [self resetDropCounts];
  //return;
  for(DPDropBrick* dropBrick in self.dropBricksArray)
  {
    
    CGPoint center = CGPointMake(dropBrick.brickToDrop.center.x,dropBrick.brickToDrop.center.y+BOX_HEIGHT*dropBrick.stepsToDrop);
    NSLog(@"%@%d%@%d%@%d",@"row: ",dropBrick.brickToDrop.rowNumber, @" col: ", dropBrick.brickToDrop.colNumber, @" steps: ", dropBrick.stepsToDrop);
    [UIView animateWithDuration: 0.5
     // options:UIViewAnimationOptionCurveEaseIn;
                     animations: ^{
                       dropBrick.brickToDrop.center = center;
                       
                     }
                     completion: ^(BOOL finished) {
                     }
     ];
  }
  [self.dropBricksArray removeAllObjects];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  [super touchesMoved:touches withEvent:event];
  
  UITouch *touch = [touches anyObject];
  CGPoint touchLocation = [touch locationInView:self];
  
  for(DPBrick *brick in self.subviews)
    if(CGRectContainsPoint(brick.frame,touchLocation) &&
       brick.backgroundColor != [UIColor blackColor] &&
       ![self.pathBrickStack containsObject:brick] &&
       [brick isKindOfClass:[DPBrick class]]
       )
    {
      if([self.pathBrickStack count]>0)
      {
        DPBrick *tmpBrick = [self.pathBrickStack objectAtIndex:[self.pathBrickStack count]-1];
        
        if([DPMove isLegalMove:tmpBrick :brick])
        {
          
          [self.pathBrickStack addObject:brick];
          [DPBoard hoverBrick:brick];
        }
      }
      else
      {
        [self.pathBrickStack addObject:brick];
        [DPBoard hoverBrick:brick];
      }
    }
  
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  
  [super touchesEnded:touches withEvent:event];
  if([self.pathBrickStack count]>2)
  {
    for(DPBrick *brick in self.pathBrickStack)
    {
      //[self.MainBoard addToDropArray:brick];
      //  brick.backgroundColor = brick.assignedColor;
      [UIView animateWithDuration:0.2
                       animations: ^{
                         brick.alpha = 0.0;
                         
                       }
                       completion: ^(BOOL finished) {
                         [brick removeFromSuperview];
                       }
       ];
      
    }
    [self refreshBoard:self.pathBrickStack];
  }
  else
    for(DPBrick *brick in self.pathBrickStack)
    {
      brick.backgroundColor = brick.assignedColor;
    }
  
  [self.pathBrickStack removeAllObjects];
}


@end




