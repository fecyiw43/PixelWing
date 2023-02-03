import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class Sky extends SpriteComponent {
  Sky() : super(priority: -1);

  @override
  Future<void>? onLoad() async {
    final image = await Flame.images.load('City_Background.png');
    sprite = Sprite(image);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }
}
