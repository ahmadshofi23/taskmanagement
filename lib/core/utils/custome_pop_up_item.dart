import 'package:flutter/material.dart';
import 'package:minitaskmanagementapps/core/utils/color.dart';

class CustomePopUpItem extends PopupMenuItem {
  final String? title;
  final Function()? onPressed;
  CustomePopUpItem({
    Key? key,
    this.title,
    this.onPressed,
  }) : super(
          key: key,
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              title ?? '',
              style: const TextStyle(color: ColorPalette.greenColor),
            ),
          ),
        );
}
