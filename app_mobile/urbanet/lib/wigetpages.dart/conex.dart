// import 'package:flutter/material.dart';
// import 'package:connectivity/connectivity.dart';

// class ConnectionChecker extends StatefulWidget {
//   @override
//   _ConnectionCheckerState createState() => _ConnectionCheckerState();
// }

// class _ConnectionCheckerState extends State<ConnectionChecker> {
//   late ConnectivityResult _connectionStatus;

//   @override
  
//   Future<void> checkConnection() async {
//     final ConnectivityResult connectivityResult =
//         await Connectivity().checkConnectivity();
//     setState(() {
//       _connectionStatus = connectivityResult;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Connection Checker'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Connection Status:',
//             ),
//             Text(
//               _connectionStatus.toString(),
//               style: TextStyle(fontSize: 24),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
