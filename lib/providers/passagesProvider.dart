import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/tp_passage.dart';
import '../services/passage_database.dart';

final passagesProvider = FutureProvider<List<TpPassage>>((ref) async {
  return await PassageDatabase.instance.getAllPassages();
});
