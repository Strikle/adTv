import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProvider {
  final String title;
  final String details;
  final String image;
  final String price;
  final String id;

  FirebaseProvider({
    required this.title,
    required this.details,
    required this.image,
    required this.price,
    required this.id,
  });

  factory FirebaseProvider.fromFirestore(DocumentSnapshot doc) {
    return FirebaseProvider(
        title: doc['title'],
        details: doc['details'],
        image: doc['image'],
        price: doc['price'],
        id: doc['id']);
  }
}

class DatabaseServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<FirebaseProvider>> streamFirebaseProvider() {
    return _firebaseFirestore
        .collection('Products')
        .orderBy('id', descending: false)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => FirebaseProvider.fromFirestore(e)).toList());
  }
}
