import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rifund/screens/affichage_communaut_page/affichage_communaut_page.dart';
import 'package:rifund/theme/app_decoration.dart';
import 'package:rifund/theme/theme_helper.dart';
import 'provider/chat_box_provider.dart';

class ChatBoxScreen extends StatelessWidget {
  const ChatBoxScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatBoxProvider(),
      child: ChatBoxScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.orange50,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            _buildHeader(context),
            SizedBox(height: 50),
            Expanded(
              child: Consumer<ChatBoxProvider>(builder: (context, provider, _) {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final message = provider.messages[index];
                    return _buildMessage(
                      context,
                      message.message,
                      isReceived: message.isReceived,
                      avatar: 'assets/images/avatar.png',
                    );
                  },
                );
              }),
            ),
            _buildInputField(context),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(BuildContext context, String message,
      {required bool isReceived, required String avatar}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isReceived)
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: CircleAvatar(
                backgroundImage: AssetImage(avatar),
              ),
            ),
          Expanded(
            child: FractionallySizedBox(
              alignment: isReceived ? Alignment.centerLeft : Alignment.centerRight,
              widthFactor: 0.25,
              child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: isReceived ? Colors.white : Colors.lightGreen.shade600,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: isReceived ? Radius.circular(15) : Radius.zero,
                    bottomLeft: !isReceived ? Radius.circular(15) : Radius.zero,
                  ),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: isReceived ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          if (!isReceived)
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: CircleAvatar(
                backgroundImage: AssetImage(avatar),
              ),
            ),
        ],
      ),
    );
  }
 Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 13),
      decoration: AppDecoration.fillLightGreen.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder22,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              "Nom de communauté",
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AffichageCommunautPage()),
              );
            },
          ),
        ],
      ),
    );
  }
  Widget _buildInputField(BuildContext context) {
    return Consumer<ChatBoxProvider>(builder: (context, provider, _) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: provider.messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                provider.sendMessage();
              },
            ),
          ],
        ),
      );
    });
  }
}
