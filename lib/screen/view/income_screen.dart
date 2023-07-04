import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income_expence/screen/model.dart';
import 'package:income_expence/utils/db_helper.dart';

import '../controller/income_controller.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({Key? key}) : super(key: key);

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  TextEditingController txtamount = TextEditingController();
  TextEditingController txtnotes = TextEditingController();
  Incomecontroller controller = Get.put(Incomecontroller());
  String selct = 'Income';


  Map m1={};
  @override
  void initState() {
        super.initState();
        m1=Get.arguments;
        if(m1['option']==0)
          {
            int index=m1['index'];
            txtamount=TextEditingController(text: "${controller.dataList[index]['amount']}");
            txtnotes=TextEditingController(text: controller.dataList[index]['note']);
          }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(m1["option"]==0?"update":"Income"),
          actions: [
            IconButton(
              onPressed: () async {
                // DateTime? picker=await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2050));
                // controller.datetime.value=controller.setDateFormat(picker!);
              },
              icon: Icon(Icons.calendar_month),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 100,
                width: 100,
                child: ElevatedButton(
                    onPressed: () async {
                      DateTime? picker = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2050));
                      controller.datetime.value=picker as String;
                      // controller.dateTime.value =
                      //     controller.setDateFormat(picker!);
                    },
                    child: Obx(() => Text("${controller.datetime.value}"))),
              ),
              buildTextField(
                  hint: "Amount",
                  inputype: TextInputType.number,
                  controller: txtamount),
              buildTextField(
                  hint: "notes",
                  inputype: TextInputType.text,
                  controller: txtnotes),
              ElevatedButton(
                onPressed: () {

                  if(m1["option"]==0)
                    {
                      IncomeModel model=IncomeModel(id: controller.dataList[m1['index']['id']],amount: int.parse(txtamount.text),note: txtnotes.text);
                      DBhelper.dBhelper.update(model);
                    }


                  else{
                    IncomeModel model = IncomeModel(
                        amount: int.parse(txtamount.text), note: txtnotes.text);
                    DBhelper.dBhelper.insertdb(model: model);
                  }




                  controller.getData();
                  Get.back();
                },
                child: Text("Sumit"),
              ),
              // Container(
              //   height: 200,
              //   child: Column(
              //     children: [
              //       RadioListTile(
              //         value: "Income",
              //         groupValue: selct,
              //         onChanged: (value) {
              //           setState(() {
              //             selct = value!;
              //           });
              //         },
              //         title: Text("Income"),
              //       ),
              //       ListTile(
              //         title: Text("Expance/income"),
              //       ),
              //       // Obx(
              //       //       () =>
              //       //       DropdownButton(
              //       //         value: controller.selctExpance,
              //       //         items: controller.expanceList.map((element) =>
              //       //             DropdownMenuItem(child: Center(
              //       //               child: Text("$element"),), value: element,),),
              //       //         onChanged: (value) {
              //       //           controller.selctExpance.value = value! as String;
              //       //         },),
              //       // ),
              //
              //       Obx(
              //         () =>  DropdownButton(
              //             items: controller.expanceList.value.map((e) =>
              //                 DropdownMenuItem(child: Center(child: Text("$e"),),
              //                   value: e,)).toList(),
              //             value: controller.selctExpance,
              //             onChanged: (value) {
              //               controller.selctExpance!.value=value as String;
              //             },),
              //       ),
              //
              //       RadioListTile(
              //         value: "Expance",
              //         groupValue: selct,
              //         onChanged: (value) {
              //           setState(() {
              //             selct = value!;
              //           });
              //         },
              //         title: Text("Expance"),
              //       ),
              //
              //     ],
              //   ),
              // )
            ],

          ),
        ),
      ),
    );
  }

  TextField buildTextField({hint, inputype, controller}) {
    return TextField(
      controller: controller,
      keyboardType: inputype,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "$hint",
        label: Text("$hint"),
      ),
    );
  }
}
