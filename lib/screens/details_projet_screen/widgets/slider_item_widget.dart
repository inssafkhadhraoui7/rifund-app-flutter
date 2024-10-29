import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/slider_item_model.dart';

// ignore_for_file: must_be_immutable

class SliderItemWidget extends StatelessWidget {
  final SliderItemModel sliderItemModelObj;

  SliderItemWidget(this.sliderItemModelObj, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Display the main image
        CustomImageView(
          imagePath: sliderItemModelObj.imageUrl.isNotEmpty 
              ? sliderItemModelObj.imageUrl 
              : ImageConstant.imgImage, // Fallback image
          height: 200.v,
          width: 331.h,
          radius: BorderRadius.circular(12.h),
        ),
        SizedBox(height: 8.v),
        // Optionally display a title
        // Text(
        //   // sliderItemModelObj.title ?? "Pas de titre", // Handle null title
        //   // style: theme.textTheme.titleMedium,
        //   // textAlign: TextAlign.center, // Center align the text
        // ),
      ],
    );
  }
}
