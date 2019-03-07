//
//  HLLoadShaders.m
//  opengl_createShader
//
//  Created by yunfu on 2019/3/5.
//  Copyright © 2019 yunfu. All rights reserved.
//
/*
 创建着色器步骤
 1.创建着色器
 2.将源码添加到着色器
 3.编译着色器
 4.创建一个程序
 5.将编译后的着色器连接到程序上
 6.链接程序
 */

#import "HLLoadShaders.h"
#import <OpenGLES/ES3/gl.h>

@implementation HLLoadShaders

+(BOOL)loadShader:(GLenum)type withShader:(GLuint *)shader withSource:(const char *)source{
    //创建着色器
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    GLint status = 0;
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (!status) {
        GLint count = 0;
        glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &count);
        if (count > 0) {
            char * log = malloc(sizeof(char)*count);
            glGetShaderInfoLog(*shader, count, NULL, log);
            NSLog(@"create shader error:%s",log);
            free(log);
        }
        return NO;
    }
    
    return YES;
}

+(BOOL)createProgram:(GLuint *)program withVertex:(GLuint)vertex withFragment:(GLuint)fragment{
    
    *program = glCreateProgram();
    glAttachShader(*program, vertex);
    glAttachShader(*program, fragment);
    glLinkProgram(*program);
    GLint status = 0;
    
    glGetProgramiv(*program, GL_LINK_STATUS, &status);
    if (!status) {
        GLint count = 0;
        glGetProgramiv(*program, GL_INFO_LOG_LENGTH, &count);
        if (count > 0) {
            char * log = malloc(sizeof(char)*count);
            glGetProgramInfoLog(*program, count, NULL, log);
            NSLog(@"create program error:%s",log);
            free(log);
        }
        glDeleteShader(vertex);
        glDeleteShader(fragment);
        return NO;
    }
    glDeleteShader(vertex);
    glDeleteShader(fragment);
    return YES;
}

+(GLuint)loadProgram:(const char *)vShaderStr withFragment:(const char *)fShaderStr{
    GLuint program ,vShader,fShader;
    [HLLoadShaders loadShader:GL_VERTEX_SHADER withShader:&vShader withSource:vShaderStr];
    [HLLoadShaders loadShader:GL_FRAGMENT_SHADER withShader:&fShader withSource:fShaderStr];
    [HLLoadShaders createProgram:&program withVertex:vShader withFragment:fShader];
    return program;
}

@end
