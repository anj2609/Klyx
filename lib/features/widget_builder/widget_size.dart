enum WidgetSize {
  small,  // 1x1
  medium, // 2x1
  large;  // 2x2

  int get crossAxisCellCount {
    switch (this) {
      case WidgetSize.small:
        return 1;
      case WidgetSize.medium:
        return 2;
      case WidgetSize.large:
        return 2;
    }
  }

  int get mainAxisCellCount {
    switch (this) {
      case WidgetSize.small:
        return 1;
      case WidgetSize.medium:
        return 1;
      case WidgetSize.large:
        return 2;
    }
  }

  String get displayName {
    switch (this) {
      case WidgetSize.small:
        return 'Small';
      case WidgetSize.medium:
        return 'Medium';
      case WidgetSize.large:
        return 'Large';
    }
  }
}
