//
//  OpenGLView.h
//  HelloOpenGL
//
//  Created by Ray Wenderlich on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

@interface OpenGLView : UIView {
  CAEAGLLayer* _eaglLayer;
  EAGLContext* _context;
  GLuint _colorRenderBuffer;
  GLuint _positionSlot;
  GLuint _colorSlot;
  GLuint _projectionUniform;
  GLuint _modelViewUniform;
  float _currentRotation;
  GLuint _depthRenderBuffer;
  
  GLuint _floorTexture;
  GLuint _fishTexture;
  GLuint _texCoordSlot;
  GLuint _textureUniform;
  GLuint _vertexBuffer;
  GLuint _indexBuffer;
  GLuint _vertexBuffer2;
  GLuint _indexBuffer2;
}

@end
