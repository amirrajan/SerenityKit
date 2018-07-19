class TopLevel
  def graph
    $scene.graph
  end

  def camera
    $scene.graph[:camera]
  end

  def add_sprite id, x, y
    $scene.add_sprite id: id, x: x, y: x
  end
end
