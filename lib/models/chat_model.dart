import 'package:digital_local_library/data/message.dart';
import 'package:scoped_model/scoped_model.dart';

class ChatModel extends Model {
  List<Message> messages;

  ChatModel(){
    messages = Message.test;
    messages.sort((message1, message2) => message2.dateTime.compareTo(message1.dateTime));
  }

  void newMessage(Message message) {
    messages.add(message);
    notifyListeners();
  }
}