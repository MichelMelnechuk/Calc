//
//  PolishCalcWritter.h
//  MBCalculator
//
//  Created by Air on 3/26/15.
//  Copyright (c) 2015 Air. All rights reserved.
//


#define __MBCalculator__PolishCalcWritter__

#include <stdio.h>
#include <string.h>
#include <vector>
#include <stack>
#include <iostream>

using namespace std;

class PolishCalcWritter {
    double calculateExpression(char opertr,double oprnd1,double oprnd2);
    double calculateNegativeExpression (vector<string> &expression);
    vector<string> generatePolishStr(string &str);
    void сompareOperatorsAndAddToStack(stack<char> &stack,vector<string> &expresion, char op2);
    double numOperandFromVector(string paramStr);
    int getPrioritet(char s);
    bool stringIsDigit(string s);
public:
    double calculatePolishStr(string paramStr);
};



