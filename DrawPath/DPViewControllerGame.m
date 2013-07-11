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
@synthesize InitialBrickStack;
@synthesize BrickTimer;
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
	// Do any additional setup after loading the view.
  
  self.BrickStack = [[NSMutableArray alloc] init];
  self.InitialBrickStack = [[NSMutableArray alloc] init];
  
}

- (void) viewDidAppear:(BOOL)animated
{
  MainBoard = [DPBoard alloc];
  [MainBoard init];
  [MainBoard drawBoard];
  
  BrickTimer = [NSTimer scheduledTimerWithTimeInterval:ANIMATION_DURATION
                                                target:self
                                              selector:@selector(drawRectangleFromStack:)
                                              userInfo:nil
                                               repeats:YES
    ];
 // [self drawBoard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CUSTOM METHODS


-(void) drawRectangleFromStack :(id) sender
{
  NSLog(@"TIMER WORKING");
  if ([MainBoard.initialBricksArray count] > 0)
  {
    DPBrick *brick = [MainBoard.initialBricksArray objectAtIndex:[MainBoard.initialBricksArray count]-1];
    [self drawRectangle:brick.frameX:brick.frameY :brick.assignedColor:brick.rowNumber:brick.colNumber];
    
    
    [MainBoard.initialBricksArray removeLastObject];
  }
  else
  {
    
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Oynamaya Hazır mısın?" delegate:nil cancelButtonTitle:@"Başla" otherButtonTitles: nil];
    [alert show];
    
    [self.BrickTimer invalidate];
    self.BrickTimer = nil;
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
  [self.view addSubview:thisBrick];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchLocation = [touch locationInView:self.view];
  
  NSLog( @"%@%f%@%f", @"Touch Oldu: ", touchLocation.x, @" - ", touchLocation.y );
  
  for(DPBrick *brick in self.view.subviews)
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
          [self rectClicked:brick];
        }
        else
        {
          NSLog(@"arkaplan farkli");
        }
      }
      else
      {
        [self.BrickStack addObject:brick];
        [self rectClicked:brick];
      }
    }
  
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  
  [self.BrickStack removeAllObjects];
  
  for(DPBrick *brick in self.view.subviews)
    if([brick isKindOfClass:[DPBrick class]])
      brick.backgroundColor = brick.assignedColor;
}

-(IBAction)rectClicked:(id)sender{
  
  UIButton *button = (UIButton *) sender;
  button.backgroundColor= [UIColor blackColor];
  CGColorRef colorRef = button.backgroundColor.CGColor;
  NSString *boxColor = [CIColor colorWithCGColor:colorRef].stringRepresentation;
  NSLog(@"%@", boxColor);
  
}

@end

