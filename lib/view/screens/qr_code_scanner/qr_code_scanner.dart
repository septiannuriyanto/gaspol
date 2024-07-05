import 'package:flutter/material.dart';
import 'package:gaspol/view/components/themes/colors.dart';
import 'package:gaspol/view/components/widgets/custom_button.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerSimple extends StatefulWidget {
  const BarcodeScannerSimple({super.key});

  @override
  State<BarcodeScannerSimple> createState() => _BarcodeScannerSimpleState();
}

class _BarcodeScannerSimpleState extends State<BarcodeScannerSimple> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    mobileScannerController.stop();
    mobileScannerController.dispose();
  }

  Barcode? _barcode;
  MobileScannerController mobileScannerController = MobileScannerController();

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Arahkan ke QR Code Tabung',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Column(
      children: [
        Text(
          value.displayValue ?? 'No display value.',
          overflow: TextOverflow.fade,
          style: const TextStyle(color: Colors.white),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CButton(
              buttonColor: MainColor.brandColor,
              onPressed: () {
                Navigator.pop(context, _barcode!.displayValue);
              }),
        )
      ],
    );
  }

  _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: MainColor.brandColor,
          title: const Text('Scan Nomor Tabung')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: mobileScannerController,
            onDetect: (barcodes) async {
              await _handleBarcode(barcodes);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Center(child: _buildBarcode(_barcode))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
