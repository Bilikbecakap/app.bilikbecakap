import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/artikel/data/models/artikel_detail_model.dart';
import 'features/artikel/data/services/artikel_detail_service.dart';
import 'features/home/data/services/artikel_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ArtikelDetailModelAdapter());
  await Hive.openBox<ArtikelDetailModel>(ArtikelDetailService.boxName);
  await Hive.openBox<String>(ArtikelService.boxName);
  runApp(const BilikBecakapApp());
}
