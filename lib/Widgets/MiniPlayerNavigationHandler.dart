import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_hub/Providers/seedColorProvider.dart';
import 'package:miniplayer/miniplayer.dart';

class MiniPlayerNavigationHandler extends ConsumerWidget {
  final Widget child;

  const MiniPlayerNavigationHandler({super.key, required this.child});

  void _popScreen(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      print("not last screen pop");
      Navigator.of(context).pop();
    } else {
      SystemNavigator.pop();
      print("last screen pop");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          final _controller = ref.watch(MiniplayerControllerProvider);

          if (_controller.value != null &&
              _controller.value!.panelState == PanelState.MAX) {
            print("miniplayer pop");
            _controller.animateToHeight(state: PanelState.MIN);
            return;
          }
          _popScreen(context);
        },
        child: child);
  }
}
