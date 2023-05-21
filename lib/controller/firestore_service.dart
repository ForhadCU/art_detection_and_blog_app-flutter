import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/models/model.post.dart';
import 'package:logger/logger.dart';

import '../const/keywords.dart';
import '../models/model.user.dart';

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
      await firebaseFirestore
          .collection(MyKeywords.USER)
          .doc(user.email)
          .set(user.toJson());
      return true;
    } catch (e) {
      logger.e("Error in storing user credential: $e");
      return false;
    }
  }

  static Future<String?> mUploadImageToStorage(
      {required String imgUri,
      required FirebaseStorage firebaseStorage}) async {
    // Reference  storageRef = firebaseStorage.ref().child("art_images");

    File imageFile = File(imgUri);
    String? downloadUrl;

    /*  var snapShot = await firebaseStorage
        .ref()
        .child("images/imageName")
        .putFile(imageFile);
    var downloadUrl = await snapShot.ref.getDownloadURL(); */

    await firebaseStorage
        .ref()
        .child("image/$imgUri")
        .putFile(imageFile)
        .then((TaskSnapshot snapshot) async {
      // downloadUrl = await snapshot.ref.getDownloadURL();
      await snapshot.ref.getDownloadURL().then((value) => downloadUrl = value);
    }).onError((error, stackTrace) {
      logger.e("Error. in image upload: $error");
    });

    return downloadUrl;
  }

  static Future<bool> mUploadPost(
      {required FirebaseFirestore firebaseFirestore,
      required Post post}) async {
    bool isSuccess = false;
    await firebaseFirestore
        .collection(MyKeywords.POST)
        .doc()
        .set(post.toJson())
        .then((value) => {isSuccess = true, logger.w("Done. Post Uploaded.")})
        .onError(
            (error, stackTrace) => {logger.e("Error. Post uploading: $error")});

    return isSuccess;
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
