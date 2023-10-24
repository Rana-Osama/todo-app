import 'package:flutter/material.dart';

typedef Validator =  String ? Function (String?);

class CustomFormField  extends StatefulWidget {
  String hint;
  TextInputType keyboardType ;
  bool secureText ;
  Validator ? validator;
  TextEditingController ? controller;
  int lines ;
  IconData? icon ;



  CustomFormField({
    required this.hint, this.keyboardType = TextInputType.text, this.secureText = false,
    this.validator,this.controller,this.lines = 1,this.icon
});

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.hint,
        suffixIcon: IconButton(
          icon: Icon (widget.icon),
          onPressed: (){
            setState(() {
              widget.secureText = !widget.secureText ;
            });
          },
        )

      ),
      keyboardType: widget.keyboardType,
      obscureText: widget.secureText ,
      validator: widget.validator,
      controller: widget.controller,
      maxLines: widget.lines,
      minLines: widget.lines,


    );
  }
}
