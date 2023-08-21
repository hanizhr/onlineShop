import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/data/product.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

final favoriteManager = FavoriteManager();

class FavoriteManager {
  static const _boxName = 'favorites';
  final _box = Hive.box<ProductEntity>(_boxName);
  ValueListenable<Box<ProductEntity>> get listenable =>
      Hive.box<ProductEntity>(_boxName).listenable();
  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductEntityAdapter());
    Hive.openBox<ProductEntity>(_boxName);
  }

  void addFavorite(ProductEntity product) async {
    await _box.put(product.id, product);
  }

  void delete(ProductEntity product) async {
    await _box.delete(product.id);
  }

  List<ProductEntity> get favorites {
    return _box.values.toList();
  }

  bool isFavorite(ProductEntity product) {
    return _box.containsKey(product.id);
  }
}
