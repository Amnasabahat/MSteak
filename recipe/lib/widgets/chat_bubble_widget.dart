import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChatBubble extends StatelessWidget {
  final bool isMine; // true if it's the user's message, false if it's the chef's
  final String? photoUrl;
  final String message;

  final double _iconSize = 60.0; // Increased size for better visibility

  const ChatBubble({
    required this.isMine,
    required this.photoUrl,
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];

    // user or chef avatar
    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_iconSize / 2),
        child: SizedBox(
          width: _iconSize,
          height: _iconSize,
          child: photoUrl == null
              ? (isMine ? const _UserAvatar() : const _ChefAvatar())
              : CachedNetworkImage(
            imageUrl: photoUrl!,
            width: _iconSize,
            height: _iconSize,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) =>
            isMine ? const _UserAvatar() : const _ChefAvatar(),
            placeholder: (context, url) =>
            isMine ? const _UserAvatar() : const _ChefAvatar(),
          ),
        ),
      ),
    ));

    // message bubble
    widgets.add(Container(
      constraints:
      BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.brown.withOpacity(0.8)
      ), // Set both chat bubbles to black
      padding: const EdgeInsets.all(8.0),
      child: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Colors.white), // Different text colors
      ),
    ));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
        isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: isMine ? widgets.reversed.toList() : widgets,
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/1.json', // Path to your Lottie animation file for the user
      width: 48,
      height: 48,
      fit: BoxFit.cover,
    );
  }
}

class _ChefAvatar extends StatelessWidget {
  const _ChefAvatar();

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/2.json', // Path to your Lottie animation file for the chef
      width: 48,
      height: 48,
      fit: BoxFit.cover,
    );
  }
}
