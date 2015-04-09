//
//  PolishCalcWritter.cpp
//  MBCalculator
//
//  Created by Air on 3/26/15.
//  Copyright (c) 2015 Air. All rights reserved.
//

#include "PolishCalcWritter.h"

void сompareOperatorsAndAddToStack(stack<char> &paramStack,vector<string> &expresion, char op1)
{
    if (paramStack.empty()) {
        paramStack.push(op1);
        return;
    }
    char top = paramStack.top();
    string strTop(1,top);
    if (getPrioritet(op1) > getPrioritet(top))  paramStack.push(op1);
    if (getPrioritet(op1) < getPrioritet(top)) {
        expresion.push_back(strTop);
        paramStack.pop();
        if(!paramStack.empty()) {
            сompareOperatorsAndAddToStack(paramStack,expresion,op1);
        }
    }
    if (getPrioritet(op1) == getPrioritet(top)) {
        expresion.push_back(strTop);
        paramStack.pop();
        paramStack.push(op1);
    }
}

vector<string> generatePolishStr(string &paramStr)
{
    stack<char> operatorsStack;
    vector<string> expresion ;
    string tempOperand = "";
    
    if (paramStr[0] == '-') {
        tempOperand+=paramStr[0];
        paramStr.erase(paramStr.begin());
        
    }
    for (int i = 0; i < paramStr.length(); i++) {
        if (isdigit(paramStr[i]) || (paramStr[i] == '.')) {
            string tempStr(1,paramStr[i]);
            tempOperand += tempStr;
        } else {
            if (paramStr[0] == '-') {
                string tempStr(1,paramStr[0]);
                tempOperand += tempStr;
                paramStr[0] = 'x';
            } else { expresion.push_back(tempOperand);
                tempOperand = "";
                сompareOperatorsAndAddToStack(operatorsStack, expresion, paramStr[i]);
            }
            
        }
    }
    expresion.push_back(tempOperand);
    while (!operatorsStack.empty()) {
        string tempStr(1,operatorsStack.top());
        expresion.push_back(tempStr);
        operatorsStack.pop();
    }
    return expresion;
}

double calculatePolishStr(string paramStr) // ??? vector to string ?
{
    vector<string> expression = generatePolishStr(paramStr);
    double result = 0;
    int i = 0;
    
    while(expression.size() !=1) {
        char firstElm = *expression[i].c_str();
        if (*expression[i].c_str() == '-' & i == 0) {
            firstElm = '1';
        }
        if (!isdigit(firstElm) ) {
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


double numOperandFromVector(string paramStr)
{
    double operand = 0;
    string strOperand = "";
    
    for (int i = 0 ; i < paramStr.length(); i++) {
        strOperand += paramStr[i];
    }
    operand = atof(strOperand.c_str());
    return operand;
}

double calculateExpression(char opertr,double oprnd1,double oprnd2){
    double result = 0;
    switch (opertr) {
        case '*':
            result = oprnd1*oprnd2;
            break;
        case '/':
            if (oprnd1  == 0 || oprnd2 == 0) {
                cout << "division on zero!!";
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
            cout<<"something wrong with post fix string operators";
            break;
    }
    return result;
}

int getPrioritet(char s)
{
    if (s == '*' || s== '/') {
        return 2;
    }
    return 1;
}
