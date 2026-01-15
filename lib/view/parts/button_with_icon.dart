import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {
  final VoidCallback? onPressed;
  final Icon icon;
  final String label;
  final Color color;

  ButtonWithIcon({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.color,
  });

  //このコードは、画面いっぱいの幅で高さ50ピクセルのボタンを作成します。
  // ボタンにはアイコンとテキストがあり、角は丸くなっています。
  // ボタンの色や押されたときの動作は、他の部分で定義されている color と onPressed によって決まります。

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      child: SizedBox(
        width: double.infinity,
        height: 50.0,
        child: ElevatedButton.icon(
          onPressed:onPressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white70,
                minimumSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                )
            ),
            icon: icon,
            label: Text(
              label,
              style:TextStyle(fontSize:20.0),
            )),
      ),
    );
  }
}
