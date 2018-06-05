import java.util.Map;

class Predator {
  Node node;
  int grabsMouseColor;
  int avatarColor;
  // fields
  Vector position, velocity, acceleration, rotation; // position, velocity, and acceleration in
  // a vector datatype
  float neighborhoodRadius; // radius in which it looks for fellow Predators
  float maxSpeed = 4; // maximum magnitude for the velocity vector
  float maxSteerForce = .1f; // maximum magnitude of the steering vector
  float sc = 3; // scale factor for the render of the Predator
  float flap = 0;
  float t = 0;
  float vChange=0.1;


  Predator(Vector inPos) {
    grabsMouseColor = color(0, 0, 255);
    avatarColor = color(255, 255, 0);
    position = new Vector();
    position.set(inPos);
 
    node = new Node(scene) {
      // Note that within visit() geometry is defined at the
      // node local coordinate system.
      @Override
      public void visit() {
        if (animate)
          run(flock);
        render();
      }

      // Behaviour: tapping over a Predator will select the node as
      // the eye reference and perform an eye interpolation to it.
      @Override
      public void interact(TapEvent event) {
        if (avatar != this && scene.eye().reference() != this) {
          avatar = this;
          scene.eye().setReference(this);
          scene.interpolateTo(this);
        }
      }
    };
    node.setPosition(new Vector(position.x(), position.y(), position.z()));
    velocity = new Vector(random(-1, 1), random(-1, 1), random(1, -1));
    acceleration = new Vector(0, 0, 0);
    rotation= new Vector(-1,0,0);
    
    neighborhoodRadius = 100;
  }

  public void run(ArrayList<Boid> boids) {
    t += .1;
    flap = 10 * sin(t);
    // acceleration.add(steer(new Vector(mouseX,mouseY,300),true));
    // acceleration.add(new Vector(0,.05,0));
    if (avoidWalls) {
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), flockHeight, position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), 0, position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(flockWidth, position.y(), position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(0, position.y(), position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), position.y(), 0)), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), position.y(), flockDepth)), 5));
    }
    //lock(boids,predators);
    move();
    checkBounds();
  }

  Vector avoid(Vector target) {
    Vector steer = new Vector(); // creates vector for steering
    steer.set(Vector.subtract(position, target)); // steering vector points away from
    steer.multiply(1 / sq(Vector.distance(position, target)));
    return steer;
  }

  //-----------behaviors---------------
/*
  void flock(ArrayList<Boid> boids, ArrayList<Predator> Predators) {

    Vector posBoid = new Vector(0, 0, 0);
    int boidCount = 0;      

      for (int x=0;x<boids.size();++x){
       Boid boid = boids.get(x);
       float boidDistance = Vector.distance(position, boid.position);
       if (boidDistance > 0 && boidDistance <= neighborhoodRadius) {
        posBoid.add(boid.position);
        boidCount++;
      }
        
     if (boidCount >0){
     posBoid.divide((float)boidCount);
     posBoid.limit(maxSteerForce);
     posBoid.subtract(position);
    }
      
      acceleration.add(Vector.multiply(posBoid, 1));
    }
  }
*/
  void move() {
    velocity.add(acceleration); // add acceleration to velocity
    if(up){
      if(rotation.y()>=-1){
        rotation.add(new Vector(0, -vChange, 0)); 
      }
    }
    if(down){
       if(rotation.y()<=1){
        rotation.add(new Vector(0, vChange, 0)); 
      }
    }
    if(left){

      if(rotation.x()<=-1 && rotation.z()<=1){
        rotation.add(new Vector(0, 0, vChange)); 
      }else if (rotation.z()>=1 && rotation.x()<=1){
        rotation.add(new Vector(vChange, 0,0)); 
      }else if(rotation.x()>=1 && rotation.z()>=-1){
        rotation.add(new Vector(0, 0,-vChange)); 
      }else if(rotation.z()<=-1 && rotation.x()>=-1){
        rotation.add(new Vector(-vChange, 0,0)); 
      }
        
      
    }
    if(right){
      if(rotation.x()<=-1 && rotation.z()>=-1){
        rotation.add(new Vector(0, 0, -vChange)); 
      }else if (rotation.z()<=-1 && rotation.x()<=1){
        rotation.add(new Vector(vChange, 0,0)); 
      }else if(rotation.x()>=1 && rotation.z()<=1){
        rotation.add(new Vector(0, 0,vChange)); 
      }else if(rotation.z()>=1 && rotation.x()>=-1){
        rotation.add(new Vector(-vChange, 0,0)); 
      }
    }

    velocity.add(rotation);
    velocity.limit(maxSpeed); // make sure the velocity vector magnitude does not
    // exceed maxSpeed
    position.add(velocity); // add velocity to position
    node.setPosition(position);
    node.setRotation(Quaternion.multiply(new Quaternion(new Vector(0, 1, 0), atan2(-velocity.z(), velocity.x())),
      new Quaternion(new Vector(0, 0, 1), asin(velocity.y() / velocity.magnitude()))));
    acceleration.multiply(0); // reset acceleration
  }

  void checkBounds() {
    if (position.x() > flockWidth)
      position.setX(0);
    if (position.x() < 0)
      position.setX(flockWidth);
    if (position.y() > flockHeight)
      position.setY(0);
    if (position.y() < 0)
      position.setY(flockHeight);
    if (position.z() > flockDepth)
      position.setZ(0);
    if (position.z() < 0)
      position.setZ(flockDepth);
  }

  void render() {
    pushStyle();

    // uncomment to draw predator axes
    //scene.drawAxes(10);

    int kind = TRIANGLES;
    strokeWeight(2);
    stroke(color(129,84,202));
    fill(color(129,84,202));

    // visual modes
    switch(mode) {
    case 1:
      noFill();
      break;
    case 2:
      noStroke();
      break;
    case 3:
      strokeWeight(3);
      kind = POINTS;
      break;
    }

    // highlight predator under the mouse
    if (node.track(mouseX, mouseY)) {
      noStroke();
      fill(grabsMouseColor);
    }

    // highlight avatar
    if (node == avatar) {
      noStroke();
      fill(avatarColor);
    }

    //draw predator
    beginShape(kind);
    vertex(3 * sc, 0, 0);
    vertex(-3 * sc, 2 * sc, 0);
    vertex(-3 * sc, -2 * sc, 0);

    vertex(3 * sc, 0, 0);
    vertex(-3 * sc, 2 * sc, 0);
    vertex(-3 * sc, 0, 2 * sc);

    vertex(3 * sc, 0, 0);
    vertex(-3 * sc, 0, 2 * sc);
    vertex(-3 * sc, -2 * sc, 0);

    vertex(-3 * sc, 0, 2 * sc);
    vertex(-3 * sc, 2 * sc, 0);
    vertex(-3 * sc, -2 * sc, 0);
    endShape();

    popStyle();

  }
  
  
  
}