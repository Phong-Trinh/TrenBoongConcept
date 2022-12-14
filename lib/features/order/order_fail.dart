import 'package:flutter/material.dart';
import 'home_button.dart';
import 'order_result.dart';

class OrderFail extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const OrderFail(
      {super.key, required this.screenWidth, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 170,
          padding: EdgeInsets.all(35),
          decoration: BoxDecoration(
            color: themeColor,
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            "assets/image/card.png",
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: screenHeight * 0.1),
        Text(
          "Thất bại!",
          style: TextStyle(
            color: themeColor,
            fontWeight: FontWeight.w600,
            fontSize: 36,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          "Giao dịch bị gián đoạn",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w400,
            fontSize: 17,
          ),
        ),
        SizedBox(height: screenHeight * 0.05),
        Text(
          "Có vấn đề với đơn hàng của bạn, vui lòng kiểm tra đơn hàng và thử lại",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        SizedBox(height: screenHeight * 0.06),
        Flexible(
            child: HomeButton(
          title: 'Trở về',
          onTap: () {
            Navigator.pop(context);
          },
        ))
      ],
    );
  }
}
