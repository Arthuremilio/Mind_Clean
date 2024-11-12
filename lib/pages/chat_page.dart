import 'package:flutter/material.dart';
import 'package:mind_clean/models/auth.dart';
import 'package:provider/provider.dart';
import 'package:mind_clean/models/chat.dart';
import 'package:mind_clean/utils/app_routes.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = Provider.of<Auth>(context, listen: false).uid!;
      _loadMessages(userId);
    });
  }

  Future<void> _loadMessages(String userId) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<ChatProvider>(context, listen: false).getMessages(userId);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Mind Clean', style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH),
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (ctx, index) {
                      return chatProvider.messages[index];
                    },
                  ),
          ),
          Divider(color: Colors.white),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'Gallery',
                  onPressed: () =>
                      chatProvider.sendImageFromGallery(chatProvider.userId!),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
                FloatingActionButton(
                  heroTag: 'Camera',
                  onPressed: () =>
                      chatProvider.sendImageFromCamera(chatProvider.userId!),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: const Icon(Icons.camera_alt, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
