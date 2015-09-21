//
//  OBJCFinanceCurrencyFormatter.h
//  FinanceCurrencyFormatterTextfield
//
//  Created by Benjamin King on 9/21/15.
//  Copyright © 2015 Benjamin King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBJCFinanceCurrencyFormatter : NSNumberFormatter

@property (nonatomic) NSInteger currencyScale;
@property (nonatomic) NSInteger cursorOffsetFromEndOfString;

-(NSString * _Nonnull)stringDecimalDigits:(NSString * _Nonnull)s;
-(BOOL)isPartialStringValid:(NSString *)partialString newEditingString:(NSString * _Nullable __autoreleasing *)newString errorDescription:(NSString * _Nullable __autoreleasing *)error;

@end
