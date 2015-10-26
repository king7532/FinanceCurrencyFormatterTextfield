//
//  OBJCFinanceCurrencyFormatter.m
//  FinanceCurrencyFormatterTextfield
//
//  Created by Benjamin King on 9/21/15.
//  Copyright © 2015 Benjamin King. All rights reserved.
//

#import "OBJCFinanceCurrencyFormatter.h"

static NSNumberFormatter *NumberFormatter = nil;

@interface OBJCFinanceCurrencyFormatter ()
-(void) setupFormatter;
@end

@implementation OBJCFinanceCurrencyFormatter

+ (void)initialize {
    if (!NumberFormatter) {
        NumberFormatter = [[NSNumberFormatter alloc] init];
        NumberFormatter.generatesDecimalNumbers = YES;
    }
}

-(instancetype)init {
    if(self = [super init]) {
        self.cursorOffsetFromEndOfString = 0;
        [self setupFormatter];
        return self;
    }
    else return nil;
}

-(void)setupFormatter {
    self.numberStyle = NSNumberFormatterCurrencyStyle;
    self.generatesDecimalNumbers = YES;
    self.currencyScale = -1 * self.maximumFractionDigits;
    
    NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];
    NSString *s = [self stringFromNumber:[NSDecimalNumber zero]];
    NSUInteger len = [s length];
    unichar buffer[len];
    [s getCharacters:buffer range:NSMakeRange(0, len)];
    long i = len-1;
    
    while(![digits characterIsMember:buffer[i]] && (i > 0)) {
        i -= 1;
    }
    self.cursorOffsetFromEndOfString = -1 * (len - 1 - i);
}

-(NSString *)stringDecimalDigits:(NSString *)s {
    NSCharacterSet *nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[s componentsSeparatedByCharactersInSet:nonDigits] componentsJoinedByString: @""];
}

-(BOOL)isPartialStringValid:(NSString *)partialString newEditingString:(NSString * _Nullable __autoreleasing *)newString errorDescription:(NSString * _Nullable __autoreleasing *)error {
    
    if([partialString length] == 0) {
        return YES;
    }
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:partialString];
    if (![scanner scanInt:nil] || !scanner.atEnd) {
        return NO;
    }
    
    return YES;
}

-(NSString *)stringFromString:(NSString *)string {
    if (!string) return nil;
    
    NSString *digitsStr = [self stringDecimalDigits:string];
    NSLog(@"CurrencyFormatter: %@\tdigits: %@", string, digitsStr);
    
    if ([digitsStr length] == 0) {
        return nil;
    }
    
    NSDecimalNumber *number = [[NSDecimalNumber alloc] initWithString:digitsStr];
    if (!number) {
        number = (NSDecimalNumber *)[NumberFormatter numberFromString:digitsStr];
    }
    
    if (number != [NSDecimalNumber notANumber]) {
        number = [number decimalNumberByMultiplyingByPowerOf10:self.currencyScale];
    }
    else {
        number = [NSDecimalNumber zero];
    }
    
    NSString *formattedStr = [self stringFromNumber:number];
    
    NSLog(@"\t => String: %@\tNumber: %@", formattedStr, [self numberFromString:formattedStr]);
    
    if (formattedStr) {
        return formattedStr;
    }
    else {
        return nil;
    }
}

@end
