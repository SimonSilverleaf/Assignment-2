//
//  CalculatorBrain.h
//  RPN Calculator
//
//  Created by Simon Silverleaf on 8/24/12.
//  Copyright (c) 2012 Simon Silverleaf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)clearBrain;

@property (readonly) id program;

+ (double)runProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;

@end
