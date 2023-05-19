import 'package:art_blog_app/const/keywords.dart';
import 'package:art_blog_app/controller/authentication_service.dart';
import 'package:art_blog_app/models/model.user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

class MyFirestoreService {
  static void mAddBabyGalleryDataToFirestore(
      {required String email,
      String? caption,
      required String imgUrl,
      double? latitude,
      double? longitude,
      String? timestamp,
      String? date,
      required bool imgFromCamera}) {
    final FirebaseFirestore firebaseFirestoreRef = FirebaseFirestore.instance;

    firebaseFirestoreRef
        .collection('USERS')
        .doc(email)
        .collection('DIARY')
        .doc()
        .set({
      "email": email,
      "caption": caption,
      "imgUrl": imgUrl,
      "latitude": latitude,
      "longitude": longitude,
      "timestamp": timestamp,
      "date": date,
      "imgFromCamera": imgFromCamera,
    });
  }

  static Future<bool> mStoreUserCredential(
      {required FirebaseFirestore firebaseFirestore,
      required Users user}) async {
    try {
      await firebaseFirestore.collection(MyKeywords.USER).doc(user.email).set(user.toJson());
      return true;
    } catch (e) {
      logger.e("Error in storing user credential: $e");
      return false;
    }
  }

  //c: Valid For Single image selection
  /* static Future<List<ImageDetailsModel>> mFetchAllDiaryDatafromFirestore(
      {required String email}) async {
    final FirebaseFirestore _firebaseFirestoreRef = FirebaseFirestore.instance;
    List<ImageDetailsModel> _listImageDetailModel = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestoreRef
            .collection('USERS')
            .doc(email)
            .collection('DIARY')
            .orderBy("timestamp", descending: true)
            .get();

    for (var element in querySnapshot.docs) {
      _listImageDetailModel.add(ImageDetailsModel.fromJson(element.data()));
      // Logger().d("address: ${element['imgUrl']}");
/*       _listImageDetailModel[i].strgImgUri =
          await FirebaseStorageProvider.mGetImgUrl(element['imgUrl']);
      i++; */

      // Logger().d('Json: ' + jsonDecode(element.data().toString()));
    }

    for (var i = 0; i < _listImageDetailModel.length; i++) {
      _listImageDetailModel[i].strgImgUri =
          await FirebaseStorageProvider.mGetImgUrl(
              _listImageDetailModel[i].imgUrl!);
    }

    Logger().d('out');

    return _listImageDetailModel;
  } */
}
