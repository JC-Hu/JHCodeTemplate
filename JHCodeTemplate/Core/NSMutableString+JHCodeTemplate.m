//
//  NSMutableString+JHCodeTemplate.m
//  JHCodeTemplate
//
//  Created by JasonHu on 2017/4/20.
//  Copyright © 2017年 JasonHu. All rights reserved.
//

#import "NSMutableString+JHCodeTemplate.h"

@implementation NSMutableString (JHCodeTemplate)

- (void)codeAppendMethodBeganWithName:(NSString *)methodName
{
    [self appendFormat:@"- (void)%@\n{\n",methodName];
}

- (void)codeAppendMethodEnd
{
    [self appendString:@"}\n\n"];
}

- (void)codeAppendReturn
{
    [self appendString:@"\n"];
}


#pragma mark -
- (void)codeAppendAtEnd
{
    [self appendString:@"@end\n"];
}

- (void)codeAppendClassDeclareWithClassName:(NSString *)className superName:(NSString *)superName
{
    [self appendFormat:@"@interface %@ : %@\n", className, superName];
}


- (void)codeAppendClassImplementationWithClassName:(NSString *)className
{
    [self appendFormat:@"@implementation %@\n", className];
}

- (void)codeAppendClassExtensionWithClassName:(NSString *)className
{
    [self appendFormat:@"@interface %@()\n", className];
}

#pragma mark -
- (void)codeAppendPragmaMark:(NSString *)name
{
    [self codeAppendPragmaMark:name withDash:YES];
}

- (void)codeAppendPragmaMark:(NSString *)name withDash:(BOOL)dash
{
    [self appendFormat:@"#pragma mark %@%@\n",dash?@"- ":@"", name];
}

#pragma mark -
- (void)codeAppendImportCommon:(NSString *)name
{
    [self codeAppendImportSpecific:[NSString stringWithFormat:@"\"%@.h\"", name]];
}

- (void)codeAppendImportSpecific:(NSString *)fullStr
{
    [self appendFormat:@"#import %@\n",fullStr];
}

@end
