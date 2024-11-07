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
        CustomImageView(
          imagePath: sliderItemModelObj.imageUrl.isNotEmpty
              ? sliderItemModelObj.imageUrl
              : ImageConstant.imgImage,
          height: 200.v,
          width: 331.h,
          radius: BorderRadius.circular(12.h),
        ),
        SizedBox(height: 8.v),
      ],
    );
  }
}
