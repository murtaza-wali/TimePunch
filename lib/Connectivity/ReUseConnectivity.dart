import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class ReuseOffline {
  @override
  getoffline(Widget child) {
    return OfflineBuilder(
      connectivityBuilder: (BuildContext context,
          ConnectivityResult connectivity, Widget child) {
        final bool connected = connectivity != ConnectivityResult.none;
        return Stack(
          fit: StackFit.expand,
          children: [
            child,
            Positioned(
              left: 0.0,
              right: 0.0,
              height: 32.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                color: connected ? Color(0xFFFFFF) : Color(0xFFEE4400),
                child: connected
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  ],
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('OFFLINE',
                        style: TextStyle(color: Colors.white)),
                    SizedBox(width: 8.0),
                    SizedBox(
                      width: 12.0,
                      height: 12.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      child: child,
    );
  }
}