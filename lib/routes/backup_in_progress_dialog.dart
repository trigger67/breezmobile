import 'dart:async';

import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/utils/build_context.dart';
import 'package:breez/widgets/animated_loader_dialog.dart';
import 'package:flutter/material.dart';

Widget buildBackupInProgressDialog(
  BuildContext context,
  Stream<BackupState> backupStateStream,
) {
  return _BackupInProgressDialog(backupStateStream: backupStateStream);
}

class _BackupInProgressDialog extends StatefulWidget {
  final Stream<BackupState> backupStateStream;

  const _BackupInProgressDialog({
    Key key,
    this.backupStateStream,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BackupInProgressDialogState();
  }
}

class _BackupInProgressDialogState extends State<_BackupInProgressDialog> {
  StreamSubscription<BackupState> _stateSubscription;

  @override
  void initState() {
    super.initState();
    _stateSubscription = widget.backupStateStream.listen((state) {
      if (state.inProgress != true) {
        _pop();
      }
    }, onError: (err) => _pop());
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    super.dispose();
  }

  _pop() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return createAnimatedLoaderDialog(context, context.l10n.backup_in_progress);
  }
}
