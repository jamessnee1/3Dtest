//
//  main.m
//  3DTest
//
//  Created by James Snee on 3/04/2014.
//  Copyright (c) 2014 JSS Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <GLKit/GLKit.h>
#import <GLUT/GLUT.h>

#define DEBUG
#undef DEBUG /*DEBUG is turned off*/
#define PI 3.14

/*Function Prototypes*/
void reshape(int width, int height);
void idle();
void drawLines();
void drawSineWave();
void drawCube();
void drawSurface();
void drawNormals();
void mouseMove(int x, int y);
void mouse(int button, int state, int x, int y);
void keyDown(unsigned char key, int x, int y);
void keyUp(unsigned char key, int x, int y);
void drawTeapot();

/*Global variables for x/y/z coords*/
float cameraX = 0.0, cameraY = 0.0, cameraZ = 0.0;
/*booleans*/
int isFilled = 0, lines = 0, flat = 0, n = 0;

/*floats for rotation*/
float rotate_x = 0.0, rotate_y = 0.0, move_z = 0.0;

/*floats for teapot position*/
float tX = 0.0, tY = 0.0, tZ = 0.0;

/*camera globals*/
/*Angle of rotation for camera direction*/
float angle = 0.0;
/*vector representing camera direction*/
float lx =0.0f, ly = 0.0f, lz = 0.0f;
/*position of camera*/
float x = 0.5f, y = 0.5f, z = 2.5f;
float deltaAngle = 0.0f;
int xOrigin = -1, zOrigin = -1;


void drawCube(){
    
    
    /*rotate controls*/
    glRotatef(rotate_x, 1.0, 0.0, 0.0 );
    glRotatef(rotate_y, 0.0, 1.0, 0.0 );

    
    
    /*movement controls*/
    glTranslatef(0, 0, move_z);
 

    /*Front side*/
    glBegin(GL_POLYGON);
    glVertex3f( -0.1, -0.1, -0.1);
    glVertex3f( -0.1,  0.1, -0.1);
    glVertex3f(  0.1,  0.1, -0.1);
    glVertex3f(  0.1, -0.1, -0.1);
    glEnd();
    
    /*Back side*/
    glBegin(GL_POLYGON);
    glVertex3f(  0.1, -0.1, 0.1 );
    glVertex3f(  0.1,  0.1, 0.1 );
    glVertex3f( -0.1,  0.1, 0.1 );
    glVertex3f( -0.1, -0.1, 0.1 );
    glEnd();
    
    /*Right side*/
    glBegin(GL_POLYGON);
    glVertex3f( 0.1, -0.1, -0.1 );
    glVertex3f( 0.1,  0.1, -0.1 );
    glVertex3f( 0.1,  0.1,  0.1 );
    glVertex3f( 0.1, -0.1,  0.1 );
    glEnd();
    
    /*Left side*/
    glBegin(GL_POLYGON);
    glVertex3f( -0.1, -0.1,  0.1 );
    glVertex3f( -0.1,  0.1,  0.1 );
    glVertex3f( -0.1,  0.1, -0.1 );
    glVertex3f( -0.1, -0.1, -0.1 );
    glEnd();
    
    /*Top side*/
    glBegin(GL_POLYGON);
    glVertex3f(  0.1,  0.1,  0.1 );
    glVertex3f(  0.1,  0.1, -0.1 );
    glVertex3f( -0.1,  0.1, -0.1 );
    glVertex3f( -0.1,  0.1,  0.1 );
    glEnd();
    
    /*Bottom side*/
    glBegin(GL_POLYGON);
    glVertex3f(  0.1, -0.1, -0.1 );
    glVertex3f(  0.1, -0.1,  0.1 );
    glVertex3f( -0.1, -0.1,  0.1 );
    glVertex3f( -0.1, -0.1, -0.1 );
    glEnd();
    
    
    /*draw lines on cube*/
    if (lines == 1){
        drawLines();
    }
    
    glutPostRedisplay();

    
}

void drawNormals(){
    
    if (n == 1){
        
        glColor3f(1, 1, 0);
        glVertex3f(0, 0, 0);
        glVertex3f(0, 0.001, 0);
        
    }
    
    glColor3f(1, 1, 1);
    glutPostRedisplay();
    
}

void drawSurface(){
    
    float x1 = 0.1, y1 = 0.1, x2 = -0.1, y2 = -0.1, step = 0.2;
    float x = -1.0, y = -0.2, z = -1.0;
    
    /*glRotatef(cameraX, 0, 1, 0);
    glRotatef(cameraY, 1, 0, 0);*/
    
    glColor3f(1, 1, 1);
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    /* Enable lighting */
    /*glEnable(GL_LIGHTING);
     glEnable(GL_LIGHT0);
     glEnable(GL_LIGHT1);
     glEnable(GL_NORMALIZE);*/
    
    
    for (x = -1; x <= 1; x += step){
        
        
        glBegin(GL_TRIANGLE_STRIP);
        glVertex3f(x , y , z); /*top left*/
        drawNormals();
        glVertex3f(x+step,y, z);  /*top right*/
        
        glVertex3f(x, y, z+step); /*bottom left*/
        
        glVertex3f(x+step, y, z+step); /*bottom right*/
        
        glEnd();
        
        for (z = -1; z <= 1; z += step){
            
            
            glBegin(GL_TRIANGLE_STRIP);
            glVertex3f(x , y ,z); /*top left*/
            
            glVertex3f(x+step,y, z);  /*top right*/
            
            glVertex3f(x, y, z+step); /*bottom left*/
            
            glVertex3f(x+step, y, z+step); /*bottom right*/
            
            glEnd();
        }
    }
    
    
    glutPostRedisplay();
    
}


void idle(){
    
    glutPostRedisplay();
    
    
}

void reshape(int width, int height){
    
    printf("Width: %i, Height: %i\n", width, height);
    glViewport(0, 0, width, height);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    /*gluPerspective(fovy, aspect, znear,zfar)*/
    gluPerspective(75, ((float)width / (float) height), 0.01, 100);
    glMatrixMode(GL_MODELVIEW);
    
    glutPostRedisplay();
    
}

void keyDown(unsigned char key, int x, int y){
    
    printf("Key: %c\n", key);
    
    switch(key){
        case 27: /* escape key */
            printf("Key: Escape\n");
            exit(EXIT_SUCCESS);
            break;
        case 'p':
            if (isFilled == 0){
                isFilled = 1;
            }
            else {
                isFilled = 0;
            }
            break;
        case 'o':
            if (lines == 0){
                lines = 1;
                glutPostRedisplay();
            }
            else {
                lines = 0;
                glutPostRedisplay();
            }
            break;
            
        case 'w': /* up */
            tZ -=0.01;
            move_z -=0.01;
            printf ("move_z is %f\n", move_z);
            break;
            
        case 's': /* down */
            tZ +=0.01;
            move_z += 0.01;
            printf ("move_z is %f\n", move_z);
            break;
            
        case 'a': /* left */
            tX -= 0.01;
            rotate_y += 1.0;
            printf ("rotate_x is %f\n", rotate_y);
            break;
            
        case 'd': /* right */
            tX += 0.01;
            rotate_y -= 1.0;
            printf ("rotate_x is %f\n", rotate_y);
            break;
            
        case 'm': /*for shader model*/
            if (flat == 0){
                flat = 1;
            }
            else {
                flat = 0;
            }
            break;
            
        case 'n': /*normals*/
            if (n == 0){
                n = 1;
            }
            else {
                n = 0;
            }
            break;
            
        case 'q':
            exit(EXIT_SUCCESS);
            break;
            
    }
    
}

void keyUp(unsigned char key, int x, int y){
    
}

void mouseMove(int x, int y){
    
    printf("DeltaAngle: %f\n", deltaAngle);
    printf("x: %i\n", x);
    printf("y: %i\n", y);
    
    if (xOrigin >= 0){
    
        deltaAngle = (x - xOrigin ) * 0.001f;
        
        lx = sin(angle + deltaAngle);
        lz = -cos(angle + deltaAngle);
        
        
        
    }
    
    if (zOrigin <= 0){
    
        deltaAngle = (y - zOrigin) * 0.001f;
        ly = -tan(angle + deltaAngle);
    }
    
    /*cameraX = x;
    cameraY = y;
    printf("Mouse x = %i, Mouse y = %i\n", x, y);*/
    glutPostRedisplay();
    
}

void mouse(int button, int state, int x, int y){
    
    if (button == GLUT_LEFT_BUTTON){
    
        if (state == GLUT_UP){
        
            angle += deltaAngle;
            xOrigin = -1;
        
        }
        else {
        
            xOrigin = x;
        
        }
    }
    
    if (button == GLUT_RIGHT_BUTTON){
    
        if (state == GLUT_UP){
            
            angle += deltaAngle;
            zOrigin = -1;
        
        }
    
    }
    glutPostRedisplay();
}

void drawTeapot(){
    
    
    
    /* Enable lighting */
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    glEnable(GL_LIGHT1);
    glEnable(GL_NORMALIZE);
    
    
    /*pick the shader model*/
    if (flat == 1){
        glShadeModel(GL_FLAT);
    }
    else {
        glShadeModel(GL_SMOOTH);
    }
    
    
    /* Draw white teapot wireframe */
    glColor3f(1,1,1);
    glTranslatef(0, 0, -1.0);
    glRotatef(cameraX, 0, 1, 0);
    glRotatef(cameraY, 1, 0, 0);
    
    /*change position of teapot*/
    glTranslatef(tX, tY, tZ);
    
    /*Keyboard controls*/
    
    if (isFilled == 0){
        glutWireTeapot(0.5);
    }
    else{
        glutSolidTeapot(0.5);
    }
    
    /*draw the lines on the teapot*/
    if (lines == 1){
        /* Disable lighting */
        glDisable(GL_LIGHTING);
        glDisable(GL_LIGHT0);
        glDisable(GL_LIGHT1);
        glDisable(GL_NORMALIZE);
        drawLines();
        
    }
    
    glutPostRedisplay();
}

void drawLines(){
    
    /* Draw Y axis here, green line */
    glBegin(GL_LINES);
    glColor3f(0,1,0);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(0.0, 1.0, 0.0);
    
    glEnd();
    
    /* Draw X axis here, red line */
    glBegin(GL_LINES);
    glColor3f(1,0,0);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(1.0, 0.0, 0.0);
    
    glEnd();
    
    /* Draw Z axis here, blue line */
    glBegin(GL_LINES);
    glColor3f(0,0,1);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(0.0, 0.0, 1.0);
    
    /* Reset the colour to white */
    glColor3f(1,1,1);
    glEnd();
    
}

void drawSineWave(){
    
    
    float x1, x2, y1, y2;
    int i = 0, size = 20, amplitude = 1;
    
    glBegin(GL_LINES);
    glColor3f(1.0, 1.0, 1.0);
    for(i = -20.0; i < size; i++){
        
#ifdef DEBUG
        printf("In loop number %i\n", i);
#endif
        x1 = (float)i / size;
#ifdef DEBUG
        printf("x1 is %f\n", x1);
#endif
        x2 =((float)i+1.0) / size;
#ifdef DEBUG
        printf("x2 is %f\n", x2);
#endif
        y1 = sin(x1 * amplitude * PI);
        y2 = sin(x2 * amplitude * PI);
        glVertex2f(x1, y1);
        glVertex2f(x2, y2);
        
    }
    
    glEnd();
    
}

void display()
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    /*set camera orientation*/
    glMatrixMode(GL_MODELVIEW);
    
    /* load identity*/
    glLoadIdentity();
    
    /*gluLookAt(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ)*/
    /*this function controls the camera*/
    gluLookAt(x,y,z, x+lx,y+ly,move_z, 0,1,0);
    
    /* Put functions to draw in here */
    drawLines();
    drawSurface();
    drawCube();
    /*drawTeapot();*/
    /*drawSineWave();*/
    
    
    
    int err;
    const GLubyte *errString;
    
    if ((err = glGetError()) != GL_NO_ERROR){
        errString = gluErrorString(err);
        fprintf(stderr, "OpenGL Error: %s\n", errString);
    }
    glutSwapBuffers();
}

int main(int argc, const char * argv[]){
    
    
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH);
    
    glutInitWindowSize(800, 600);
    glutInitWindowPosition(200, 100);
    glutCreateWindow("3D Test");
    
    /* In this program these OpenGL calls only need to be done once,
     so they are in main rather than display. */
    glOrtho(-1, 1, -1, 1, -1, 1);
    glEnable(GL_DEPTH_TEST);
    
    /*Glut callback functions*/
    glutIdleFunc(idle);
    glutKeyboardFunc(keyDown);
    glutMotionFunc(mouseMove);
    glutMouseFunc(mouse);
    glutDisplayFunc(display);
    glutReshapeFunc(reshape);
    glutMainLoop();
    
    return EXIT_SUCCESS;
    

}





