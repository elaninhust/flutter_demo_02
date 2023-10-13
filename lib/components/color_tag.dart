import 'package:flutter/material.dart';

class ColorTag extends StatelessWidget {
  const ColorTag(
      {super.key, required this.color, this.isChecked = false, this.onPress});

  final Color color;

  final bool isChecked;

  final Function? onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPress != null) {
          onPress!();
        }
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        child: Container(
          color: color.withOpacity(isChecked ? 0.5 : 1),
          width: 30,
          height: 30,
          child: Center(
            child: isChecked
                ? ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                    child: Container(
                      width: 10,
                      height: 10,
                      color: Colors.white,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
