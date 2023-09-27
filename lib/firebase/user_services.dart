import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecart/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {

   Future<void> saveUser(UserModel user) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (error) {
      print(error);
    }
  }

   Future<void> updateUser(UserModel updatedUser) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      await _firestore.collection('users').doc(updatedUser.id).update(
        {
          'name': updatedUser.name,
          'profileImg': updatedUser.profileImg,
          'cart': updatedUser.cart.map((product) => product.toMap()).toList(),
          'address': updatedUser.address,
          'phoneNumber': updatedUser.phoneNumber,
          'password' : updatedUser.password,
        },
      );
    } catch (error) {
      print(error);
    }
  }

   Future<UserModel> getUserModel(User user) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Check if the user document exists in Firestore
      final DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userSnapshot.exists) {
        // User already exists, retrieve their data
        final Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        final UserModel userModel = UserModel.fromMap(userData); // Assuming you have a method to convert data to UserModel
        return userModel;
      } else {
        // User doesn't exist
        UserModel newUser = UserModel(id: user.uid, name: '', profileImg: '', cart: [], address: '', phoneNumber: '', email: (user.email!=null)?user.email.toString() : '', password: '');
        saveUser(newUser);
        return newUser;
      }
    } catch (error) {
      print(error);
      UserModel newUser = UserModel(id: user.uid, name: '', profileImg: '', cart: [], address: '', phoneNumber: '', email: (user.email!=null)?user.email.toString() : '', password: '');
      saveUser(newUser);
      return newUser;
    }
  }

}
