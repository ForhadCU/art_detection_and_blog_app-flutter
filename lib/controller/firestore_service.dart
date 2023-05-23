import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/models/model.post.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static Future<List<Post>> mFetchInitialPost(
      {required FirebaseFirestore firebaseFirestore,
      required String category}) async {
    logger.d("Category to fetch: $category");
    CollectionReference collectionRef =
        firebaseFirestore.collection(MyKeywords.POST);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int itemsPerpage = 10;
    List<Post> posts = [];

    if (category.contains("all category")) {
      // fetch allorderBy(MyKeywords.ts, descending: true).get()
      await collectionRef
          .orderBy(MyKeywords.ts, descending: true)
          .limit(itemsPerpage)
          .get()
          .then((querySnapshot) async {
        for (var element in querySnapshot.docs) {
          // posts.add(Post.fromJson(jsonDecode(element.data().toString())));

          // posts.add(Post.fromJson(jsonDecode(element.data().toString())));
          await firebaseFirestore
              .collection(MyKeywords.USER)
              .doc(element.get(MyKeywords.email))
              .get()
              .then((value) {
            Users user = Users(username: value.get(MyKeywords.username));
            Post post = Post(
                postId: element.id,
                email: element.get(MyKeywords.email),
                caption: element.get(MyKeywords.caption),
                imgUri: element.get(MyKeywords.img_uri),
                numOfLikes: element.get(MyKeywords.num_of_likes),
                numOfDislikes: element.get(MyKeywords.num_of_dislikes),
                category: element.get(MyKeywords.category),
                ts: element.get(MyKeywords.ts),
                users: user);

            // logger.d(post.ts);
            posts.add(post);
          }).onError((error, stackTrace) {
            logger.e(error);
          });
        }
        logger.w("Post Loaded");
      }).onError((error, stackTrace) {
        logger.e(error);
      });
    } else {
      logger.d("Fetching post by category");
      // fetch by cat
      await collectionRef
          .orderBy(MyKeywords.ts, descending: true)
          .limit(itemsPerpage)
          .where(MyKeywords.category, isEqualTo: mFormatedCategory(category))
          .get()
          .then((querySnapshot) async {
        logger.w("Post Loaded");

        for (var element in querySnapshot.docs) {
          // posts.add(Post.fromJson(jsonDecode(element.data().toString())));

          // posts.add(Post.fromJson(jsonDecode(element.data().toString())));
          await firebaseFirestore
              .collection(MyKeywords.USER)
              .doc(element.get(MyKeywords.email))
              .get()
              .then((value) {
            Users user = Users(username: value.get(MyKeywords.username));
            Post post = Post(
                postId: element.id,
                email: element.get(MyKeywords.email),
                caption: element.get(MyKeywords.caption),
                imgUri: element.get(MyKeywords.img_uri),
                numOfLikes: element.get(MyKeywords.num_of_likes),
                numOfDislikes: element.get(MyKeywords.num_of_dislikes),
                category: element.get(MyKeywords.category),
                ts: element.get(MyKeywords.ts),
                users: user);

            posts.add(post);
          }).onError((error, stackTrace) {
            logger.e(error);
          });
        }

        logger.d("Uploaded post length: ${posts.length}");
      }).onError((error, stackTrace) {
        logger.e(error);
      });
    }

    return posts;
  }

  static Future<List<Post>> mFetchMorePosts({
    required FirebaseFirestore firebaseFirestore,
    required String category,
    required String lastVisibleDocumentId,
  }) async {
    CollectionReference collectionRef =
        firebaseFirestore.collection(MyKeywords.POST);
    int itemsPerpage = 10;
    List<Post> posts = [];

    DocumentSnapshot<Object?> laslastVisibleDoc =
        await collectionRef.doc(lastVisibleDocumentId).get();

    if (category.contains("All Category")) {
      // fetch All category's data
      logger.d("Last visi id: $lastVisibleDocumentId");
      await collectionRef
          .orderBy(MyKeywords
              .ts, descending: true) // Order the documents by a field, such as timestamp
          .limit(itemsPerpage) // Set the limit to the number of items per page
          .startAfterDocument(laslastVisibleDoc
              // lastVisibleDocument
              ) // Pass the last visible document from the previous page
          .get()
          .then((querySnapshot) async {
        logger.w("Post Loaded");

        for (var element in querySnapshot.docs) {
          // posts.add(Post.fromJson(jsonDecode(element.data().toString())));

          // posts.add(Post.fromJson(jsonDecode(element.data().toString())));
          await firebaseFirestore
              .collection(MyKeywords.USER)
              .doc(element.get(MyKeywords.email))
              .get()
              .then((value) {
            Users user = Users(username: value.get(MyKeywords.username));
            Post post = Post(
                postId: element.id,
                email: element.get(MyKeywords.email),
                caption: element.get(MyKeywords.caption),
                imgUri: element.get(MyKeywords.img_uri),
                numOfLikes: element.get(MyKeywords.num_of_likes),
                numOfDislikes: element.get(MyKeywords.num_of_dislikes),
                category: element.get(MyKeywords.category),
                ts: element.get(MyKeywords.ts),
                users: user);

            // logger.d(post.ts);
            posts.add(post);
          }).onError((error, stackTrace) {
            logger.e(error);
          });
        }
      }).onError((error, stackTrace) {
        logger.e(error);
      });
    } else {
      // fetch specific category's data
      await collectionRef
          .orderBy(MyKeywords.ts, descending: true)
          .limit(itemsPerpage)
          .startAfterDocument(laslastVisibleDoc)
          .where(MyKeywords.category, isEqualTo: mFormatedCategory(category))
          .get()
          .then((querySnapshot) async {
        logger.w("Post Loaded");

        for (var element in querySnapshot.docs) {
          // posts.add(Post.fromJson(jsonDecode(element.data().toString())));

          // posts.add(Post.fromJson(jsonDecode(element.data().toString())));
          await firebaseFirestore
              .collection(MyKeywords.USER)
              .doc(element.get(MyKeywords.email))
              .get()
              .then((value) {
            Users user = Users(username: value.get(MyKeywords.username));
            Post post = Post(
                postId: element.id,
                email: element.get(MyKeywords.email),
                caption: element.get(MyKeywords.caption),
                imgUri: element.get(MyKeywords.img_uri),
                numOfLikes: element.get(MyKeywords.num_of_likes),
                numOfDislikes: element.get(MyKeywords.num_of_dislikes),
                category: element.get(MyKeywords.category),
                ts: element.get(MyKeywords.ts),
                users: user);

            // logger.d(post.ts);
            posts.add(post);
          }).onError((error, stackTrace) {
            logger.e(error);
          });
        }
      }).onError((error, stackTrace) {
        logger.e(error);
      });
    }

    return posts;
  }

  static dynamic mFormatedCategory(String category) {
    switch (category) {
      case "Drawings":
        return MyKeywords.drawing;

      case "Engraving":
        return MyKeywords.engraving;

      case "Iconography":
        return MyKeywords.iconography;

      case "Painting":
        return MyKeywords.painting;

      case "Sculpture":
        return MyKeywords.sculpture;
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
