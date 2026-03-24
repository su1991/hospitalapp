import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gfhfg/ViewModel/chats.dart';

import '../ViewModel/appointmentViewModel.dart';
import '../ViewModel/notifications_service.dart';



class ViewChatPage extends StatefulWidget
{
  final String otherUserId;




  const ViewChatPage({super.key,required this.otherUserId, });

  @override
  State<ViewChatPage> createState() => _ViewChatPageState();
}

class _ViewChatPageState extends State<ViewChatPage>
{
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late var currentUserId = _auth.currentUser!.uid;
  final chat _viewmodel= chat();
  String? chatId;
  String? messageid;
  bool loading = true;
   late final String othername;
  final appointmentViewModel _viewModel1 = appointmentViewModel();
  final chat _viewModel2 = chat();


  // Temporary dummy messages (for UI preview)
  List<Map<String, dynamic>> messages = [];

  Future<void> send() async
  {
    if (messageController.text.trim().isEmpty ||
      chatId == null) return;


    final messageid = await _viewmodel.sendMessage(chatId!, messageController.text.trim(), messageController.clear());

      scrollController.animateTo(
      scrollController.position.maxScrollExtent + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      );
    setState(()
    {
    });
    await NotificationService.sendChatNotification(
      chatId: chatId,
      senderId: FirebaseAuth.instance.currentUser!.uid,
      messageid: messageid ,
    );

  }
  Future<void> displayname() async
  {

    final name = await _viewModel1.fetchoppositeName(widget.otherUserId);
    setState(()
    {
      othername = name?? "Unkown";
      loading = false;
    })
    ;

  }
  @override
  void initState()
  {
    super.initState();
    initChat();
    displayname();
  }



  Future<void> initChat() async
  {
    final id =
    await _viewmodel.createOrGetChat(widget.otherUserId);

    setState(()
    {
      chatId = id;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(othername),
        centerTitle: false,

      ),

      body: Column(
        children: [

          /// Chat Messages
      Expanded
        (
      child: loading
      ? const Center(child: CircularProgressIndicator())
        : StreamBuilder<List<Map<String, dynamic>>>(



    stream: _viewmodel.streamMessages(chatId!),
    builder: (context, snapshot)
    {

    if (!snapshot.hasData)
    {
    return const Center(
    child: CircularProgressIndicator());
    }

    final messages = snapshot.data!;
    WidgetsBinding.instance.addPostFrameCallback((_)  // so that when new message is added to the chat it immediately scrools to the latest message
    {
      if (scrollController.hasClients) {

        scrollController.jumpTo(0);
      }
    });
    return ListView.builder
      (
      reverse: true, // so that it always scrolls to the bottom automatically when open chatpage
    controller: scrollController,
    padding: const EdgeInsets.all(12),
    itemCount: messages.length,
    itemBuilder: (context, index)
    {


    final message = messages[messages.length -1 - index]; //so that it displays the latest message at the bottom
    final isMe = message["senderId"] == _viewmodel.currentUserId;

   return  GestureDetector(
        onLongPress: ()
        {
          if (message["senderId"] == currentUserId)
          {
            _viewmodel.deleteMessage(chatId!,  message["messageid"] as String);
          }

        },





    child : Align(alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
    margin:
    const EdgeInsets.symmetric(vertical: 5),
    padding: const EdgeInsets.all(12),
    constraints:
    const BoxConstraints(maxWidth: 250),
    decoration: BoxDecoration(
    color: isMe
    ? Colors.blue.shade300
        : Colors.grey.shade300,
    borderRadius: BorderRadius.only(
    topLeft:
    const Radius.circular(15),
    topRight:
    const Radius.circular(15),
    bottomLeft: isMe
    ? const Radius.circular(15)
        : const Radius.circular(0),
    bottomRight: isMe
    ? const Radius.circular(0)
        : const Radius.circular(15),
    ),
    ),
    child: Text(
    message["text"],
    style: const TextStyle(fontSize: 16),
    ),
    ),
    )
    );
    },
    );
    },
    ),
    ),


          /// Message Input Field
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                /// TextField
                Expanded
                  (
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),



                const SizedBox(width: 8),

                /// Send Button
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: send
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}