class TopLevel
  def graph
    $scene.graph
  end

  def get path
    result = $scene.graph

    tokens = path.split('.').map { |t| t.to_sym }

    tokens.each do |t|
      result = result[t]
    end

    result
  end

  def set path, key, value
    result = $scene.graph

    tokens = path.split('.').map { |t| t.to_sym }

    tokens.each do |t|
      result = result[t]
    end

    result[key] = value
  end

  def camera
    $scene.graph[:camera]
  end

  def add_sprite id, x, y
    $scene.add_sprite id: id, x: x, y: x
  end
end
