//
//  PolishCalcWritter.cpp
//  MBCalculator
//
//  Created by Air on 3/26/15.
//  Copyright (c) 2015 Air. All rights reserved.
//

#include "PolishCalcWritter.h"

void PolishCalcWritter::сompareOperatorsAndAddToStack(stack<char> &paramStack,vector<string> &expresion, char op1)
{
    if (paramStack.empty()) {
        paramStack.push(op1);
        return;
    }
    
    char top = paramStack.top();
    string strTop(1,top);
    if(strTop == "(") {
        paramStack.push(op1);
        return;
    }
    if (op1 == ')')  {
        while(paramStack.top() != '(') {
            if((strTop != ")") ||
               (strTop != "("))
                expresion.push_back(strTop);
            paramStack.pop();
        }
        paramStack.pop();
        return;
    }
    if (getPrioritet(op1) > getPrioritet(top)) {
        paramStack.push(op1);
        return;
    }
    if (getPrioritet(op1) < getPrioritet(top)) {
        if((strTop != ")") ||
           (strTop != "("))
            expresion.push_back(strTop);
        paramStack.pop();
        сompareOperatorsAndAddToStack(paramStack,expresion,op1);
    }
    if (getPrioritet(op1) == getPrioritet(top)) {
        if((strTop != ")") ||
           (strTop != "("))
            expresion.push_back(strTop);
        paramStack.pop();
        paramStack.push(op1);
    }
}

vector<string> PolishCalcWritter::generatePolishStr(string &paramStr)
{
    stack<char> operatorsStack;
    vector<string> expression ;
    string tempOperand = "";
    
    if (paramStr[0] == '-') {
        tempOperand += "-";
        paramStr.erase(paramStr.begin() + 0);
    }
    
    
    for (int i = 0; i < paramStr.length(); i++) {
        if (isdigit(paramStr[i]) || (paramStr[i] == '.')) {
            string tempStr(1,paramStr[i]);
            tempOperand += paramStr[i];
        } else if (!isdigit(paramStr[i])){
            if(tempOperand !="")
                expression.push_back(tempOperand);
            tempOperand = "";
            сompareOperatorsAndAddToStack(operatorsStack, expression, paramStr[i]);
            }
            
        }
    if(tempOperand !="")expression.push_back(tempOperand);
    while (!operatorsStack.empty()) {
        string strTop(1,operatorsStack.top());
        if((strTop != ")") ||
           (strTop != "("))
            expression.push_back(strTop);
        operatorsStack.pop();
    }
    return expression;
}

double PolishCalcWritter::calculatePolishStr(string paramStr)
{
    double result = 0;
    if (paramStr.empty()) return result;
    vector<string> expression = generatePolishStr(paramStr);
    int i = 0;
    while(expression.size() != 1) {
        if (!stringIsDigit(expression[i])) {
            double nextOperand = numOperandFromVector(expression[i-1]);
            double prevOperand = numOperandFromVector(expression[i-2]);
            char opertr = *expression[i].c_str();
            result = calculateExpression(opertr, prevOperand, nextOperand);
            expression.erase(expression.begin()+i);
            expression.erase(expression.begin()+i-1);
            expression[i-2] = to_string(result);
            i = 0;
        } else {
            i ++;
        }
    }
    return result;
}

double PolishCalcWritter::numOperandFromVector(string paramStr)
{
    double operand = 0;
    string strOperand = "";
    
    for (int i = 0 ; i < paramStr.length(); i++) {
        strOperand += paramStr[i];
    }
    operand = atof(strOperand.c_str());
    return operand;
}

bool PolishCalcWritter::stringIsDigit(string s)
{
    for (int i = 0; i < s.length(); i++) {
        if (!isdigit(s[i]) & (s[i] != '.') & s.length() == 1) return false;
    }
    return true;
}

double PolishCalcWritter::calculateExpression(char opertr,double oprnd1,double oprnd2){
    double result = 0;
    switch (opertr) {
        case '*':
            result = oprnd1*oprnd2;
            break;
        case '/':
            if (oprnd1  == 0 || oprnd2 == 0) {
                cout<<"crash on PolishCalcWritter::calculateExpression";
                exit(1);
            } else {
                result = oprnd1/oprnd2;
            }
            break;
        case '+':
            result = oprnd1+oprnd2;
            break;
        case '-':
            result = oprnd1-oprnd2;
            break;
        default:
            cout<<"crash on PolishCalcWritter::calculateExpression";
            exit(1);
            break;
    }
    return result;
}

int PolishCalcWritter::getPrioritet(char s)
{
    if (s ==  '(' || s == ')') return 3;
    if (s == '*' || s== '/')   return 2;
    return 1;
}
