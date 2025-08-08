import '../../../../../drishya_picker/drishya_picker.dart';
import 'package:flutter/material.dart';

const double _defaultMin = 0.37;

///
class PanelSettingBuilder extends StatelessWidget {
  ///
  const PanelSettingBuilder({
    Key? key,
    required this.setting,
    required this.builder,
  }) : super(key: key);

  ///
  final PanelSetting? setting;

  ///
  final Widget Function(PanelSetting panelSetting) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final MediaQueryData mediaQuery = MediaQuery.of(context);
        final Size size = constraints.biggest;
        final bool isFullScreen = size.height == mediaQuery.size.height;
        final PanelSetting ps = this.setting ?? const PanelSetting();
        final double panelMaxHeight =
            ps.maxHeight ??
            size.height - (isFullScreen ? mediaQuery.padding.top : 0);
        final double panelMinHeight =
            ps.minHeight ?? panelMaxHeight * _defaultMin;
        final PanelSetting setting = ps.copyWith(
          maxHeight: panelMaxHeight,
          minHeight: panelMinHeight,
        );
        return builder(setting);
      },
    );
  }
}
