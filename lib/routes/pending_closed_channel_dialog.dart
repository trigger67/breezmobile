import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/utils/build_context.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/payment_details_dialog.dart';
import 'package:flutter/material.dart';

class PendingClosedChannelDialog extends StatefulWidget {
  final AccountBloc accountBloc;

  const PendingClosedChannelDialog({Key key, this.accountBloc})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PendingClosedChannelDialogState();
  }
}

class PendingClosedChannelDialogState
    extends State<PendingClosedChannelDialog> {
  Future _fetchFuture;

  @override
  void initState() {
    super.initState();
    var fetchAction = FetchPayments();
    _fetchFuture = fetchAction.future;
    widget.accountBloc.userActionsSink.add(fetchAction);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 24.0, 16.0),
      title: AutoSizeText(
        "Pending Closed Channel",
        style: context.dialogTheme.titleTextStyle,
        maxLines: 1,
      ),
      contentPadding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
      content: FutureBuilder(
          future: this._fetchFuture,
          initialData: null,
          builder: (ctx, loadingSnapshot) {
            if (loadingSnapshot.connectionState != ConnectionState.done) {
              return Loader();
            }

            return StreamBuilder<List<PaymentInfo>>(
                stream: widget.accountBloc.pendingChannelsStream,
                builder: (ctx, snapshot) {
                  var pendingClosedChannels = snapshot?.data;
                  if (pendingClosedChannels == null ||
                      pendingClosedChannels.length == 0) {
                    return Loader();
                  }

                  return ClosedChannelPaymentDetails(
                      closedChannel: pendingClosedChannels[0]);
                });
          }),
      actions: [
        SimpleDialogOption(
          onPressed: () => context.pop(),
          child: Text("OK", style: context.primaryTextTheme.button),
        )
      ],
    );
  }
}
