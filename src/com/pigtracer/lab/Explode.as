/*
funbyjohn.com

Fireworks! (237 lines excluding empty lines and comments.)
by Johannes Jensen, 2009

Click to produce a rocket and then it flies up into the
atmosphere and it explodes!
*/
package com.pigtracer.lab {
  import flash.geom.Point;
    // Import the needed classes.
    import flash.display.Stage;
    import flash.display.Sprite;
    import flash.display.Shape;
    import flash.display.GradientType;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.text.TextField;
    import flash.text.StyleSheet;

    // Set FPS to 30.
    [SWF(frameRate="30")]

  // Main class.
  public class Explode extends Sprite {
        // Allocate variables
        public var bg:Shape;
        public var rockets:Vector.<Rocket> = new Vector.<Rocket>;
        public var flames:Vector.<Fire> = new Vector.<Fire>;
        public var explosions:Vector.<Explosion> = new Vector.<Explosion>;
        public var snow:Shape;
        public var gradient:Matrix;
        public var txt:TextField;
        public var css:StyleSheet;
    //==========================================================================
    //  Properties
    //==========================================================================
    //----------------------------------
    //  isLaunch
    //----------------------------------
    private var _isLaunch:Boolean = false;
    public function get isLaunch():Boolean {
      return _isLaunch;
    }
    public function set isLaunch(value:Boolean):void {
      _isLaunch = value;
    }
    // Constructor
    public function Explode():void {
            // Create the background.
            bg = new Shape();
            bg.graphics.lineStyle(0, 0, 0);
            bg.graphics.beginFill(0x111111);
            //bg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight - 50);
            bg.graphics.drawRect(0, 0, 800, 550);
            bg.graphics.endFill();
            bg.visible = false;

            // Calculate a gradient that is 90 degrees.
            gradient = new Matrix();
            //gradient.createGradientBox(stage.stageWidth, 50, Math.PI / 2);
            gradient.createGradientBox(800, 50, Math.PI / 2);

            // Draw the snow at the bottom of the screen.
            snow = new Shape();
            snow.graphics.lineStyle(0, 0, 0);
            snow.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xBBBBBB], [1, 1], [0x2A, 0xFF], gradient);
            //snow.graphics.drawRect(0, 0, stage.stageWidth, 50);
            snow.graphics.drawRect(0, 0, 800, 50);
            //snow.y = stage.stageHeight - snow.height;
            snow.y = 550;

            // Create the CSS.
            css = new StyleSheet();
            css.setStyle('p', {
                fontSize: 12,
                fontFamily: 'Verdana',
                display: 'inline',
                color: '#FFFFFF'
            });

            // Create TextField and append CSS to it.
            txt = new TextField();
            txt.styleSheet = css;
            txt.x = 5;
            txt.y = 5;
            txt.width = 200;
            txt.height = 25;
            txt.textColor = 0xFFFFFF;
            txt.selectable = false;
            txt.htmlText = "";

            // Add the graphics to the scene.
            this.addChild(bg);
            this.addChild(snow);

            // Add the text, and assign throwFirework to run each time you click.
            // Attach main() to run every frame.
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(event:Event):void {
      stage.addChild(txt);
      stage.addEventListener(Event.ENTER_FRAME, main);
    }

        // Drop a rocket.
        public function throwFirework(mouseX, mouseY):void {

            if (!isLaunch) {
              return;
            }

            isLaunch = false;
            // Create the rocket.
            var rocket:Rocket = new Rocket(this, stage, rockets, flames, explosions, new Point(mouseX, mouseY));

            // Position the rocket @ the mouse's XY position.
            rocket.x = 0;
            rocket.y = 0;
            // Attach the rocket to the rockets vector.
            rockets.push(rocket);
        }
        public function th() {
           var rocket:Rocket = new Rocket(this, stage, rockets, flames, explosions, new Point(mouseX, mouseY));

            // Position the rocket @ the mouse's XY position.
            rocket.x = 0;
            rocket.y = 0;
            // Attach the rocket to the rockets vector.
            rockets.push(rocket);
        }

        // Main function - runs every frame.
        public function main(e:Event):void {
            // Allocate i, which will be used for looping.
            var i:int;

            // Loop through rockets vector and then animate each rocket.
            for(i = 0; i < rockets.length; i++) {
              trace("[Explode/main]");
                rockets[i].animation();
            }

            // Loop through flames vector and then animate each flame.
            for(i = 0; i < flames.length; i++) {
                flames[i].animation();
            }

            // Loop through explosions vector and then animate each explosion.
            for(i = 0; i < explosions.length; i++) {
                explosions[i].animation();
            }

            // Update the TextField.
            txt.htmlText = "<p>funbyjohn.com | <b>Rockets:</b> " + rockets.length + ", <b>flames:</b> " + flames.length + ", <b>fireworks:</b> " + explosions.length + " ≈ " + (rockets.length + flames.length + explosions.length) + " <b>particle" + ((rockets.length + flames.length + explosions.length) == 1 ? "" : "s") + "</b>.</p>";
        }
    }
}
	import flash.geom.Point;

// Import the needed classes.
import flash.display.Stage;
import flash.display.Sprite;
import flash.display.Shape;
import flash.display.GradientType;
import flash.events.Event;

// base class Particle
class Particle extends Shape {
    // Container variables which will link to the main Sprite and to the stage.
    public var ref:Sprite;
    public var stageRef:Stage;

    // Constructor
    public function Particle(_ref:Sprite, _stage:Stage):void {
        // Assign _ref & _stage as linkers to Sprite, stage.
        ref = _ref;
        stageRef = _stage;

        // Draw the particle.
        draw();

        // Cache it as a Bitmap so it doesn't render every frame unless it's changed.
        this.cacheAsBitmap = true;

        // Add the particle to the main Sprite.
        ref.addChild(this);
    }

    // Converts an angle to radians.
    public function angleRadians(angle:Number):Number {
        return (angle * Math.PI) / 180;
    }

    // These are to be overridden.
    public function draw():void {}
    public function animation():void {}

    // Remove particle from main Sprite and then removes it from it's parent vector.
    public function cleanUp(vector:*):void {
        ref.removeChild(this);
        vector.splice(vector.indexOf(this), 1);
    }
}

// Rockets that explode and you see the fireworks.
class Rocket extends Particle {
    // Allocate variables
    public var acceleration:Number = 0.3;
    public var velocity:Number = acceleration;
    public var explosion:Number = acceleration * (30 + Math.random() * 22);
    public var gravity:Number = 0;
    public var steer:Number;
    public var h:Number;
    public var sent:Boolean = false;
    public var rocketsRef:Vector.<Rocket>;
    public var flamesRef:Vector.<Fire>;
    public var explosionsRef:Vector.<Explosion>;
    public var flameRate:int = 2;
    public var flameInt:int = flameRate;

    private var target:Point;

    // Constructor
    public function Rocket(_ref:Sprite, _stage:Stage, _rockets:Vector.<Rocket>, _flames:Vector.<Fire>, _explosions:Vector.<Explosion>, target:Point):void {
        // Which direction it'll fly.
        steer = (Math.random() * 3) - 1.5;

        this.target = target;
        // Assign linkers.
        rocketsRef = _rockets;
        flamesRef = _flames;
        explosionsRef = _explosions;

        // Set h to the point where the rocket hits the ground.
        h = _stage.stageHeight - 50;

        // Run Particle() constructor.
        super(_ref, _stage);
    }

    // Draws the rocket.
    public override function draw():void {
        this.graphics.lineStyle(0, 0, 0, true);

        // body
        this.graphics.beginFill(0x777777);
        this.graphics.moveTo(-5, 15);
        this.graphics.lineTo(5, 15);
        this.graphics.lineTo(5, -7.5);
        this.graphics.lineTo(0, -15);
        this.graphics.lineTo(-5, -7.5);
        this.graphics.lineTo(-5, 15);
        this.graphics.endFill();

        // left wing
        this.graphics.beginFill(0x900000);
        this.graphics.moveTo(-5, 15);
        this.graphics.lineTo(-12, 15);
        this.graphics.lineTo(-5, 8);
        this.graphics.lineTo(-5, 15);
        this.graphics.endFill();

        // right wing
        this.graphics.beginFill(0x900000);
        this.graphics.moveTo(5, 15);
        this.graphics.lineTo(12, 15);
        this.graphics.lineTo(5, 8);
        this.graphics.lineTo(5, 15);
        this.graphics.endFill();
    }

    // Animate the rocket.
    public override function animation():void {
        // Is the rocket sent out?

          // Steer the rocket's rotation with the steer variable.
          this.rotation += steer;

          // Move the rocket.
          var v:Point = target.subtract(new Point(this.x, this.y));
          this.x += v.x * 0.5; //* Math.cos(angleRadians(this.rotation - 90));
          this.y += v.y * 0.5; //* Math.sin(angleRadians(this.rotation - 90));

          // Accelerate the rocket.
          velocity += acceleration;

          // Is it time for a flame to come out?
          if(flameInt % flameRate == 0) {
              // Allocate flame.
              var flame:Fire = new Fire(ref, stageRef, angleRadians(this.rotation + 90 + ((Math.random() * 20) - 10)), flamesRef);

              // Place flame.
              flame.x = this.x + (15 * Math.cos(angleRadians(this.rotation + 90)));
              flame.y = this.y + (15 * Math.sin(angleRadians(this.rotation + 90)));

              // Add the flame to the flames vector.
              flamesRef.push(flame);
          }

          flameInt++;

          // Did the rocket fly out of the screen? Make it come out at the other side!
          if(this.x < 0) this.x = stage.stageWidth;
          if(this.x > stage.stageWidth) this.x = 0;

          // Is it time to explode yet?
          //if(velocity >= explosion) {
          var sub:Point = target.subtract(new Point(this.x, this.y));
          if(sub.length <= 0.5) {
              // Add an explosion to the explosions vector.
              explosionsRef.push(new Explosion(ref, stageRef, explosionsRef, this.x, this.y));

              // Remove the rocket from the main Sprite and removes it from the rockets vector.
              cleanUp(rocketsRef);

        }
    }
}

// The flame that comes out from the rockets.
class Fire extends Particle {
    // Allocate variables.
    public var colors:Vector.<uint> = new Vector.<uint>;
    public var picked:uint;
    public var radians:Number;
    public var flamesRef:Vector.<Fire>;

    // Constructor
    public function Fire(_ref:Sprite, _stage:Stage, _radians:int, _flames:Vector.<Fire>):void {
        // Assign linkers.
        flamesRef = _flames;
        radians = _radians;

        // Pick a random color for the fire. The options are: Red, orange and yellow.
        colors.push(0xFF0000, 0xFFD700, 0xFF4500);
        picked = colors[Math.floor(Math.random() * colors.length)];

        // Run Particle() constructor.
        super(_ref, _stage);
    }

    // Draws the flame.
    public override function draw():void {
        this.graphics.lineStyle(0, 0, 0);
        this.graphics.beginFill(picked);
        this.graphics.drawCircle(0, 0, 7);
        this.graphics.endFill();
    }

    // Animate the flame.
    public override function animation():void {
        // Move the flame.
        this.x += Math.cos(radians);
        this.y += Math.sin(radians);

        // Make it grow slowly.
        this.scaleX += 0.14;
        this.scaleY += 0.14;

        // Make it fade out.
        this.alpha -= 0.05;

        // Is it invisible? If so, delete it.
        if(this.alpha <= 0) {
            // Remove the flame from the main Sprite and remove it from the flames vector.
            cleanUp(flamesRef);
        }
    }
}

// The actual explosions from the rockets.
class Explosion extends Particle {
    // Allocate variables.
    public var explosionsRef:Vector.<Explosion>;
    public var lines:int = 10 + Math.random() * 12;
    public var size:Number = 0;
    public var total:int = 60 + Math.random() * 80;
    public var opacity:Number = 1;
    public var colors:Vector.<uint> = new Vector.<uint>;
    public var color:uint;
    public var thickness:Number = 3 + Math.random() * 6;

    // Constructor
    public function Explosion(_ref:Sprite, _stage:Stage, _explosions:Vector.<Explosion>, _x:Number, _y:Number):void {
        // Pick a random color for the explosion.
        colors.push(0xC83304, 0xF5AC31, 0xF2FF21, 0x04C316, 0x2D64ED, 0xF011F9, 0xFFFFFF);
        color = colors[Math.floor(Math.random() * colors.length)];

        // Assign linker.
        explosionsRef = _explosions;

        // Position the explosion.
        this.x = _x;
        this.y = _y;

        // Run Particle() constructor.
        super(_ref, _stage);
    }

    // Animate the explosion.
    public override function animation():void {
        // Clear the explosion, and set the thickness, color and opacity
        this.graphics.clear();
        this.graphics.lineStyle(thickness, color, opacity);

        // Make it grow smoothly.
        size -= (size - total) / 5;

        // Loop through angles and draw each line.
        for(var i:int = 0; i < lines; i++) {
            this.graphics.moveTo(0, 0);
            this.graphics.lineTo(size * Math.cos(angleRadians(360 / lines * i)), size * Math.sin(angleRadians(360 / lines * i)));
        }

        // Fade out.
        opacity -= 0.03;

        // Is it invisible? If so, delete it.
        if(opacity <= 0) {
            // Remove the explosion from the main Sprite and remove it from the explosions vector.
            cleanUp(explosionsRef);
        }
    }
}