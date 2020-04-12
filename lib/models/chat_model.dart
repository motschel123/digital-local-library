import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class ChatModel extends Model {
  Stream<List<DocumentSnapshot>> _stream;

  ChatModel(/*String userId, String chattingUserId*/) {
    _stream = Firestore.instance.collection('chats/7NzHfOJ5UjCh5W1KYopp/messages').getDocuments().asStream().map((snapshot) {
      return snapshot.documents;
    });
  }

  Stream<List<DocumentSnapshot>> get stream => _stream;
}
