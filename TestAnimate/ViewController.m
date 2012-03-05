//
//  ViewController.m
//  TestAnimate
//
//  Created by John Baker on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self animate];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)animate
{
    CATransform3D transform = CATransform3DIdentity;
    UIView *mainView;
    CGFloat width = self.view.bounds.size.width;
    CGFloat theight = self.view.bounds.size.height;
    int faces = 8;
    CGFloat height = theight / faces;
    CALayer *perspectiveLayer;
    
    UIImage* frontImage = [UIImage imageNamed:@"two.png"];
    
    mainView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"one.png"]];
                mainView.frame = CGRectMake(0, 0, width, theight);
    [self.view addSubview:mainView];
    
    perspectiveLayer = [CALayer layer];
    perspectiveLayer.frame = CGRectMake(0, 0, width, theight);
    [mainView.layer addSublayer:perspectiveLayer];
    
    CATransformLayer* joint = [CATransformLayer layer];
    joint.frame = mainView.bounds;
    joint.anchorPoint = CGPointMake(0.5, 0);
    joint.position = CGPointMake(width/2, 0);
    [perspectiveLayer addSublayer:joint];
    
    transform.m34 = 1.0/(-700.0);
    perspectiveLayer.sublayerTransform = transform;

    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    [animation setDuration:2];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:INFINITY];
    [animation setFromValue:[NSNumber numberWithDouble:0]];
    [animation setToValue:[NSNumber numberWithDouble:-90*M_PI/180]];
    [joint addAnimation:animation forKey:nil];

    NSArray *colors;
    colors = [NSArray arrayWithObjects: [UIColor grayColor], 
                                        [UIColor redColor],
                                        [UIColor greenColor],
              [UIColor blueColor],                                        [UIColor purpleColor],

                                        [UIColor cyanColor],
                                        [UIColor orangeColor],
                                        [UIColor magentaColor],nil];

    for(int i = 0; i < faces; i++) {
                
        CGRect currentRect = CGRectMake(0, i*height, width, height);
        CGImageRef currentRef = CGImageCreateWithImageInRect(frontImage.CGImage, currentRect);

        CALayer* sleeve = [CALayer layer];
        sleeve.frame = CGRectMake(0, 0, width, height);
        sleeve.anchorPoint = CGPointMake(0.5, 0);
        sleeve.backgroundColor = ((UIColor*)[colors objectAtIndex:i]).CGColor;
        sleeve.position = CGPointMake(width/2, 0);
        [joint addSublayer:sleeve];
        sleeve.masksToBounds = YES;
        sleeve.contents = (id)currentRef;
        
        CALayer* shadow = [CALayer layer];
        [sleeve addSublayer:shadow];
        shadow.frame = sleeve.bounds;
        shadow.backgroundColor = [UIColor blackColor].CGColor;
        shadow.opacity = 0;
        
        if(i%2==0) {

        animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [animation setDuration:2];
        [animation setAutoreverses:YES];
        [animation setRepeatCount:INFINITY];
        [animation setFromValue:[NSNumber numberWithDouble:0]];
        [animation setToValue:[NSNumber numberWithDouble:0.5]];
        [shadow addAnimation:animation forKey:nil];
        
        }
        if(i < faces-1) {
            CATransformLayer* newJoint = [CATransformLayer layer];
            newJoint.frame = mainView.bounds;
            newJoint.frame = CGRectMake(0, 0, width, height*2);
            newJoint.anchorPoint = CGPointMake(0.5, 0);
            newJoint.position = CGPointMake(width/2, height);
            [joint addSublayer:newJoint];
            
            animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
            [animation setDuration:2];
            [animation setAutoreverses:YES];
            [animation setRepeatCount:INFINITY];
            [animation setFromValue:[NSNumber numberWithDouble:0]];
            if(i%2==0) {
                [animation setToValue:[NSNumber numberWithDouble:(180)*M_PI/180]];
            } else {
                [animation setToValue:[NSNumber numberWithDouble:-1 * (180)*M_PI/180]];
            }
            [newJoint addAnimation:animation forKey:nil];
            joint = newJoint;
        }
    }
    
    animation = [CABasicAnimation animationWithKeyPath:@"bounds.size.height"];
    [animation setDuration:2];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:INFINITY];
    [animation setFromValue:[NSNumber numberWithDouble:perspectiveLayer.bounds.size.height]];
    [animation setToValue:[NSNumber numberWithDouble:0]];
    [perspectiveLayer addAnimation:animation forKey:nil];

    animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    [animation setDuration:2];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:INFINITY];
    [animation setFromValue:[NSNumber numberWithDouble:perspectiveLayer.position.y]];
    [animation setToValue:[NSNumber numberWithDouble:0]];
    [perspectiveLayer addAnimation:animation forKey:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
