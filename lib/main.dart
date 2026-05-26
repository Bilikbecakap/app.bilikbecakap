import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/artikel/data/models/artikel_detail_model.dart';
import 'features/artikel/data/services/artikel_detail_service.dart';
import 'features/home/data/services/artikel_service.dart';
import 'features/pembelajaran/data/services/pembelajaran_service.dart';
import 'features/pembelajaran/data/services/modul_selesai_service.dart';
import 'core/services/profil_service.dart';
import 'features/kuis/data/services/kuis_service.dart';
import 'features/kuis/data/services/kuis_hasil_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ArtikelDetailModelAdapter());
  await Hive.openBox<ArtikelDetailModel>(ArtikelDetailService.boxName);
  await Hive.openBox<String>(ArtikelService.boxName);
  await Hive.openBox<String>(PembelajaranService.listBoxName);
  await Hive.openBox<String>(PembelajaranService.detailBoxName);
  await Hive.openBox<bool>(ModulSelesaiService.boxName);
  await Hive.openBox<String>(ProfilService.boxName);
  await Hive.openBox<String>(KuisService.listBoxName);
  await Hive.openBox<String>(KuisHasilService.pendingBoxName);
  runApp(const BilikBecakapApp());
}
