//
//  XJOutLineLabel.m
//  DCGame
//
//  Created by GeekSprite on 2017/3/15.
//  Copyright © 2017年 Sawadee. All rights reserved.
//

#import "XJOutLineLabel.h"

@implementation XJOutLineLabel

- (void)drawTextInRect:(CGRect)rect{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, self.strokeWidth);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = self.strokenColor;
    [super drawTextInRect:rect];
    self.textColor = self.fillColor;
    CGContextSetTextDrawingMode(c, kCGTextFill);
    [super drawTextInRect:rect];
}

@end
