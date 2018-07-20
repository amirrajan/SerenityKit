class SceneZero < SKScene
  include ScreenSizes

  attr_accessor :root, :square, :square_two, :game, :sprite_pool

  # This method is invoked when a scene is presented.
  def didMoveToView _
    @game = {
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
      state: {
        ticks_till_invader_move: 100
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

    @camera ||= SKNode.new
    addChild @camera
    $scene = self
  end

  def add_sprite opts
    id = opts[:id]
    x = opts[:x] || 0
    y = opts[:y] || 0
    @game[:camera][:children][id] = {
      id: id,
      x: x,
      y: y
    }
  end

  def create_invaders
    game_state = @game[:state]
    game_state[:invaders] ||= {}

    return if game_state[:invaders].length > 0

    game_state[:invaders][1] = { id: 1,
                                 y: @game[:world][:height],
                                 x: 0 }
  end

  def move_invader invader, world_width, ticks_till_invader_move
    invader[:move_countdown] ||= ticks_till_invader_move
    invader[:move_direction] ||= 1
    invader[:move_countdown] -= 1

    if invader[:move_countdown] <= 0
      invader[:move_countdown] = ticks_till_invader_move
      invader[:x] += 50 * invader[:move_direction]
      if (invader[:x] > world_width)
        invader[:move_direction] = -1
        invader[:y] -= 50
        invader[:x] -= 50
      elsif (invader[:x] < 0)
        invader[:move_direction] = 1
        invader[:y] -= 50
        invader[:x] += 50
      end
    end

    invader
  end

  def move_invaders
    game_state = @game[:state]
    game_state[:invaders].each do |id, invader|
      game_state[:invaders][id] =
        move_invader(invader,
                     @game[:world][:width],
                     game_state[:ticks_till_invader_move]
                    )
    end
  end

  def calc
    create_invaders
    move_invaders
    create_sprites
  end

  def create_sprites
    @game[:state][:invaders].each do |id, invader|
      add_sprite invader
    end
  end

  def crud_nodes
    @game[:camera][:children].each do |key, sprite|
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
      if !@game[:camera][:children][key]
        @camera.removeChild sprite_node
      end
    end
  end

  def transform_camera
    @camera.xScale = @game[:camera][:scale]
    @camera.yScale = @game[:camera][:scale]
    @camera.position = CGPointMake(@game[:camera][:x],
                                   @game[:camera][:y])
  end

  def camera_best_fit
    camera_scale_x = (device_screen_width -
                      (@game[:device][:safe_margin_left] +
                       @game[:device][:safe_margin_right])).fdiv(@game[:world][:width])

    camera_scale_y = (device_screen_height -
                      (@game[:device][:safe_margin_top] +
                       @game[:device][:safe_margin_bottom])).fdiv(@game[:world][:height])

    camera_scale = camera_scale_x

    if camera_scale_y < camera_scale_x
      camera_scale = camera_scale_y
    end

    real_width = @game[:world][:width] * camera_scale
    real_height = @game[:world][:height] * camera_scale
    best_fit_x = (device_screen_width - real_width).fdiv(2)
    best_fit_y = (device_screen_height - real_height).fdiv(2)

    @game[:camera][:best_fit] = {
      scale: camera_scale,
      x: best_fit_x,
      y: best_fit_y
    }

    @game[:camera][:scale] = @game[:camera][:best_fit][:scale]
    @game[:camera][:x] = @game[:camera][:best_fit][:x]
    @game[:camera][:y] = @game[:camera][:best_fit][:y]
  end

  def render
    camera_best_fit
    crud_nodes
    transform_camera
  end

  def update currentTime
    calc
    render
  end
end
