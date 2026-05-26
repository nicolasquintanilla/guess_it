import 'package:flutter/material.dart';

class AvatarRenderer extends StatelessWidget {
  final String? avatarKey;
  final double size;
  final bool isSelected;
  final Map<String, String> availableAvatars;
  final String defaultSimpleAvatarKey;

  const AvatarRenderer({
    Key? key,
    required this.avatarKey,
    required this.size,
    this.isSelected = false,
    required this.availableAvatars,
    required this.defaultSimpleAvatarKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (avatarKey == null ||
        avatarKey == defaultSimpleAvatarKey ||
        !availableAvatars.containsKey(avatarKey)) {
      return Container(
        width: size,
        height: size,
        decoration: null,
        child: Center(
          child: Icon(
            Icons.person_pin,
            size: size * 0.8,
            color: Colors.grey,
          ),
        ),
      );
    }

    final String imagePath = availableAvatars[avatarKey]!;
    return Container(
      width: size,
      height: size,
      decoration: isSelected
          ? BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepPurple.withOpacity(0.2),
            )
          : null,
      padding: const EdgeInsets.all(4.0),
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => Container(
          width: size,
          height: size,
          color: Colors.red.withOpacity(0.1),
          child: Icon(
            Icons.help_outline,
            color: Colors.white,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}
