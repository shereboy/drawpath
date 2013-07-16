//
//  DPBoard.h
//  DrawPath
//
//  Created by Tolga Seremet on 7/11/13.
//  Copyright (c) 2013 Tolga Seremet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPBrick.h"
#import "Constants.h"

@interface DPBoard : UIView

@property (strong,nonatomic) NSArray *colorArray ;
@property (strong, nonatomic) NSMutableArray *initialBricksArray;
@property (strong, nonatomic) NSMutableArray *dropBricksArray;
@property (strong, nonatomic) NSMutableArray *dropBrickCount;
@property (strong, nonatomic) NSMutableArray *pathBrickStack;
@property (strong, nonatomic) NSTimer *brickTimer;
@property(strong,nonatomic) UIView *parentView;
@property int brickWidth;
@property int brickHeight;
@property int queueIndex;
@property (strong, nonatomic) NSArray *counts;

-(void) drawBoard:(id)parent;
+(void) hoverBrick:(id)sender;
-(void)addToDropArray :(DPBrick*) brick;
-(void)dropBricks;
-(void) refreshBoard:(NSMutableArray*)brickStack;
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
@end
