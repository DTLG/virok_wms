// library input_with_keyboard_control;

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class InputWithKeyboardControl extends EditableText {
//   /// startShowKeyboard is initial value to show or not the keyboard when the widget is created, default value is false
//   final bool startShowKeyboard;

//   /// focusNode is responsible for controlling the focus of the field, this parameter is required
//   @override
//   final InputWithKeyboardControlFocusNode focusNode;

//   /// width is responsible for set the widget size, This parameter is required
//   final double width;

//   /// buttonColorEnabled is responsible for set color in button when is enabled, default value is Colors.blue
//   final Color buttonColorEnabled;

//   /// buttonColorDisabled is responsible for set color in button when is disabled, default value is Colors.black
//   final Color buttonColorDisabled;

//   /// underlineColor is responsible for set color in underline BorderSide, default value is Colors.black
//   final Color underlineColor;

//   /// showUnderline is responsible for showing or not the underline in the widget, default value is true
//   final bool showUnderline;

//   /// showButton is responsible for showing or not the button to control the keyboard, default value is true
//   final bool showButton;

//   InputWithKeyboardControl({
//     super.key,
//     required TextEditingController controller,
//     TextStyle style = const TextStyle(color: Colors.black, fontSize: 18),
//     Color cursorColor = Colors.black,
//     bool autofocus = true,
//     Color? selectionColor,
//     this.startShowKeyboard = false,
//     void Function(String)? onSubmitted,
//     required this.focusNode,
//     required this.width,
//     this.buttonColorEnabled = Colors.blue,
//     this.buttonColorDisabled = Colors.black,
//     this.underlineColor = Colors.black,
//     this.showUnderline = true,
//     this.showButton = true,
//   }) : super(
//           controller: controller,
//           focusNode: focusNode,
//           style: style,
//           cursorColor: cursorColor,
//           autofocus: autofocus,
//           selectionColor: selectionColor,
//           backgroundCursorColor: Colors.black,
//           onSubmitted: onSubmitted,
//         );

//   @override
//   EditableTextState createState() {
//     return InputWithKeyboardControlState(
//         startShowKeyboard,
//         focusNode,
//         width,
//         buttonColorEnabled,
//         buttonColorDisabled,
//         underlineColor,
//         showUnderline,
//         showButton);
//   }
// }

// class InputWithKeyboardControlState extends EditableTextState {
//   /// showKeyboard is initial value to show or not the keyboard when the widget is created, default value is false
//   bool showKeyboard;

//   /// focusNode is responsible for controlling the focus of the field, this parameter is required
//   final InputWithKeyboardControlFocusNode focusNode;

//   /// width is responsible for set the widget size, This parameter is required
//   final double width;

//   /// buttonColorEnabled is responsible for set color in button when is enabled, default value is Colors.blue
//   final Color buttonColorEnabled;

//   /// buttonColorDisabled is responsible for set color in button when is disabled, default value is Colors.black
//   final Color buttonColorDisabled;

//   /// underlineColor is responsible for set color in underline BorderSide, default value is Colors.black
//   final Color underlineColor;

//   /// showUnderline is responsible for showing or not the underline in the widget, default value is true
//   final bool showUnderline;

//   /// showButton is responsible for showing or not the button to control the keyboard, default value is true
//   final bool showButton;

//   // funcionListener is responsible for controller focusNode listener
//   late Function funcionListener;

//   @override
//   void initState() {
//     funcionListener = () {
//       if (focusNode.hasFocus) requestKeyboard();
//     };

//     focusNode.addListener(funcionListener as void Function());
//     super.initState();
//   }

//   @override
//   void dispose() {
//     focusNode.removeListener(funcionListener as void Function());
//     super.dispose();
//   }

//   InputWithKeyboardControlState(
//       this.showKeyboard,
//       this.focusNode,
//       this.width,
//       this.buttonColorEnabled,
//       this.buttonColorDisabled,
//       this.underlineColor,
//       this.showUnderline,
//       this.showButton);



//   toggleShowKeyboard(bool value) {
//     setState(() {
//       showKeyboard = !value;
//     });

//     if (!showKeyboard) {
//       SystemChannels.textInput.invokeMethod('TextInput.hide');
//       focusNode.requestFocus();
//     } else {
//       SystemChannels.textInput.invokeMethod('TextInput.show');
//       focusNode.requestFocus();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget widget = super.build(context);
//     return Container(
//         height: 60,
//         decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey),
//             borderRadius: BorderRadius.circular(18)),
//         padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//                 child: Stack(
//               children: [
//                 widget,
//                 const Text(
//                   'Відсккануйте комірку',
//                   style: TextStyle(
//                       fontSize: 16, color: Color.fromARGB(154, 0, 0, 0)),
//                 )
//               ],
//             )),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                     constraints: BoxConstraints(),
//                     alignment: Alignment.centerRight,
//                     padding: EdgeInsets.zero,
//                     onPressed: () {
//                     },
//                     icon: const Icon(
//                       Icons.close,
//                       color: Colors.grey,
//                     )),
//                 IconButton(
//                     constraints: BoxConstraints(),
//                     alignment: Alignment.centerRight,
//                     padding: EdgeInsets.only(right: 10, left: 7),
//                     onPressed: () {
//                       toggleShowKeyboard(showKeyboard);
//                     },
//                     icon: const Icon(
//                       Icons.keyboard_alt_outlined,
//                       color: Colors.grey,
//                     )),
//               ],
//             )
//           ],
//         ));
//   }

//   @override
//   void requestKeyboard() {
//     super.requestKeyboard();

//     if (!showKeyboard) SystemChannels.textInput.invokeMethod('TextInput.hide');
//   }
// }

// class InputWithKeyboardControlFocusNode extends FocusNode {
//   @override
//   bool consumeKeyboardToken() {
//     return false;
//   }
// }
