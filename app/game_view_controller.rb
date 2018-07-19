# coding: utf-8
class GameViewController < UIViewController
  include ScreenSizes

  # This hides the status bar.
  def prefersStatusBarHidden
    true
  end

  # This hides iPhone X's notch thingy at the bottom.
  def prefersHomeIndicatorAutoHidden
    true
  end

  # When the code in app_delegate is successfully executed,
  # this method is invoked. Here is where we create and present
  # our scenes.
  def viewDidLoad
    super
    self.view = sk_view
    # The first time the app is loaded. Present scene one.
    present_scene_zero
    $controller = self
  end

  def present_scene_zero
    @scene_zero = SceneZero.sceneWithSize(sk_view.frame.size)
    @scene_zero.root = self
    sk_view.presentScene @scene_zero
  end

  def sk_view
    @sk_view ||= SKView.alloc.initWithFrame screen_rect
  end
end
