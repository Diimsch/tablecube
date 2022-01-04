import 'package:flutter/material.dart';
import 'package:frontend/pages/overview/overview_screen.dart';

enum UserType {
  WAITER,
  ADMIN,
  NONE,
}

const primaryColor = Color(0xFF4D74FF);
const primaryLightColor = Color(0xFFdee5ff);

const warningColor = Color(0xFFdd8d94);
const warningColorWebToast = '#dd8d94';

const borderRadius = 29.0;
const iconSize = 48.0;
const splashRadius = 25.9;

const minQrFrameSize = 150.0;
const defaultQrFrameSize = 300.0;

class OverviewArguments {
  String restaurantId;

  OverviewArguments(this.restaurantId);
}
