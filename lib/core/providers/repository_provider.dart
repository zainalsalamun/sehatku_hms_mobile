import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_hms_repository.dart';

final hmsRepositoryProvider = Provider((ref) => const MockHmsRepository());
