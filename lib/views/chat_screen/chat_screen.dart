import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:project_final_year/common_widget/loding_indicator.dart';
import 'package:project_final_year/consts/consts.dart';
import 'package:project_final_year/controoller/chats_controller.dart';
import 'package:project_final_year/services/firestore_services.dart';
import 'package:project_final_year/views/chat_screen/components/sender_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatsController());

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
          title: "${controller.friendName}"
              .text
              .fontFamily(semibold)
              .color(darkFontGrey)
              .make()),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () => controller.isLoading.value
                  ? Center(
                      child: loadingIndicator(),
                    )
                  : Expanded(
                      child: StreamBuilder(
                      stream:
                          FirestorServices.getChatMessege(controller.chatDocId),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: loadingIndicator(),
                          );
                        } else if (snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: "Send A Messege."
                                .text
                                .color(darkFontGrey)
                                .make(),
                          );
                        } else {
                          return ListView(
                            children: snapshot.data!.docs
                                .mapIndexed((currentValue, index) {
                              var data = snapshot.data!.docs[index];
                              return Align(
                                  alignment: data['uid'] == currentUser!.uid
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: senderBubble(data));
                            }).toList(),
                          );
                        }
                      },
                    )),
            ),
            10.heightBox,
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.msgController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: textfieldGrey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: textfieldGrey)),
                        hintText: "Type a messege....."),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.sendMsg(controller.msgController.text);
                    controller.msgController.clear();
                  },
                  icon: Icon(
                    Icons.send,
                    color: redColor,
                  ),
                ),
              ],
            )
                .box
                .height(80)
                .padding(EdgeInsets.all(12))
                .margin(EdgeInsets.only(bottom: 8))
                .make(),
          ],
        ),
      ),
    );
  }
}
