import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_model.dart';

class AppViewModel {
  final CollectionReference appsCollection =
      FirebaseFirestore.instance.collection('apps');

  Future<void> addApp(AppModel app) {
    return appsCollection.add(app.toMap());
  }

  Stream<List<AppModel>> getApps() {
    return appsCollection.snapshots().map((snapshot) => snapshot.docs.map((doc) {
          // Forçando o tipo para Map<String, dynamic>
          final data = doc.data() as Map<String, dynamic>;
          return AppModel.fromMap(data, doc.id);
        }).toList());
  }

  Future<void> updateApp(AppModel app) {
    return appsCollection.doc(app.id).update(app.toMap());
  }

  Future<void> deleteApp(String id) {
    return appsCollection.doc(id).delete();
  }
}
