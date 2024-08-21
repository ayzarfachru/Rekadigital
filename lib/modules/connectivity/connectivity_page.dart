import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConnectivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff87CEFA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildImage(),
            buildText(),
          ],
        ),
      ),
    );
  }

  Center buildText() {
    return Center(
      child: Text(
        textAlign: TextAlign.center,
        'Ups...\nSilahkan cek kembali jaringan anda',
        style: GoogleFonts.poppins(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400),
      ),
    );
  }

  Image buildImage() {
    return Image.asset(
      alignment: Alignment.bottomCenter,
      width: 180,
      height: 180,
      'assets/404.png',
      fit: BoxFit.contain,
    );
  }
}
