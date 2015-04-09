//
//  ViewController.m
//  MBCalculator
//
//  Created by Air on 3/25/15.
//  Copyright (c) 2015 Air. All rights reserved.
//

#import "MBCalulatorViewController.h"
#import "PolishCalcWritter.h"
#import "UIColor+Branding.h"

static const char zero = '0';
static const NSString *empty = @"";
static const char minusOperator = '-';
static const char point = '.';
static const NSString *equalOperator = @"=";
static const NSString *deleteOperator = @"d";
@interface MBCalulatorViewController ()

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation MBCalulatorViewController
{
    NSString *result;
    char nextOperand;
    char prevOperand;
    BOOL pointIsStands;
    BOOL resultFieldIsEmpty;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    result = [[NSString alloc]init];
    resultFieldIsEmpty = YES;
    pointIsStands = NO;
    
    self.resultLabel.layer.cornerRadius = 16.f;
    self.resultLabel.layer.borderColor = [UIColor brandGreenColor].CGColor;
    self.resultLabel.layer.borderWidth = 1.5;
    self.resultLabel.layer.backgroundColor = [UIColor brandYellowColor].CGColor;
    self.navigationController.navigationBar.barTintColor = [UIColor brandGreenColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkAccuracyOfInputString:(NSString*) paramString
{
    nextOperand = [paramString characterAtIndex:0];
    prevOperand = [result characterAtIndex:result.length-1];
    
    
    if (isdigit(nextOperand)) {
        if (nextOperand == zero &&
            prevOperand == nextOperand
            && pointIsStands == NO ) return;
        [self addElemToResultLabel:paramString];
    }
    if (!isdigit(nextOperand)
        & isdigit(prevOperand)||
        ([result isEqual:empty] &
         nextOperand) == minusOperator) {
        if (nextOperand == point && pointIsStands == YES) return;
        if (nextOperand == point) pointIsStands = YES;
            else pointIsStands = NO;
        [self addElemToResultLabel:paramString];
    }
}

-(void) addElemToResultLabel:(NSString*) paramString
{
    NSString *tempString = paramString;
    result = [result stringByAppendingString:tempString];
    self.resultLabel.text = result;
}

-(void) doCalculations
{
    const char *strResult = [result UTF8String];
    double doubleResult = calculatePolishStr(strResult);
    NSNumber *num = [NSNumber numberWithDouble:doubleResult];
    result = [num stringValue];
    self.resultLabel.text = result;
}

-(IBAction)touchCalcButton:(UIButton*)sender // white on c++
{
    if (![sender.titleLabel.text  isEqual:equalOperator]
        && (![sender.titleLabel.text isEqual:deleteOperator])) [self checkAccuracyOfInputString:sender.titleLabel.text];
    if ([sender.titleLabel.text  isEqual:equalOperator]) [self doCalculations];
    if ([sender.titleLabel.text isEqual:deleteOperator]) {
        result = @"";
        self.resultLabel.text  = @"";
    }
    [self.view setNeedsDisplay];
}

@end
