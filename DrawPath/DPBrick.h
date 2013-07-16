//
//  DPBrick.h
//  DrawPath
//
//  Created by Tolga Seremet on 7/11/13.
//  Copyright (c) 2013 Tolga Seremet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPBrick : UIView
@property (nonatomic) int rowNumber;
@property (nonatomic) int oldRowNumber;
@property (nonatomic) int colNumber;
@property (nonatomic) int oldColNumber;
@property (nonatomic) int frameWidth;
@property (nonatomic) int frameHeight;
@property (nonatomic) int frameX;
@property (nonatomic) int frameY;
@property (nonatomic) int queueId;
@property (strong,nonatomic) UIColor *assignedColor;

@end
