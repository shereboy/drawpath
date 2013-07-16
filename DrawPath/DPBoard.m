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

@implementation DPBoard

@synthesize colorArray;
@synthesize initialBricksArray;
@synthesize currentBricksArray;
@synthesize dropBricksArray;
@synthesize dropBrickCount;
@synthesize brickTimer;
@synthesize parentView;
@synthesize brickWidth;
@synthesize brickHeight;
@synthesize queueIndex;
@synthesize counts;


-(id)init
{
  if (self = [super init])
  {
    self.queueIndex = 1;
    self.initialBricksArray = [[NSMutableArray alloc] init];
    self.currentBricksArray = [[NSMutableArray alloc] init];
    self.dropBricksArray = [[NSMutableArray alloc] init];
    self.additionBricksArray = [[NSMutableArray alloc]init];
    self.dropBrickCount = [[NSMutableArray alloc]init];
    
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
        [self.currentBricksArray addObject:brick];
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
  label.text = [NSString stringWithFormat:@"%d%@%d", rowNumber, @" - ",colNumber];
  
  [thisBrick addSubview:label];
  
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
  CGColorRef colorRef = button.backgroundColor.CGColor;
  NSString *boxColor = [CIColor colorWithCGColor:colorRef].stringRepresentation;
}


-(void) addToDropArray: (id) sender
{
  DPBrick *brick = (DPBrick *) sender;
  
  
  
  //add to top
  
  
  DPBrick* thiBrick =[DPBrick alloc];
  //NSLog(@"%@%d%@%d", @"col: ",brick.colNumber, @" count: ",[[self.dropBrickCount objectAtIndex:brick.colNumber] intValue] );
  [self.dropBrickCount replaceObjectAtIndex:brick.colNumber withObject:[NSNumber numberWithInt:[[self.dropBrickCount objectAtIndex:brick.colNumber] intValue]+1]];
  
  thiBrick =[[DPBrick alloc]initWithFrame:CGRectMake(brick.frame.origin.x,FRAME_TOP_PADDING-brickHeight*[[self.dropBrickCount objectAtIndex:brick.colNumber] intValue],50,50)];
  NSUInteger randomIndex = arc4random() % [self.colorArray count];
  thiBrick.backgroundColor = colorArray[randomIndex];
  //thiBrick.backgroundColor = [UIColor purpleColor];
  thiBrick.assignedColor = colorArray[randomIndex];
  thiBrick.colNumber = brick.colNumber;
  thiBrick.rowNumber = -[[self.dropBrickCount objectAtIndex:brick.colNumber] intValue];
  thiBrick.oldRowNumber = thiBrick.rowNumber;
  thiBrick.queueId = self.queueIndex++;
  

//  NSLog(@"%@%d%@%d", @"row: ",thiBrick.rowNumber, @" col: ",thiBrick.colNumber);
  
  [self addSubview:thiBrick];
  
  //add to top
  
  
  for(DPBrick *tmpBrick in self.subviews)
    if([tmpBrick isKindOfClass:[DPBrick class]])
    {
      if (tmpBrick.oldRowNumber<0)
//        NSLog(@"%@%d%@%d", @"checking to drop row: ",tmpBrick.rowNumber, @" col: ",tmpBrick.colNumber);
      
              NSLog(@"%@%d%@%d%@%d", @"checking to drop row: ",tmpBrick.rowNumber, @" : ",tmpBrick.colNumber, @" : ", brick.colNumber);
      if(tmpBrick.colNumber == brick.colNumber && tmpBrick.oldRowNumber < brick.oldRowNumber)
      {
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
                  NSLog(@"%@%d%@%d", @"Adding to drop row: ",tmpDropBrick.brickToDrop.rowNumber, @" col: ",tmpDropBrick.brickToDrop.colNumber);
          if(tmpDropBrick.brickToDrop.oldRowNumber>=0)
          {
            tmpDropBrick.stepsToDrop = 1;
            tmpDropBrick.brickToDrop.rowNumber++;
          }
          else
          {
            tmpDropBrick.stepsToDrop = -tmpDropBrick.brickToDrop.rowNumber;
            tmpDropBrick.brickToDrop.rowNumber+=tmpDropBrick.stepsToDrop-1;
            //tmpDropBrick.brickToDrop.oldRowNumber = tmpDropBrick.brickToDrop.rowNumber;
          }
          
          [self.dropBricksArray addObject: tmpDropBrick];
        }
      }
 // NSLog(@"%@%d%@%d", @"Skipping : ",tmpBrick.rowNumber, @" col: ",tmpBrick.colNumber);
    }
}



-(void) dropBricks
{
  [self resetDropCounts];
  //return;
  for(DPDropBrick* dropBrick in self.dropBricksArray)
  {
    CGPoint center = CGPointMake(dropBrick.brickToDrop.center.x,dropBrick.brickToDrop.center.y+BOX_HEIGHT*dropBrick.stepsToDrop);
    
    [UIView animateWithDuration: 0.5
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
  
}


@end




