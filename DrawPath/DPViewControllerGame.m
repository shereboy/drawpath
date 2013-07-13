//
//  DPViewControllerGame.m
//  DrawPath
//
//  Created by Tolga Seremet on 7/11/13.
//  Copyright (c) 2013 Tolga Seremet. All rights reserved.
//

#import "DPViewControllerGame.h"

#import "Constants.h"
#import "DPBrick.h"
#import "DPMove.h"
#import "DPBoard.h"

@interface DPViewControllerGame ()

@end

@implementation DPViewControllerGame

@synthesize BrickStack;
@synthesize MainBoard;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.BrickStack = [[NSMutableArray alloc] init];
  
}

- (void) viewDidAppear:(BOOL)animated
{
  MainBoard = [DPBoard alloc];
  [MainBoard init];
  [self.view addSubview:MainBoard];
  [MainBoard drawBoard:self.view] ;
  
  // [self drawBoard];
}

#pragma mark CUSTOM METHODS

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchLocation = [touch locationInView:MainBoard];
  
  //NSLog( @"%@%f%@%f", @"Touch Oldu: ", touchLocation.x, @" - ", touchLocation.y );
  
  for(DPBrick *brick in MainBoard.subviews)
    if(CGRectContainsPoint(brick.frame,touchLocation) &&
       brick.backgroundColor != [UIColor blackColor] &&
       ![self.BrickStack containsObject:brick] &&
       [brick isKindOfClass:[DPBrick class]]
       )
    {
      if([self.BrickStack count]>0)
      {
        DPBrick *tmpBrick = [self.BrickStack objectAtIndex:[self.BrickStack count]-1];
        
        if([DPMove isLegalMove:tmpBrick :brick])
        {
          
          [self.BrickStack addObject:brick];
          [DPBoard hoverBrick:brick];
        }
      }
      else
      {
        [self.BrickStack addObject:brick];
        [DPBoard hoverBrick:brick];
      }
    }
  
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  if([self.BrickStack count]>2)
  {
    for(DPBrick *brick in self.BrickStack)
    {
      [self.MainBoard addToDropArray2:brick];
      //  brick.backgroundColor = brick.assignedColor;
      [brick removeFromSuperview];
    }
  }
  else
    for(DPBrick *brick in self.BrickStack)
    {
      brick.backgroundColor = brick.assignedColor;
    }
  
  [self.BrickStack removeAllObjects];
}

@end

