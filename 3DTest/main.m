

#import <Cocoa/Cocoa.h>
#import <GLKit/GLKit.h>
#import <GLUT/GLUT.h>

#define DEBUG
 /*DEBUG is turned off*/
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

/*booleans*/
int isFilled = 0, lines = 0, flat = 0, n = 0;

/*floats for cube rotation*/
float rotate_x = 0.0, rotate_y = 0.0, move_z = 0.0;

float angle_x;

/*floats for object position*/
float oX = 0.0, oY = 0.0, oZ = 0.0;
/*cameraX, Y and Z only for teapot*/
float cameraX = 0.0, cameraY = 0.0, cameraZ = 0.0;

/*camera globals*/
float x = 0.5f, y = 0.5f, z = 2.5f;
float zoom, rotx, roty, tx, ty;


void drawCube(){
    
    /*movement controls*/
    glTranslatef(0, 0, move_z);
    
    /*rotate controls*/
    glRotatef(rotate_x, 0.0, 1.0, 0.0 );
    angle_x = sin(rotate_x);
    

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
        glVertex3f(0.0, 0.5, 0.0);
        

 
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
    if (isFilled == 0){
        glShadeModel(GL_SMOOTH);
        glDisable(GL_LIGHTING);
        glDisable(GL_LIGHT0);
        glDisable(GL_NORMALIZE);
        glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    }else{
        /* Enable lighting */
        glShadeModel(GL_SMOOTH);
        glEnable(GL_LIGHTING);
        glEnable(GL_LIGHT0);
        glEnable(GL_NORMALIZE);
    }
    
    for (x = -1; x <= 1; x += step){
        
        
        glBegin(GL_TRIANGLE_STRIP);
        glVertex3f(x , (sin(2*x)/5) , z); /*top left*/
        drawNormals();
        glVertex3f(x+step,(sin(2*(x+step))/5), z); /*top right*/
        drawNormals();
        glVertex3f(x, (sin(2*x)/5), z+step); /*bottom left*/
        drawNormals();
        glVertex3f(x+step, (sin(2*(x+step))/5), z+step); /*bottom right*/
        drawNormals();
        glEnd();
        
        for (z = -1; z <= 1; z += step){
            
            
            glBegin(GL_TRIANGLE_STRIP);
            glVertex3f(x , (sin(2*x)/5) ,z); /*top left*/
            drawNormals();
            glVertex3f(x+step,(sin(2*(x+step))/5), z); /*top right*/
            drawNormals();
            glVertex3f(x, (sin(2*x)/5), z+step); /*bottom left*/
            drawNormals();
            glVertex3f(x+step, (sin(2*(x+step))/5), z+step); /*bottom right*/
            drawNormals();
            glEnd();
        }
    }
    
    
    glutPostRedisplay();
    
}


void idle(){
    
    glutPostRedisplay();
    
    
}

void reshape(int width, int height){

#ifdef DEBUG
    printf("Width: %i, Height: %i\n", width, height);
#endif
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
            oZ -=0.01;
            move_z -=0.01;
            /*move_z -= 0.01 * cos(angle_x);*/
#ifdef DEBUG
            printf ("move_z is %f\n", move_z);
#endif
            break;
            
        case 's': /* down */
            oZ +=0.01;
            move_z += 0.01;
#ifdef DEBUG
            printf ("move_z is %f\n", move_z);
#endif
            break;
            
        case 'a': /* left */
            oX -= 0.01;
            rotate_x += 1.0;
#ifdef DEBUG
            printf ("rotate_x is %f\n", rotate_x);
            printf ("angle_x is %f\n", angle_x);
#endif
            break;
            
        case 'd': /* right */
            oX += 0.01;
            rotate_x -= 1.0;
            printf ("rotate_x is %f\n", rotate_x);
            printf ("angle_x is %f\n", angle_x);
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
    
    rotx = x;
    roty = y;
    printf("x: %i,y: %i\n", x, y);
    
    
        glutPostRedisplay();
    
}

void mouse(int button, int state, int x, int y){
    
    if (button == GLUT_LEFT_BUTTON){
    
    }
    
    if (button == GLUT_RIGHT_BUTTON){
    
        
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
    glTranslatef(oX, oY, oZ);
    
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
    gluLookAt(x,y,-z, oX,oY,-oZ, 0,1,0);
    
    glTranslatef(0,0, -zoom);
    glTranslatef(tx, ty, 0);
    glRotatef(rotx, 1, 0, 0);
    glRotatef(roty, 0, 1, 0);
    
    /*push and pop matrix*/
    glPushMatrix();
    /* Put functions to draw in here */
    drawLines();
    drawSurface();
    drawCube();
    /*drawTeapot();*/
    /*drawSineWave();*/
    glPopMatrix();
    
    
    int err;
    const GLubyte *errString;
    
    if ((err = glGetError()) != GL_NO_ERROR){
        errString = gluErrorString(err);
        fprintf(stderr, "OpenGL Error: %s\n", errString);
    }
    glutSwapBuffers();
}

int main(int argc, char **argv){
    
    
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH);
    
    glutInitWindowSize(800, 600);
    glutInitWindowPosition(200, 100);
    glutCreateWindow("James Snee I3D Assignment 1");
    
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





