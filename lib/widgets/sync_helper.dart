import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SyncHelper {
  final SupabaseClient client;
  SyncHelper(this.client);

  Future<bool> isOnline() async {
    final r = await Connectivity().checkConnectivity();
    return r != ConnectivityResult.none;
  }

  // Example upsert functions - adapt to your Supabase schema
  Future<void> syncProduction(List<Map<String, dynamic>> localRows) async {
    if (!await isOnline()) return;
    for (var row in localRows) {
      await client.from('production').upsert(row);
    }
  }
}
