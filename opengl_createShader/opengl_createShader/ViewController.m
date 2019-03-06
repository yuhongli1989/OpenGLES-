//
//  ViewController.m
//  opengl_createShader
//
//  Created by yunfu on 2019/3/5.
//  Copyright © 2019 yunfu. All rights reserved.
//

#import "ViewController.h"
#import "HLLoadShaders.h"

#define BUFFER_OFFSET(offset) (void *)(offset)

@interface ViewController ()

@end

@implementation ViewController
{
    EAGLContext *context;
    GLuint vboIds[1];
    GLuint vaoId;
    GLuint program;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initGL];
    const char vShaderStr[] =
    "#version 300 es                            \n"
    "layout(location = 0) in vec4 a_position;   \n"
    "layout(location = 1) in vec4 a_color;      \n"
    "out vec4 v_color;                          \n"
    "void main()                                \n"
    "{                                          \n"
    "    v_color = a_color;                     \n"
    "    gl_Position = a_position;              \n"
    "}\n";
    
    
    const char fShaderStr[] =
    "#version 300 es            \n"
    "precision mediump float;   \n"
    "in vec4 v_color;           \n"
    "out vec4 o_fragColor;      \n"
    "void main()                \n"
    "{                          \n"
    "    o_fragColor = v_color; \n"
    "}\n";
    
    program = [HLLoadShaders loadProgram:vShaderStr withFragment:fShaderStr];
    
    
    GLfloat vertices[] = {
        0.0,  0.5, 0.0,
        1.0,  0.0,  0.0,1.0,
        -0.5, -0.5,  0.0,
        0.0,  1.0,  0.0,1.0,
        0.5,  -0.5,  0.0,
        0.0,  0.0,  1.0,1.0
    };
    
    glGenVertexArrays(1, &vaoId);
    glBindVertexArray(vaoId);
    glUseProgram(program);
    glGenBuffers(1, vboIds);
    glBindBuffer(GL_ARRAY_BUFFER, vboIds[0]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*7, BUFFER_OFFSET(0));
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*7, BUFFER_OFFSET(sizeof ( GLfloat )*3));
    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
    //回复默认状态
    glBindVertexArray(0);
    glClearColor(1, 1, 1, 0);
    
}

- (void)initGL{
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:context];
    GLKView *view = (GLKView *)self.view;
    view.context = context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
}

- (void)dealloc
{
    glDeleteBuffers(1, vboIds);
    glDeleteVertexArrays(1, &vaoId);
    glDeleteProgram(program);
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    CGFloat scale = [UIScreen mainScreen].scale;
    glViewport(0, 0, self.view.frame.size.width*scale, self.view.frame.size.height*scale);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glBindVertexArray(vaoId);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glBindVertexArray(0);
    
}


@end
