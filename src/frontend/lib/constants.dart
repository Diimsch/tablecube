import 'package:flutter/material.dart';

enum UserType {
  WAITER,
  ADMIN,
  NONE,
  SERVICE
}

const primaryColor = Color(0xFF4D74FF);
const primaryLightColor = Color(0xFFdee5ff);

const warningColor = Color(0xFFdd8d94);
const warningColorWebToast = '#dd8d94';
const okColor = Color(0xFF689f7f);
const okColorWebToast = '#689f7f';
const warningColorOrange = Color(0xFFdbac2d);


const borderRadius = 29.0;
const iconSize = 48.0;
const splashRadius = 25.9;

const minQrFrameSize = 150.0;
const defaultQrFrameSize = 300.0;

final List<Map<String, dynamic>> selectedItems = [];

class OverviewArguments {
  String restaurantId;
  String bookingId;

  OverviewArguments(this.restaurantId, this.bookingId);
}
