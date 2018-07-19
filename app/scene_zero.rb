class SceneZero < SKScene
  include ScreenSizes

  attr_accessor :root, :square, :square_two, :graph, :sprite_pool

  # This method is invoked when a scene is presented.
  def didMoveToView _
    @graph = {
      camera: {
        world_width: 300,
        world_height: 1000,
        scale: 1,
        children: {
          
        }
      }
    }

    @sprite_pool = {}

    # Set the aspect ratio.
    self.scaleMode = SKSceneScaleModeAspectFit

    # Set the background color to white.
    self.backgroundColor = UIColor.whiteColor

    # Add sprite (which will be updated in the render loop).
    # Assets are located inside of the resources folder.
    add_sprite id: :first_square,
               x: @graph[:camera][:world_width].fdiv(2),
               y: @graph[:camera][:world_height].fdiv(2)

    # @square_two = add_sprite device_screen_width.fdiv(2),
    #                          device_screen_height.fdiv(2) - 100,
    #                          'square.png'

    @camera ||= SKNode.new
    if iPad?
      @camera.xScale = 0.70
      @camera.yScale = 0.70
      @camera.position = CGPointMake(125, 40)
    elsif iPhoneX?
      @camera.xScale = 0.98
      @camera.yScale = 0.98
      @camera.position = CGPointMake(4, 45)
    elsif iPhone6?
      @camera.xScale = 0.88
      @camera.yScale = 0.88
      @camera.position = CGPointMake(40, 40)
    elsif iPhone6Plus?
      @camera.xScale = 0.88
      @camera.yScale = 0.88
      @camera.position = CGPointMake(40, 40)
    elsif iPhone5?
      @camera.xScale = 0.88
      @camera.yScale = 0.88
      @camera.position = CGPointMake(20, 15)
    end

    addChild @camera
    $scene = self
  end

  # This delegate is invoked when the scene receives a touch event.
  # When this class was constructed in GameViewController. A property was
  # set that linked this scene with the parent (being the GameViewController).
  # Using this wireup, we are telling GameViewController to present scene three.
  # def touchesBegan touches, withEvent: _
  #   root.present_scene_three
  # end

  def add_sprite opts
    id = opts[:id]
    x = opts[:x] || device_screen_width.fdiv(2)
    y = opts[:y] || device_screen_height.fdiv(2)
    @graph[:camera][:children][id] = {
      id: id,
      x: x,
      y: y
    }
  end

  # def add_sprite x, y, path
  #   # Sprites are created using a texture. So first we have to create a
  #   # texture from the png in the /resources directory.
  #   texture = SKTexture.textureWithImageNamed path

  #   # Then we can create the sprite and set it's location.
  #   sprite = SKSpriteNode.spriteNodeWithTexture texture
  #   sprite.position = CGPointMake x, y
  #   addChild sprite
  #   sprite
  # end

  # This method is invoked by SpriteKit. Generally speaking, the currentTime isn't really used.
  # iOS devices are designed to have a fixed framerate of 60. If there is a frame rate drop. SpriteKit
  # will attempt to catch up. There are times when the OS will decide to run your game at 30 fps. Which,
  # again is rare. Don't get too worried about performance of framerates. Just assume that your game will
  # run at 60 fps and do all your computation according to this framerate. The `update` method is the heart
  # of a sprite kit scene.
  #
  # Oh and also. The simulator is really bad at mantaining 60 fps and shouldn't be used as an indicator
  # to how your app will perform. You'll have to enroll in the Apple Developer program to deploy to an
  # actual device (which costs $99 per year). If you start getting serious with your game, definitely
  # sign up for the program and start deploying to a real device.
  def update currentTime
    @graph[:camera][:children].each do |key, sprite|
      id = sprite[:id]

      if !@sprite_pool[id] 
        texture = SKTexture.textureWithImageNamed 'square.png'
        sprite_node = SKSpriteNode.spriteNodeWithTexture texture
        sprite_node.name = id.to_s
        @camera.addChild sprite_node
        @sprite_pool[id] = sprite_node
      end

      @sprite_pool[id].position = CGPointMake sprite[:x], sprite[:y]
    end

    @sprite_pool.each do |key, sprite_node|
      if !@graph[:camera][:children][key]
        @camera.removeChild sprite_node
      end
    end

    # 300 = x * world_width
    # 667 = x * world_height
    safe_margin = 30
    camera_scale_x = (device_screen_width - (safe_margin * 2)).fdiv(
                       @graph[:camera][:world_width])
    camera_scale_y = (device_screen_height - (safe_margin * 2)).fdiv(
                       @graph[:camera][:world_height])
    camera_scale = camera_scale_x
    # puts "x: ", camera_scale_x
    # puts "y: ", camera_scale_y
    if camera_scale_y < camera_scale_x
      camera_scale = camera_scale_y
    end
    @camera.xScale = camera_scale * @graph[:camera][:scale]
    @camera.yScale = camera_scale * @graph[:camera][:scale]
    real_width = @graph[:camera][:world_width] * camera_scale
    real_height = @graph[:camera][:world_height] * camera_scale
    new_camera_x = (device_screen_width - real_width).fdiv(2)
    new_camera_y = (device_screen_height - real_height).fdiv(2)
    @camera.position = CGPointMake(new_camera_x, new_camera_y)
  end
end
