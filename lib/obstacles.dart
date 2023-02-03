import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

double inc = 1.0;

class Box extends SpriteComponent {
  static Vector2 initialSize = Vector2.all(100 * inc);
  Box({super.position}) : super(size: initialSize, priority: 0);

  @override
  Future<void>? onLoad() async {
    // debugMode = true;
    final image = await Flame.images.load('Box.png');
    sprite = Sprite(image);
    add(
      RectangleHitbox(),
    );
    return super.onLoad();
  }
}
