//  This is Jeff LaMarche's GLProgram OpenGL shader wrapper class from his OpenGL ES 2.0 book.
//  A description of this can be found at his page on the topic:
//  http://iphonedevelopment.blogspot.com/2010/11/opengl-es-20-for-ios-chapter-4.html
//  I've extended this to be able to take programs as NSStrings in addition to files, for baked-in shaders

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface GLProgram : NSObject 
{
    NSMutableArray  *attributes;
    NSMutableArray  *uniforms;
    GLuint          program,
	vertShader, 
	fragShader;	
}

@property(readwrite, nonatomic) BOOL initialized;

- (instancetype)initWithVertexShaderString:(NSString *)vShaderString 
            fragmentShaderString:(NSString *)fShaderString;
- (instancetype)initWithVertexShaderString:(NSString *)vShaderString 
          fragmentShaderFilename:(NSString *)fShaderFilename;
- (instancetype)initWithVertexShaderFilename:(NSString *)vShaderFilename 
            fragmentShaderFilename:(NSString *)fShaderFilename;
- (void)addAttribute:(NSString *)attributeName;
- (GLuint)attributeIndex:(NSString *)attributeName;
- (GLuint)uniformIndex:(NSString *)uniformName;
@property (readonly) BOOL link;
- (void)use;
@property (readonly, copy) NSString *vertexShaderLog;
@property (readonly, copy) NSString *fragmentShaderLog;
@property (readonly, copy) NSString *programLog;
- (void)validate;
@end