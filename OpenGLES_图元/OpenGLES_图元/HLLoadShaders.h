//
//  HLLoadShaders.h
//  opengl_createShader
//
//  Created by yunfu on 2019/3/5.
//  Copyright © 2019 yunfu. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLLoadShaders : NSObject
//创建program
+(GLuint)loadProgram:(const char *)vShaderStr withFragment:(const char *)fShaderStr;
//
+(BOOL)createProgram:(GLuint *)program withVertex:(GLuint)vertex withFragment:(GLuint)fragment;

+(BOOL)loadShader:(GLenum)type withShader:(GLuint *)shader withSource:(const char *)source;

@end

NS_ASSUME_NONNULL_END
