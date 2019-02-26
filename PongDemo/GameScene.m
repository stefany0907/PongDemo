//
//  GameScene.m
//  PongDemo
//
//  Created by Matt Chen on 2/24/19.
//  Copyright © 2019 Matt Chen. All rights reserved.
//

#import "GameScene.h"


@interface GameScene()
@property (strong, nonatomic) UITouch *leftPaddleMotivatingTouch;
@property (strong, nonatomic) UITouch *rightPaddleMotivatingTouch;

@end

@implementation GameScene {
    SKShapeNode *_spinnyNode;
    SKLabelNode *_label;
}
static const CGFloat kTracePixelPerSecond = 1000;

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    SKNode *ball = [self childNodeWithName:@"ball"];
    ball.physicsBody.angularVelocity = 1.0;
    
    /*
    // Get label node from scene and store it for use later
    _label = (SKLabelNode *)[self childNodeWithName:@"//helloLabel"];
    
    _label.alpha = 0.0;
    [_label runAction:[SKAction fadeInWithDuration:2.0]];
    
    CGFloat w = (self.size.width + self.size.height) * 0.05;
    
    // Create shape node to use during mouse interaction
    _spinnyNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w, w) cornerRadius:w * 0.3];
    _spinnyNode.lineWidth = 2.5;
    
    [_spinnyNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:1]]];
    [_spinnyNode runAction:[SKAction sequence:@[
                                                [SKAction waitForDuration:0.5],
                                                [SKAction fadeOutWithDuration:0.5],
                                                [SKAction removeFromParent],
                                                ]]];
     */
}


- (void)touchDownAtPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor greenColor];
    [self addChild:n];
}

- (void)touchMovedToPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor blueColor];
    [self addChild:n];
}

- (void)touchUpAtPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor redColor];
    [self addChild:n];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Run 'Pulse' action from 'Actions.sks'
//    [_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
    
    for (UITouch *touch in touches) {
        CGPoint p  = [touch locationInNode:self];
        NSLog(@"\n%f %f %f %f", p.x, p.y, self.frame.size.width, self.frame.size.height);
        if (p.x < self.frame.size.width * 0.3) {
            self.leftPaddleMotivatingTouch = touch;
            NSLog(@"left paddle");
        } else if (p.x > self.frame.size.width * 0.7) {
            self.rightPaddleMotivatingTouch = touch;
            NSLog(@"right paddle");
//        [self touchDownAtPoint:[t locationInNode:self]];
        } else {
            SKNode *ball = [self childNodeWithName:@"ball"];
            ball.physicsBody.velocity = CGVectorMake(ball.physicsBody.velocity.dx*2.0, ball.physicsBody.velocity.dy);
        }
    }
    [self trackPaddlesToMotivatingTouches];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}


- (void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}
- (void) trackPaddlesToMotivatingTouches {
    id a = @[@{@"node": [self childNodeWithName:@"left_paddle"],
               @"touch": self.leftPaddleMotivatingTouch ?: [NSNull null]},
             @{@"node": [self childNodeWithName:@"right_paddle"],
               @"touch": self.rightPaddleMotivatingTouch ?: [NSNull null]}];
    for (NSDictionary *o in a) {
        SKNode *node = o[@"node"];
        UITouch *touch = o[@"touch"];
        if ([[NSNull null] isEqual:touch]) {
            continue;
        }
        CGFloat yPos = [touch locationInNode:self].y;
        NSTimeInterval duration = ABS(yPos - node.position.y)/kTracePixelPerSecond;
        
        SKAction *moveAction = [SKAction moveToY:yPos duration:duration];
        [node runAction:moveAction withKey:@"moving!"];
    }
}
@end
