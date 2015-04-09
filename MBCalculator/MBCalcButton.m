//
//  MBCalcButton.m
//  MBCalculator
//
//  Created by Air on 3/25/15.
//  Copyright (c) 2015 Air. All rights reserved.
//

#import "MBCalcButton.h"
#import "UIColor+Branding.h"

@implementation MBCalcButton


- (void)drawRect:(CGRect)rect {
    // Drawing code    
    UIBezierPath* path =
    [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:17];
    [[UIColor brandGreenColor] setFill];
    [path fill];
}

@end
