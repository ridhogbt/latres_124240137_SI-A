// import 'package:flutter/material.dart';

// class ProfileView extends StatelessWidget {
//   const ProfileView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }


// class _ProfileViewState extends State<ProfileView> {
//   List<dynamic> characters = [];
//   bool isLoading = true;
//   String? errorMessage;

//   Future<void> handleLogout() async {
//     await AuthService.logout();

//     if (!mounted) return;

//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const LoginView(),
//       ),
//       (route) => false,
//     );

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Logout berhasil!'),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFFF7FC),
//       appBar: AppBar(
//         title: const Text('Harry Potter books'),
//         backgroundColor: Colors.brown,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             tooltip: 'Spells',
//             icon: const Icon(Icons.auto_awesome),
//             onPressed: openSpells,
//           ),
//           IconButton(
//             tooltip: 'Logout',
//             icon: const Icon(Icons.logout),
//             onPressed: handleLogout,
//           ),
//         ],
//       ),
//     ),
//   }
// }