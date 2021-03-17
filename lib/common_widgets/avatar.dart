import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key key, this.photoURl,@required this.radius}) : super(key: key);

  final String  photoURl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(
        color: Colors.black54,
        width: 6.0
      )),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.black12,
        backgroundImage: photoURl != null ? NetworkImage(photoURl): null,
        child: photoURl == null ? Icon(Icons.person,size: radius,): null,
      ),
    );
  }
}
