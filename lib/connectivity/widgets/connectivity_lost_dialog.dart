part of 'connectivity_listener.dart';

/// The dialog displayed when internet connection is lost.
/// Locks the app while it is visible, so the app can only
/// be used when there is an available internet connection.
class ConnectivityLostDialog extends StatelessWidget {
  const ConnectivityLostDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      contentPadding: const EdgeInsets.all(32),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: SvgPicture.asset(
                'assets/illustrations/lost_connection.svg',
                semanticsLabel: l10n.lostConnectionSemanticsLabel,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.lostConnectionDialogMessage,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
