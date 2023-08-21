import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/receipt/payment_receipt.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatelessWidget {
  final String bankGetWayUrl;
  const PaymentWebView({super.key, required this.bankGetWayUrl});

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: bankGetWayUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onPageStarted: (url) {
        final uri = Uri.parse(url);
        final orderId = int.parse(uri.queryParameters['order_id']!);
        if (uri.pathSegments.contains('checkout') &&
            uri.host == 'experdevelopers.ir') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PaymentReceiptScreen(orderId: orderId)));
        }
      },
    );
  }
}
