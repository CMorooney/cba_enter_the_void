import peasy.*;
import processing.video.*;

PeasyCam cam;
Movie movie;

PVector[][] globe;
int total = 8;// sphere detail/resolution/mesh count

float m1 = 2.4;
float m1delta = 0;

float t1 = 0;
float t2 = 0;
float t3 = 0;

void setup() {
  size(1280, 720, P3D);
  cam = new PeasyCam(this, 20);
  frameRate(30);
  movie = new Movie(this, "entrr.mp4");
  movie.frameRate(30);
  movie.play();
  while (movie.width == 0 | movie.height == 0)  delay(10);
  globe = new PVector[total+1][total+1];
}

void movieEvent (Movie movie) {
  movie.read();
}

float supershape(float theta, float m, float n1, float n2, float n3) {  
  float a = 1;//shape constants h/z 'squishing'
  float b = 1;
  
  float t1 = abs((1/a) * cos(m * theta / 4));
  t1 = pow(t1, n2);
  
  float t2 = abs((1/b) * sin(m * theta / 4));
  t2 = pow(t2, n3);
  
  float t3 = t1 + t2;
  float r = pow(t3, -1/n1);
  
  return r;
}

void draw () {
  //movie.loadPixels();
  
  if(frameCount % 1800 == 0) {
    total += 1;
    globe = new PVector[total+1][total+1];
  }
  m1 = map(sin(m1delta), -1, 1, -33.45, 33.188);
  m1delta += .015;
  
  noStroke();
  background(movie);
  lights();
  
  float r = 50;
  
  rotateY(t1);
  rotateX(t2);
  rotateZ(t3);
  
  t1 += random(-.001, 0.002);
  t2 += random(-.001, 0.002);
  t3 += random(-.001, 0.002);
  
  // build the globe points
  for (int i = 0; i <= total; i++) {
    float lat = map(i, 0, total, -HALF_PI, HALF_PI);
    float r2 = supershape(lat, m1, 45.5, 20.23, -63.43);
    
    for(int j = 0; j <= total; j++) {
      float lon = map(j, 0, total, -PI, PI);
      
      float r1 = supershape(lon, 2, 7.4, 8.7, 20.85);
      
      float x = r * r1 * cos(lon) * r2 * cos(lat);
      float y = r * r1 * sin(lon) * r2 * cos(lat);
      float z = r * r2 * sin(lat);
      globe[i][j] = new PVector(x, y, z);
    }
  }
 
    noFill();
  
    // create globe with triangle meshes
    for(int i = 0; i < total; i++) {
      beginShape(TRIANGLE_STRIP);
    
      for(int j = 0; j < total + 1; j++) {
        PVector v1 = globe[i][j];
        stroke(255);
        strokeWeight(2);
        vertex(v1.x, v1.y, v1.z);
      
        PVector v2 = globe[i+1][j];
        stroke(255);
        vertex(v2.x, v2.y, v2.z);
      }
    
      endShape();
  }
}
