import 'package:project_final_year/consts/consts.dart';

Widget ourButton({onpress, color, textColor, String? title}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.all(12) // Background color
          ),
      onPressed: onpress,
      child: title!.text.color(textColor).fontFamily(bold).make());
}

Widget myButton({onpress, color, textColor, String? title}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(), backgroundColor: redColor),
      onPressed: onpress,
      child: title!.text.color(textColor).fontFamily(bold).make());
}
