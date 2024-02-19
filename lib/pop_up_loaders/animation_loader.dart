import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationLoaderWidget extends StatelessWidget {
  
  const AnimationLoaderWidget({
    super.key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,
  });

  final String text;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(animation,
          width: MediaQuery.of(context).size.width * 0.8),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.10,
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          showAction
              ? SizedBox(
                  width: 250.0,
                  child: OutlinedButton(
                    onPressed: onActionPressed,
                    child: Text(
                      actionText!,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
