// import 'package:fitness_app/common/color_extension.dart';
// import 'package:fitness_app/common_widgets/round_textfield.dart';
// import 'package:fitness_app/common_widgets/rounded_button.dart';
// import 'package:fitness_app/models/user_model.dart';
// import 'package:fitness_app/screens/login/what_your_goal_view.dart';
// import 'package:flutter/material.dart';


// class CompleteProfileView extends StatefulWidget {
//   final UserModel userModel;

//   const CompleteProfileView({super.key, required this.userModel});

//   @override
//   State<CompleteProfileView> createState() => _CompleteProfileViewState();
// }

// class _CompleteProfileViewState extends State<CompleteProfileView> {
//   TextEditingController txtDate = TextEditingController();
//   TextEditingController txtWeight = TextEditingController();
//   TextEditingController txtHeight = TextEditingController();
//   String? _selectedGender;

//   @override
//   Widget build(BuildContext context) {
//     var media = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: TextColor.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       Image.asset(
//                         "assets/images/complete_profile.png",
//                         width: media.width,
//                         fit: BoxFit.fitWidth,
//                       ),
//                       SizedBox(
//                         height: media.width * 0.05,
//                       ),
//                       Text(
//                         "Let’s complete your profile",
//                         style: TextStyle(
//                           color: TextColor.black,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       Text(
//                         "It will help us to know more about you!",
//                         style: TextStyle(
//                           color: TextColor.gray,
//                           fontSize: 12,
//                         ),
//                       ),
//                       SizedBox(
//                         height: media.width * 0.05,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                         child: Column(
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: TextColor.lightGray,
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     alignment: Alignment.center,
//                                     width: 50,
//                                     height: 50,
//                                     padding: const EdgeInsets.symmetric(horizontal: 15),
//                                     child: Image.asset(
//                                       "assets/images/gender.png",
//                                       width: 20,
//                                       height: 20,
//                                       fit: BoxFit.contain,
//                                       color: TextColor.gray,
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: DropdownButtonHideUnderline(
//                                       child: DropdownButton<String>(
//                                         value: _selectedGender,
//                                         items: ["Male", "Female"]
//                                             .map((name) => DropdownMenuItem<String>(
//                                                   value: name,
//                                                   child: Text(
//                                                     name,
//                                                     style: TextStyle(
//                                                       color: TextColor.gray,
//                                                       fontSize: 14,
//                                                     ),
//                                                   ),
//                                                 ))
//                                             .toList(),
//                                         onChanged: (value) {
//                                           setState(() {
//                                             _selectedGender = value;
//                                           });
//                                         },
//                                         isExpanded: true,
//                                         hint: Text(
//                                           "Choose Gender",
//                                           style: TextStyle(
//                                             color: TextColor.gray,
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     width: 8,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: media.width * 0.04,
//                             ),
//                             GestureDetector(
//                               onTap: () async {
//                                 DateTime? pickedDate = await showDatePicker(
//                                   context: context,
//                                   initialDate: DateTime.now(),
//                                   firstDate: DateTime(1900),
//                                   lastDate: DateTime.now(),
//                                 );
//                                 if (pickedDate != null) {
//                                   setState(() {
//                                     txtDate.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//                                   });
//                                 }
//                               },
//                               child: AbsorbPointer(
//                                 child: RoundTextField(
//                                   controller: txtDate,
//                                   hitText: "Date of Birth",
//                                   icon: "assets/images/date.png",
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: media.width * 0.04,
//                             ),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: RoundTextField(
//                                     controller: txtWeight,
//                                     hitText: "Your Weight",
//                                     icon: "assets/images/weight.png",
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 8,
//                                 ),
//                                 Container(
//                                   width: 50,
//                                   height: 50,
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: TextColor.secondaryGradient,
//                                     ),
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   child: Text(
//                                     "KG",
//                                     style: TextStyle(
//                                       color: TextColor.white,
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                             SizedBox(
//                               height: media.width * 0.04,
//                             ),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: RoundTextField(
//                                     controller: txtHeight,
//                                     hitText: "Your Height",
//                                     icon: "assets/images/hight.png",
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 8,
//                                 ),
//                                 Container(
//                                   width: 50,
//                                   height: 50,
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: TextColor.secondaryGradient,
//                                     ),
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   child: Text(
//                                     "M",
//                                     style: TextStyle(
//                                       color: TextColor.white,
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                             SizedBox(
//                               height: media.width * 0.07,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               RoundedButton(
//                 title: "Next >",
//                 onPressed: () {
//                   // Save the additional information
//                   widget.userModel.gender = _selectedGender;
//                   widget.userModel.dateOfBirth = txtDate.text;
//                   widget.userModel.weight = txtWeight.text;
//                   widget.userModel.height = txtHeight.text;

//                   // Navigate to the next screen
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const WhatYourGoalView(),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:fitness/common/color_extension.dart';
import 'package:fitness/common_widgets/round_textfield.dart';
import 'package:fitness/common_widgets/rounded_button.dart';
import 'package:fitness/screens/login/what_your_goal_view.dart';
import 'package:flutter/material.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  TextEditingController txtDate = TextEditingController();
  TextEditingController txtWeight = TextEditingController();
  TextEditingController txtHeight = TextEditingController();
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TextColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/complete_profile.png",
                        width: media.width,
                        fit: BoxFit.fitWidth,
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Text(
                        "Let’s complete your profile",
                        style: TextStyle(
                          color: TextColor.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "It will help us to know more about you!",
                        style: TextStyle(
                          color: TextColor.gray,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: TextColor.lightGray,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: 50,
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Image.asset(
                                      "assets/images/gender.png",
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.contain,
                                      color: TextColor.gray,
                                    ),
                                  ),
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: selectedGender,
                                        items: ["Male", "Female"]
                                            .map((name) => DropdownMenuItem(
                                                  value: name,
                                                  child: Text(
                                                    name,
                                                    style: TextStyle(
                                                      color: TextColor.gray,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedGender = value;
                                          });
                                        },
                                        isExpanded: true,
                                        hint: Text(
                                          "Choose Gender",
                                          style: TextStyle(
                                            color: TextColor.gray,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: media.width * 0.04,
                            ),
                            RoundTextField(
                              controller: txtDate,
                              hitText: "Date of Birth",
                              icon: "assets/images/date.png",
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  txtDate.text = "${pickedDate.toLocal()}".split(' ')[0];
                                }
                              },
                              readOnly: true,
                            ),
                            SizedBox(
                              height: media.width * 0.04,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: RoundTextField(
                                    controller: txtWeight,
                                    hitText: "Your Weight",
                                    icon: "assets/images/weight.png",
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: TextColor.secondaryGradient,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    "KG",
                                    style: TextStyle(
                                      color: TextColor.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: media.width * 0.04,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: RoundTextField(
                                    controller: txtHeight,
                                    hitText: "Your Height",
                                    icon: "assets/images/hight.png",
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: TextColor.secondaryGradient,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    "M",
                                    style: TextStyle(
                                      color: TextColor.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: media.width * 0.07,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              RoundedButton(
                title: "Next >",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WhatYourGoalView(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
