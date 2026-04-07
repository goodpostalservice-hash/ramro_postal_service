import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogHelper extends StatefulWidget {
  final String title, content, positiveBtnText, negativeBtnText;
  final bool isinternet;
  final GestureTapCallback positiveBtnPressed;
  const DialogHelper({
    Key? key,
    required this.isinternet,
    required this.title,
    required this.content,
    required this.positiveBtnText,
    required this.negativeBtnText,
    required this.positiveBtnPressed,
  }) : super(key: key);
  //show error dialog
  static void showErroDialog({
    String title = 'Error',
    String? description = 'Something went wrong',
  }) {
    Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        contentPadding: const EdgeInsets.only(top: 10.0),
        backgroundColor: Colors.white,
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                if (Get.isDialogOpen!) Get.back();
              },
              child: const Text('Try Again'),
            ),
          ),
        ],
        content: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                top: 20,
              ), // to push the box half way below circle
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ), // spacing inside the box
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        // Top Circle with icon
                        maxRadius: 20.0,
                        child: Icon(Icons.error, color: Colors.red, size: 40),
                      ),
                      const SizedBox(width: 10),
                      Text(description ?? 'Error Occured'),
                      const SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      transitionDuration: const Duration(milliseconds: 500),
      transitionCurve: Curves.linear,
    );
  }

  static void showLoading([String? message]) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Container(
                height: 100,
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/loading.gif',
                  height: 100,
                  width: 100,
                ),
              ),
              Container(
                height: 75,
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/images/bhadapayicon.png',
                  height: 50,
                  width: 25,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  //hide loading
  static void hideLoading() {
    if (Get.isDialogOpen!) Get.back();
  }

  @override
  State<DialogHelper> createState() => _DialogHelperState();
}

class _DialogHelperState extends State<DialogHelper> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: buildDialogContent(context),
    );
  }

  Widget buildDialogContent(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
            top: 40,
          ), // to push the box half way below circle
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.only(
            top: 60,
            left: 20,
            right: 20,
          ), // spacing inside the box
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.isinternet
                      ? CircleAvatar(
                          backgroundColor: Colors.transparent,
                          // Top Circle with icon
                          maxRadius: 20.0,
                          child: Image.asset('assets/images/no-internet.png'),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.transparent,
                          // Top Circle with icon
                          maxRadius: 20.0,
                          child: Image.asset('assets/images/errorimage.png'),
                        ),
                  const SizedBox(width: 10),
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.content,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              OverflowBar(
                // buttonMinWidth: 100,
                alignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: Text(widget.negativeBtnText),
                    onPressed: () => Get.back(),
                  ),
                  TextButton(
                    onPressed: widget.positiveBtnPressed,
                    child: Text(widget.positiveBtnText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
