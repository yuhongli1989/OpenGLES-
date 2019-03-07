//
//  ViewController.m
//  OpenGLES_图元
//
//  Created by yunfu on 2019/3/6.
//  Copyright © 2019 yunfu. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES3/gl.h>
#import "HLLoadShaders.h"

#define NUM_INSTANCES   100
#define POSITION_LOC    0
#define COLOR_LOC       1
#define MVP_LOC         2

#define BUFFER_OFFSET(offset) (void *)(offset)

@interface ViewController ()

@property(nonatomic, copy)NSArray *btnTitles;


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
"    gl_PointSize = 30.0;                   \n"
"}\n";


const char fShaderStr[] =
"#version 300 es                            \n"
"precision mediump float;                   \n"
"in vec4 v_color;                           \n"
"layout(location = 0) out vec4 outColor;    \n"
"void main()                                \n"
"{                                          \n"
"    outColor = v_color;                    \n"
"}\n";


@implementation ViewController
{
    EAGLContext *context;
    GLuint program;
    int    _selectedIndex;
    
    GLuint pointBuffer;
    GLuint pointArrays;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupGL];
    
    [self setupPointAndColor];
    
}

- (NSArray *)btnTitles{
    if (!_btnTitles) {
        _btnTitles = @[@GL_POINTS,@GL_LINES,@GL_LINE_STRIP,@GL_LINE_LOOP,@GL_TRIANGLES,@GL_TRIANGLE_STRIP,@GL_TRIANGLE_FAN];
        
    }
    return _btnTitles;
}

- (IBAction)click:(id)sender {
    _selectedIndex++;
    if (_selectedIndex >= self.btnTitles.count) {
        _selectedIndex = 0;
    }
}


- (void)setupPointAndColor{
    program = [HLLoadShaders loadProgram:vShaderStr withFragment:fShaderStr];
    GLfloat points[] = {

        -0.5,0.5,0.0,
        0.5,0.5,0.0,
        -0.5,-0.5,0.0,
        0.5,-0.5,0.0,

    };
    
    GLfloat color[] = {

        0.0,0.0,1.0,1.0,
        1.0,0.0,0.0,1.0,
        0.0,1.0,0.0,1.0,
        0.8,0.6,0.6,1.0,

    };
    
    
    glGenVertexArrays(1, &pointArrays);
    glBindVertexArray(pointArrays);
    glUseProgram(program);
    glGenBuffers(1, &pointBuffer);
    
    glBindBuffer(GL_ARRAY_BUFFER, pointBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(points)+sizeof(color), NULL, GL_STATIC_DRAW);
    
    glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(points), points);
    glBufferSubData(GL_ARRAY_BUFFER, sizeof(points), sizeof(color), color);
    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*3, BUFFER_OFFSET(0));
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*4, BUFFER_OFFSET(sizeof(points)));
    glBindVertexArray(0);
    
    glClearColor(1, 1, 1, 0.0);
    
    
}


- (void)setupGL{
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:context];
    GLKView *view = (GLKView *)self.view;
    view.context = context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
}



- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    GLfloat scale = [UIScreen mainScreen].scale;
    glViewport(0, 0, rect.size.width*scale, rect.size.height*scale);
    glClear(GL_COLOR_BUFFER_BIT);

    glBindVertexArray(pointBuffer);
    
    glDrawArrays((GLenum)[self.btnTitles[_selectedIndex] intValue], 0, 4);
    glBindVertexArray(0);
    
}

@end
