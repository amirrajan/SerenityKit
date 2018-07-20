class SceneZero < SKScene
  include ScreenSizes

  attr_accessor :root, :square, :square_two, :graph, :sprite_pool

  # This method is invoked when a scene is presented.
  def didMoveToView _
    @graph = {
      device: {
        width: device_screen_width,
        height: device_screen_height,
        safe_margin_left: 30,
        safe_margin_right: 30,
        safe_margin_top: 30,
        safe_margin_bottom: 30
      },
      world: {
        width: 300,
        height: 1000
      },
      camera: {
        scale: 1,
        x: 0,
        y: 0,
        children: { }
      }
    }

    @sprite_pool = {}

    self.scaleMode = SKSceneScaleModeAspectFit
    self.backgroundColor = UIColor.whiteColor

    add_sprite id: :first_square,
               x: @graph[:world][:width].fdiv(2),
               y: @graph[:world][:height].fdiv(2)


    @camera ||= SKNode.new
    addChild @camera
    $scene = self
  end

  def add_sprite opts
    id = opts[:id]
    x = opts[:x] || 0
    y = opts[:y] || 0
    @graph[:camera][:children][id] = {
      id: id,
      x: x,
      y: y
    }
  end

  def crud_nodes
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
  end

  def transform_camera
    @camera.xScale = @graph[:camera][:scale]
    @camera.yScale = @graph[:camera][:scale]
    @camera.position = CGPointMake(@graph[:camera][:x],
                                   @graph[:camera][:y])
  end

  def camera_best_fit
    camera_scale_x = (device_screen_width -
                      (@graph[:device][:safe_margin_left] +
                       @graph[:device][:safe_margin_right])).fdiv(@graph[:world][:width])

    camera_scale_y = (device_screen_height -
                      (@graph[:device][:safe_margin_top] +
                       @graph[:device][:safe_margin_bottom])).fdiv(@graph[:world][:height])

    camera_scale = camera_scale_x

    if camera_scale_y < camera_scale_x
      camera_scale = camera_scale_y
    end

    real_width = @graph[:world][:width] * camera_scale
    real_height = @graph[:world][:height] * camera_scale
    best_fit_x = (device_screen_width - real_width).fdiv(2)
    best_fit_y = (device_screen_height - real_height).fdiv(2)

    @graph[:camera][:best_fit] = {
      scale: camera_scale,
      x: best_fit_x,
      y: best_fit_y
    }

    @graph[:camera][:scale] = @graph[:camera][:best_fit][:scale]
    @graph[:camera][:x] = @graph[:camera][:best_fit][:x]
    @graph[:camera][:y] = @graph[:camera][:best_fit][:y]
  end

  def update currentTime
    camera_best_fit
    crud_nodes
    transform_camera
  end
end
