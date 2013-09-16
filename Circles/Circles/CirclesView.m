//
//  CirclesView.m
//  Circles
//
//  Created by VisiKard MacBook Pro on 9/16/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import "CirclesView.h"

#define ARC4RANDOM_MAX 0x100000000
#define RANDOM_FLOAT (double)arc4random() / ARC4RANDOM_MAX * 1.0 + 0.0


@implementation CirclesView
{
    NSMutableSet *centersSet;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        centersSet = [NSMutableSet new];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    int WIDTH_VIEW = rect.size.width;
    int HEIGHT_VIEW = rect.size.height;
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i < 10; i++) {
        CGContextSaveGState(context);
        
        
        int radius;
        radius = (arc4random() % 21) + 20;
        int centerX = arc4random() % (WIDTH_VIEW - 2 *radius) + radius;
        int centerY = arc4random() % (HEIGHT_VIEW - 2*radius) + radius;
        
        CGPoint center = CGPointMake(centerX, centerY);
        
        while ([centersSet containsObject:[NSValue valueWithCGPoint:center]]) {
            center.x = arc4random() % (WIDTH_VIEW - 2 *radius) + radius;
            center.y = arc4random() % (HEIGHT_VIEW - 2*radius) + radius;
        }
        [centersSet addObject:[NSValue valueWithCGPoint:center]];
        
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
        
        CGContextSetLineWidth(context, 1.0f);
        
        // Gradient
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat components[8] = {
            RANDOM_FLOAT, RANDOM_FLOAT, RANDOM_FLOAT, 1.0, // start color
            RANDOM_FLOAT, RANDOM_FLOAT, RANDOM_FLOAT, 1.0 // end color
        };
        
        int numberLocations = 2;
        CGGradientRef circleGradient = CGGradientCreateWithColorComponents(colorSpace, components, NULL, numberLocations);
        
        CGPoint startPoint = CGPointMake(center.x - radius, center.y);
        CGPoint endPonint = CGPointMake(center.x + radius, center.y);
        
        [circlePath addClip];
        CGContextDrawLinearGradient(context, circleGradient, startPoint, endPonint, 0);
        [circlePath stroke];
        
        // Release
        CGColorSpaceRelease(colorSpace);
        CGGradientRelease(circleGradient);
        
        CGContextRestoreGState(context);
    }
}


@end
