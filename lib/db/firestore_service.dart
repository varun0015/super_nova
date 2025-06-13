// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FirestoreService {
//   final _db = FirebaseFirestore.instance;

//   Future<void> saveUserLocation(Map<String, dynamic> data) async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid != null) {
//       await _db.collection('users').doc(uid).set(
//           {
//             'location': data,
//           },
//           SetOptions(
//               merge: true)); // Merge so it doesn't overwrite other user fields
//     }
//   }

//   Future<void> saveUserDetails({
//     required String community,
//     required String vehicle,
//     required String contact,
//   }) async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid != null) {
//       final userRef = _db.collection('users').doc(uid);
//       await userRef.set({
//         'userDetails': {
//           'community': community,
//           'vehicle': vehicle,
//           'contact': contact,
//         }
//       }, SetOptions(merge: true));
//     }
//   }

//   Future<void> saveCarDetails({
//     required String brand,
//     required String car,
//   }) async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid != null) {
//       final userRef = _db.collection('users').doc(uid);
//       await userRef.set({
//         'carDetails': {
//           'brand': brand,
//           'car': car,
//         }
//       }, SetOptions(merge: true));
//     }
//   }

//   Future<void> addBookingToUser(Map<String, dynamic> booking) async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid != null) {
//       final userRef = _db.collection('users').doc(uid);
//       await userRef.update({
//         'bookings': FieldValue.arrayUnion([booking])
//       });
//     }
//   }

//   Future<List<Map<String, dynamic>>> getUserBookings() async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid != null) {
//       final userDoc =
//           await FirebaseFirestore.instance.collection('users').doc(uid).get();
//       final data = userDoc.data();
//       if (data != null && data['bookings'] != null) {
//         final List bookings = data['bookings'];
//         return bookings.cast<Map<String, dynamic>>();
//       }
//     }
//     return [];
//   }

//   Future<Map<String, dynamic>?> getUserDetails() async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid != null) {
//       final doc = await _db.collection('users').doc(uid).get();
//       if (doc.exists && doc.data()?['userDetails'] != null) {
//         return Map<String, dynamic>.from(doc.data()!['userDetails']);
//       }
//     }
//     return null;
//   }
// }

//   // Future<void> saveUserLocation(Map<String, dynamic> data) async {
//   //   final uid = FirebaseAuth.instance.currentUser?.uid;
//   //   if (uid != null) {
//   //     await FirebaseFirestore.instance.collection('users').doc(uid).update({
//   //       'location': data,
//   //     });
//   //   }
//   // }

//   // Future<void> saveUserDetails({
//   //   required String community,
//   //   required String vehicle,
//   //   required String contact,
//   //   String? selectedBrand,
//   //   String? selectedCar,
//   // }) async {
//   //   final uid = FirebaseAuth.instance.currentUser?.uid;
//   //   if (uid != null) {
//   //     final userRef = _db.collection('users').doc(uid);
//   //     await userRef.set({
//   //       'userDetails': {
//   //         'community': community,
//   //         'vehicle': vehicle,
//   //         'contact': contact,
//   //         if (selectedBrand != null) 'selectedBrand': selectedBrand,
//   //         if (selectedCar != null) 'selectedCar': selectedCar,
//   //       }
//   //     }, SetOptions(merge: true));
//   //   }
//   // }

//backuppppp

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  /// Save user location with merge
  Future<void> saveUserLocation(Map<String, dynamic> data) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _db.collection('users').doc(uid).set(
        {
          'location': data,
        },
        SetOptions(merge: true), // Merge so it doesn't overwrite other fields
      );
    }
  }

  /// Save user details with optional merge
  Future<void> saveUserDetails({
    required String community,
    required String vehicle,
    required String contact,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userRef = _db.collection('users').doc(uid);
      await userRef.set({
        'userDetails': {
          'community': community,
          'vehicle': vehicle,
          'contact': contact,
        }
      }, SetOptions(merge: true));
    }
  }

  /// Save car brand and model details
  Future<void> saveCarDetails({
    required String brand,
    required String car,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userRef = _db.collection('users').doc(uid);
      await userRef.set({
        'carDetails': {
          'brand': brand,
          'car': car,
        }
      }, SetOptions(merge: true));
    }
  }

  /// Add a booking to the user's Firestore document
  Future<void> addBookingToUser(Map<String, dynamic> booking) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userRef = _db.collection('users').doc(uid);
      await userRef.update({
        'bookings': FieldValue.arrayUnion([booking])
      });
    }
  }

  /// Get all bookings for the current user
  Future<List<Map<String, dynamic>>> getUserBookings() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userDoc = await _db.collection('users').doc(uid).get();
      final data = userDoc.data();
      if (data != null && data['bookings'] != null) {
        final List bookings = data['bookings'];
        return bookings.cast<Map<String, dynamic>>();
      }
    }
    return [];
  }

  /// Get userDetails map from Firestore
  Future<Map<String, dynamic>?> getUserDetails() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists && doc.data()?['userDetails'] != null) {
        return Map<String, dynamic>.from(doc.data()!['userDetails']);
      }
    }
    return null;
  }

  Future<void> saveUserSubscription(Map<String, dynamic> subscription) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _db
          .collection('users')
          .doc(uid)
          .set({'subscription': subscription}, SetOptions(merge: true));
    }
  }

  Future<Map<String, dynamic>?> getUserSubscription() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await _db.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null && data.containsKey('subscription')) {
        return Map<String, dynamic>.from(data['subscription']);
      }
    }
    return null;
  }

  // ❗️Backup versions (commented out)

  // Future<void> saveUserLocation(Map<String, dynamic> data) async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid != null) {
  //     await FirebaseFirestore.instance.collection('users').doc(uid).update({
  //       'location': data,
  //     });
  //   }
  // }

  // Future<void> saveUserDetails({
  //   required String community,
  //   required String vehicle,
  //   required String contact,
  //   String? selectedBrand,
  //   String? selectedCar,
  // }) async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid != null) {
  //     final userRef = _db.collection('users').doc(uid);
  //     await userRef.set({
  //       'userDetails': {
  //         'community': community,
  //         'vehicle': vehicle,
  //         'contact': contact,
  //         if (selectedBrand != null) 'selectedBrand': selectedBrand,
  //         if (selectedCar != null) 'selectedCar': selectedCar,
  //       }
  //     }, SetOptions(merge: true));
  //   }
  // }
}
