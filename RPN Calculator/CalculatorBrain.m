//
//  CalculatorBrain.m
//  RPN Calculator
//
//  Created by Simon Silverleaf on 8/24/12.
//  Copyright (c) 2012 Simon Silverleaf. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
// this is the setter code that is also created with the @synthesize command does not allocate anything
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}
/* - this code is removed as it is the getter
- (void)setOperandStack:(NSMutableArray *)operandStack
{
    _operandStack = operandStack
}
*/
- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}
//- (double)popOperand
//{
//    NSNumber *operandObject = [self.operandStack lastObject];
//    if (operandObject) [self.operandStack removeLastObject];
//    return [operandObject doubleValue];
//}

- (void)pushOperatorOrVariable:(NSString *)opOrVar
{
    [self.programStack addObject:[NSString stringWithString:opOrVar]];
}

- (void)clearBrain
{
    self.programStack = nil;
}

// method to take items of the stack and reverse the order to show the actions taken from the information added to the program

+ (NSString *)descriptionOfProgram:(id)program
{
    {
        NSMutableArray *stack;
        if ([program isKindOfClass:[NSArray class]]){
            stack = [program mutableCopy];
        }
        NSString *result = @"";
        
        while (stack.count >0){
            result = [result stringByAppendingFormat:@"%@, ", [CalculatorBrain descriptionOfTopStack:&stack]];
        }
        return result;  
    }
// see sections 3 and 6 from assignment @
    
//    return @"Implement this in Assignment 2";
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

- (id)program
{
    // instance method that creates a copy of the programStack for use in the
    // generation of the history
    
    return [self.programStack copy];
}

// Model the stack processing based on the program working through the stack
// Take each item off the stack and determine if it is an operator, variable or operand

+(NSString *)descriptionOfTopStack:(NSMutableArray **)stack
{
    NSString *result = @"blank";
    
    id topOfStack = [*stack lastObject];
    if (topOfStack) [*stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack stringValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operationOrVariable = topOfStack;
        
        if ([CalculatorBrain isOperation:operationOrVariable]) {
            int numberOfOperands = [CalculatorBrain numberOfOperandsForOperation:operationOrVariable];
            switch (numberOfOperands) {
                case 2:{
                    NSString *firstOperand = [CalculatorBrain descriptionOfTopStack:stack];
                    NSString *secondOperand = [CalculatorBrain descriptionOfTopStack:stack];
                    result = [NSString stringWithFormat:@"( %@ %@ %@ )", secondOperand, operationOrVariable, firstOperand];
                }
                case 1:{
                    NSString *firstOperand = [CalculatorBrain descriptionOfTopStack:stack];
                    result = [NSString stringWithFormat:@" %@ ( %@ )", operationOrVariable, firstOperand];
                }
                case 0:{
                    result = [NSString stringWithFormat:@" %@", operationOrVariable];
                }
            }
            
        }else if ([CalculatorBrain isVariable:operationOrVariable]){
            
        }
     
    }
    return result;
}
+ (BOOL)isOperation:(NSString *)operation
{
    NSSet *operations = [NSSet setWithObjects:@"+",@"*",@"-",@"/",@"sin",@"cos",@"sqrt",@"log",@"π",@"e",  nil];
    if ([operations containsObject:operation]){
        return YES;
    }
    return NO;
    
}

+(BOOL)isVariable:(NSString *)variable
{
    NSSet *variables = [NSSet setWithObjects:@"x",@"a",@"b", nil];
    if ([variables containsObject:variable]){
        return YES;
    }
    return NO;
}

+(int)numberOfOperandsForOperation:(NSString *)operation
{
    int result = -1;
    
    NSSet *operationsWith2Operands = [NSSet setWithObjects:@"+",@"*",@"-",@"/", nil];
    NSSet *operationsWith1Operands = [NSSet setWithObjects:@"sin",@"cos",@"sqrt",@"log", nil];
    NSSet *operationsWith0Operands = [NSSet setWithObjects:@"π",@"e", nil];
    
    if ([operationsWith2Operands containsObject:operation]){
        result = 2;
    }
    else if ([operationsWith1Operands containsObject:operation]){
        result = 1;
    }
    else if ([operationsWith0Operands containsObject:operation])
    {
        result = 0;
    }
    return result;
    
}

+(double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]){
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sin"]){
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"cos"]){
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]){
            result = sqrt([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"log"]){
            result = log([self popOperandOffProgramStack:stack]);
        }   else if ([operation isEqualToString:@"π"]){
            result = M_PI;
        } else if ([operation isEqualToString:@"e"]){
            result = M_E;
        }

    }
    
    return result;
}

+(double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}



//
//    double result = 0;
//    //calculate result
//    
//    
//    [self pushOperand:result];
//    
//    return result;
//    
//}


@end
