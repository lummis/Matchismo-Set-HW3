//
//  SetCardView.m
//  Matchismo
//
//  Created by Marko Kuljanski on 2/13/13.
//  Copyright (c) 2013 Marko Kuljanski. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView()
@property (nonatomic, strong) NSArray *colors;
@end

@implementation SetCardView

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

+ (NSArray *) colors {
    return [NSArray arrayWithObjects:[UIColor redColor], [UIColor purpleColor], [UIColor greenColor], nil];
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:12.0];
    [roundedRect addClip]; //prevents filling corners, i.e. sharp corners not included in roundedRect
    
    if (self.faceUp) {
        [[UIColor lightGrayColor] setFill];
    } else {
        [[UIColor whiteColor] setFill];
    }
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    [self drawCards];
}

#define SYMBOL_SCALE_X 2
#define SYMBOL_SCALE_Y 4.5
#define SIZE_OF_OVAL_CURVE 10
#define DIAMOND_ARM_SCALE 0.8
#define Y_OFFSET_FOR_NUMBER_2 2.7
#define Y_OFFSET_FOR_NUMBER_3 1.7

- (void)drawCards {
    if (self.symbol == 0) [self drawDiamond];
    if (self.symbol == 1) [self drawOval];
    if (self.symbol == 2) [self drawSquiggle];
}

    //lummis version of drawSquiggle replacing Kuljanski's version
    //see file "squiggle geometry.png" for a graphical explanation of the variable names in this method
- (void) drawSquiggle {    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat sideMargin = 10.;   //distance from left or right edge of the view to the squiggle
    CGFloat alpha = M_PI_4; //   pi/4 = 45 degrees
    CGFloat thickness = 0.15 * h;   //thickness of the squiggle
    CGFloat delta = 0.02 * h;  //ad hoc adjustment - tilts the shape down on the left & up on the right
    CGPoint p1 = CGPointMake(sideMargin, h / 2 + delta);
    CGPoint p3 = CGPointMake(w - sideMargin, h / 2 - delta);
    CGPoint p2 = CGPointMake( p3.x - thickness * cosf(alpha), p3.y - thickness * sinf(alpha) );
    CGPoint p4 = CGPointMake( p1.x + thickness * cosf(M_PI_2 - alpha), p1.y + thickness * sinf(M_PI_2 - alpha) );
    CGFloat l1 = w / 4; //distance from p1 to control point cp1. started with arbitrary value then adjusted it
    CGFloat l2 = w / 4;
    CGFloat l3 = w / 4;
    CGFloat l4 = w / 4;
    CGPoint cp1 = CGPointMake(p1.x + l1 * cosf(alpha), p1.y - l1 * sinf(alpha));
    CGPoint cp2 = CGPointMake(p2.x - l2 * cosf(alpha), p2.y + l2 * sinf(alpha));
    CGPoint cp3 = CGPointMake(p3.x - l3 * cosf(alpha), p3.y + l3 * sinf(alpha));
    CGPoint cp4 = CGPointMake(p4.x + l4 * cosf(alpha), p4.y - l4 * sinf(alpha));
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:p1];
    [path addCurveToPoint:p2 controlPoint1:cp1 controlPoint2:cp2];
    [path addLineToPoint:p3];
    [path addCurveToPoint:p4 controlPoint1:cp3 controlPoint2:cp4];
    [path addLineToPoint:p1];
    
    [self drawAttributesFor:path];
}

- (void)drawOval    //Kuljanski
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint start = CGPointMake(middle.x + (middle.x / SYMBOL_SCALE_X), middle.y - (middle.y / SYMBOL_SCALE_Y));
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:start];
    [path addQuadCurveToPoint:CGPointMake(start.x, middle.y + (middle.y / SYMBOL_SCALE_Y))
                 controlPoint:CGPointMake(start.x + SIZE_OF_OVAL_CURVE, middle.y)];
    [path addLineToPoint:CGPointMake(middle.x - (middle.x / SYMBOL_SCALE_X), middle.y + (middle.y / SYMBOL_SCALE_Y))];
    [path addQuadCurveToPoint:CGPointMake(middle.x - (middle.x / SYMBOL_SCALE_X), start.y)
                 controlPoint:CGPointMake(middle.x - (middle.x / SYMBOL_SCALE_X) - SIZE_OF_OVAL_CURVE, middle.y)];
    [path closePath];
    
    [self drawAttributesFor:path];
}

- (void)drawDiamond //Kuljanski
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint start = CGPointMake(middle.x, middle.y - (middle.y / SYMBOL_SCALE_Y));
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:start];
    [path addLineToPoint:CGPointMake(middle.x + (middle.x / (SYMBOL_SCALE_X * DIAMOND_ARM_SCALE)), middle.y)];
    [path addLineToPoint:CGPointMake(middle.x, middle.y + (middle.y / SYMBOL_SCALE_Y))];
    [path addLineToPoint:CGPointMake(middle.x - (middle.x / (SYMBOL_SCALE_X * DIAMOND_ARM_SCALE)), middle.y)];
    [path closePath];
    
    [self drawAttributesFor:path];
}

- (void)drawAttributesFor:(UIBezierPath *)path  //Kuljanski
{
    path.lineWidth = 3;
    [ SetCardView.colors[self.color] setStroke ];
    
//    [[UIColor valueForKey:self.color] setStroke];
    
    switch (self.shading) {
        case 1:
            [[ SetCardView.colors[self.color] colorWithAlphaComponent:0.3] setFill];
            break;
        case 2:
            [[ SetCardView.colors[self.color] colorWithAlphaComponent:1.0] setFill];
            break;
        case 0:
        default:
            break;
    }
    
    if (self.number == 1) {
        CGFloat yOffset = self.bounds.size.height/2/Y_OFFSET_FOR_NUMBER_2;
        
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -yOffset);
        [path applyTransform:transform];
        [path stroke];
        [path fill];
        
        transform = CGAffineTransformMakeTranslation(0, yOffset * 2);
        [path applyTransform:transform];
        [path stroke];
        [path fill];
        
    } else if (self.number == 2) {
        CGFloat yOffset = self.bounds.size.height/2/Y_OFFSET_FOR_NUMBER_3;
        
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -yOffset);
        [path applyTransform:transform];
        [path stroke];
        [path fill];
        
        transform = CGAffineTransformMakeTranslation(0, yOffset);
        [path applyTransform:transform];
        [path stroke];
        [path fill];
        
        transform = CGAffineTransformMakeTranslation(0, yOffset);
        [path applyTransform:transform];
        [path stroke];
        [path fill];
        
    } else {
        [path stroke];
        [path fill];
    }
}

@end
