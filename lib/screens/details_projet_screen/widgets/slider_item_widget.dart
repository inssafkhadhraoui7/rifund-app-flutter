import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../models/slider_item_model.dart'; // ignore: must_be_immutable
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

class SliderItemWidget extends StatelessWidget {
  SliderItemWidget(this.sliderItemModelObj, {Key? key}) : super(key: key);

  final SliderItemModel sliderItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageView(
              imagePath: sliderItemModelObj.id!.isNotEmpty
                  ? sliderItemModelObj.id
                  : ImageConstant.imgImage,
              height: 200.v,
              width: 331.h,
              radius: BorderRadius.circular(12.h),
            ),
            CustomImageView(
              imagePath: ImageConstant.imgImage258x2,
              height: 258.v,
              width: 2.h,
              radius: BorderRadius.circular(1.h),
              margin: EdgeInsets.only(left: 8.h),
            ),
          ],
        ),
        SizedBox(height: 8.v), // Space between image and title
        Text(
          sliderItemModelObj.title as String,
          style: theme.textTheme.titleMedium, // Adjust the style as needed
        ),
      ],
    );
  }
}
