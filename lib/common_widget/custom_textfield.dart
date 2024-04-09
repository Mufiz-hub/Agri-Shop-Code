import 'package:project_final_year/consts/consts.dart';

Widget customTextField({String? title, String? hint, conroller, isPass}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title!.text.color(redColor).size(16).fontFamily(semibold).make(),
      5.heightBox,
      TextFormField(
        obscureText: isPass,
        controller: conroller,
        decoration: InputDecoration(
            hintStyle:
                const TextStyle(fontFamily: semibold, color: textfieldGrey),
            hintText: hint,
            isDense: true,
            fillColor: lightGrey,
            filled: true,
            border: InputBorder.none,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
              color: redColor,
            ))),
      ),
      5.heightBox,
    ],
  );
}
