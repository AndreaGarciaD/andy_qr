import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'TOKEN', obfuscate: true)
  static const String token = _Env.token; // Especifica el tipo de dato
}
