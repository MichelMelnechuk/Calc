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
static const char minusOperator = '-';
static const char plusOperator = '+';
static const char divOperator = '/';
static const char multiOperator = '*';
static const char openBracketOperator = '(';
static const char closeBracketOperator = ')';
static const char point = '.';
static const NSString *equalOperator = @"=";

@interface MBCalulatorViewController ()
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfResLabel;
@end

@implementation MBCalulatorViewController
{
    NSString *result;
    char nextOperand;
    char prevOperand;
    BOOL pointIsStands;
    BOOL resultFieldIsEmpty;
    BOOL bracketIsStands;
    int countNum;
    int countOfElem;
    int countOfOpenBrackets;
    int countOfClosedBrackets;
    PolishCalcWritter pcWritter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    result = [[NSString alloc]init];
    pointIsStands = NO;
    bracketIsStands = NO;
    countNum = 0;
    countOfElem = 0;
    countOfOpenBrackets = 0;
    countOfClosedBrackets = 0;
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

- (void)checkAccuracyOfInputOperatorString:(NSString*) paramString
{
        countOfElem++;
        if (result.length == 0)
            if (![self checkEmptyFieldValid]) {
                return;
            }
        if (nextOperand == point)
            if(![self checkPointValidation]) {
                return;
            }
        if(nextOperand == openBracketOperator |
           nextOperand == closeBracketOperator)
            if (![self checkBracketValidation]) {
                return;
            }
        if ([self isOperator:nextOperand])
            if(![self checkOperatorsValid]) {
                return;
            }
    
    if (countOfElem == 21 ||
        countOfElem ==42 ||
        countOfElem == 63) {
        self.heightOfResLabel.constant += 20;
        [UIView animateWithDuration:0.5f animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    
    [self addElemToResultLabel:paramString];
}

- (BOOL)checkCountOfNum
{
    if(countNum > 5) return false; //count of numbers in expression validation (with operands)
    else countNum++;
    countOfElem++;
    return true;
}

- (BOOL) checkZeroValid
{
       if ( prevOperand == zero &&
        pointIsStands == NO) return NO;
    return YES;
}

- (BOOL) checkPointValidation
{
    if ([self isOperator:nextOperand]) pointIsStands = NO;
    if (nextOperand == point) pointIsStands = YES;
    return YES;
}

-(BOOL)checkEmptyFieldValid
{
        if(!((nextOperand == openBracketOperator) ||
         (nextOperand == minusOperator))) return NO;
    return YES;
}

-(BOOL) checkBracketValidation
{
    
    if (nextOperand == openBracketOperator) { countOfOpenBrackets++;  // bracket validation
    }
    if (nextOperand == closeBracketOperator) {
        countOfClosedBrackets++;
    }
    if(nextOperand == closeBracketOperator &&
       ![self isOperator:prevOperand] &&
       [result characterAtIndex:result.length-2] == openBracketOperator) {
        return NO;
    }
    if(nextOperand == closeBracketOperator &&
       [self isOperator:prevOperand]) {
        return NO;
    }
    if (prevOperand == openBracketOperator &&
        [self isOperator:nextOperand]) {
        return NO;
    }
    if (nextOperand == closeBracketOperator &&
        countOfOpenBrackets < countOfClosedBrackets) {
        return NO;
    }
    return YES;
}

- (BOOL) checkOperatorsValid
{
    if(nextOperand == point) countNum++; //count of numbers in expression validation (with point)
    if([self isOperator:nextOperand]) countNum = 0; //count of numbers in expression validation (with operators)
    if([self isOperator:prevOperand] && // operators validation
       [self isOperator:nextOperand]) {
        return NO;
    }
    return YES;
}

- (BOOL) checkCountOfElem
{
    if (countOfElem == 62) {
        if ([self isOperator:nextOperand] ||
            nextOperand == openBracketOperator ) {
            return NO;
        }
        return YES;
    }
    if (countOfElem == 63)
        return NO;
    
    return YES;
}


-(void) addElemToResultLabel:(NSString*) paramString
{
    NSString *tempString = paramString;
    result = [result stringByAppendingString:tempString];
    self.resultLabel.text = result;
}

-(BOOL) isOperator: (char) paramString
{
    if (paramString == minusOperator ||
        paramString == plusOperator ||
        paramString == divOperator ||
        paramString == multiOperator ||
        paramString == point) return YES;
    else return NO;
}

-(void) doCalculations
{
    const char *strResult = [result UTF8String];
    double doubleResult = pcWritter.calculatePolishStr(strResult);
    NSNumber *num = [NSNumber numberWithDouble:doubleResult];
    result = [num stringValue];
    self.resultLabel.text = result;
}

-(IBAction)touchOperandButton:(UIButton*)sender
{
    nextOperand = [sender.titleLabel.text characterAtIndex:0];
    prevOperand = [result characterAtIndex:result.length-1];
    if (![self checkCountOfNum] ||
        ![self checkZeroValid]) return;
    [self addElemToResultLabel:sender.titleLabel.text];
    [self.view setNeedsDisplay];
}

-(IBAction)touchOperatorButton:(UIButton*)sender
{
    nextOperand = [sender.titleLabel.text characterAtIndex:0];
    prevOperand = [result characterAtIndex:result.length-1];
    if (![sender.titleLabel.text  isEqual:equalOperator])
        [self checkAccuracyOfInputOperatorString:sender.titleLabel.text];
    if ([sender.titleLabel.text  isEqual:equalOperator] &
        (prevOperand !=  minusOperator) &
        (prevOperand !=  plusOperator) &
        (prevOperand !=  divOperator) &
        (prevOperand != multiOperator) )
        [self doCalculations];
    
    if ([sender.titleLabel.text  isEqual:equalOperator] &&
        (result.length == 0))
        self.resultLabel.text = @"";
    [self.view setNeedsDisplay];
}

-(IBAction)touchDelAllButton:(UIButton*)sender
{
    result = @"";
    self.resultLabel.text  = @"";
    pointIsStands = NO;
    bracketIsStands = NO;
    countNum = 0;
    countOfElem = 0;
    countOfOpenBrackets = 0;
    countOfClosedBrackets = 0;
    self.heightOfResLabel.constant = 51;
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
    [self.view setNeedsDisplay];
}

-(IBAction)touchDelLastButton:(UIButton*)sender
{
    NSString *resultAfterRemove = [result substringToIndex:[result length]-1];
    result = resultAfterRemove;
    self.resultLabel.text = result;
    [self.view setNeedsDisplay];
}

@end
