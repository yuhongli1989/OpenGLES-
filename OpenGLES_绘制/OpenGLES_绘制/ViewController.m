//
//  ViewController.m
//  OpenGLES_绘制
//
//  Created by yunfu on 2019/3/6.
//  Copyright © 2019 yunfu. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES3/gl.h>
#import "HLLoadShaders.h"

#define BUFFER_OFFSET(offset) (void *)(offset)

@interface ViewController ()

@end

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

@implementation ViewController
{
    EAGLContext *context;
    GLuint ebo;
    GLuint vao;
    GLuint vbo;
    GLuint program;
    BOOL isPoint;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupGL];
    program = [HLLoadShaders loadProgram:vShaderStr withFragment:fShaderStr];
    [self text1];
    
    
}

- (void)text1{
    static const GLfloat positions[] = {
        -0.8f, -0.8f, 0.0f, 1.0f,
         0.8f, -0.8f, 0.0f, 1.0f,
        -0.8f,  0.8f, 0.0f, 1.0f,
         0.8f,  0.8f, 0.0f, 1.0f
    };
    
    static const GLfloat colors[] = {
        1.0f,1.0f,1.0f,1.0f,
        1.0f,1.0f,0.0f,1.0f,
        1.0f,0.0f,1.0f,1.0f,
        0.0f,1.0f,1.0f,1.0f
    };
    
    static const GLushort vertex_indices[] = {
        0,1,2,1,2,3
    };
    //配置顶点数组
    glGenVertexArrays(1, &vao);
    glBindVertexArray(vao);
    
    glUseProgram(program);
    //配置顶点索引数据
    glGenBuffers(1, &ebo);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(vertex_indices), vertex_indices, GL_STATIC_DRAW);
    
    //配置缓存对象
    glGenBuffers(1, &vbo);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    //开辟一块 空的缓存数据
    glBufferData(GL_ARRAY_BUFFER, sizeof(positions)+sizeof(colors), NULL, GL_STATIC_DRAW);
    //把数据绑定到 GL_ARRAY_BUFFER 中
    glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(positions), positions);
    glBufferSubData(GL_ARRAY_BUFFER, sizeof(positions), sizeof(colors), colors);
    //
    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
    //把GL_ARRAY_BUFFER中的缓存的数据 配置到顶点数组中
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*4, BUFFER_OFFSET(0));
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*4, BUFFER_OFFSET(sizeof(positions)));
    
    //回复默认状态
    glBindVertexArray(0);
    glClearColor(1, 1, 1, 0);
}

- (void)setupGL{
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:context];
    GLKView *view = (GLKView *)self.view;
    view.context = context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    glViewport(0, 0, scale*rect.size.width, scale*rect.size.height);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glBindVertexArray(vao);
    
    if (isPoint) {
        glDrawElements ( GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, ( const void * ) 0 );
    }else{
        glDrawArrays(GL_TRIANGLES, 0, 3);
    }
    
//    glDrawArrays(GL_TRIANGLES, 0, 4);
    glBindVertexArray(0);
    
}
- (IBAction)change:(id)sender {
    isPoint = !isPoint;
    
}


@end
