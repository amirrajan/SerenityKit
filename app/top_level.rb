class TopLevel
  def game
    $scene.game
  end

  def get path
    result = $scene.game

    tokens = path.split('.').map { |t| t.to_sym }

    tokens.each do |t|
      result = result[t]
    end

    result
  end

  def set path, key, value
    result = $scene.game

    tokens = path.split('.').map { |t| t.to_sym }

    tokens.each do |t|
      result = result[t]
    end

    result[key.to_sym] = value
  end

  def camera
    $scene.game[:camera]
  end

  def add_sprite id, x, y
    $scene.add_sprite id: id, x: x, y: x
  end
end
