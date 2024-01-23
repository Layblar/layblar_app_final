import 'package:flutter/material.dart';

import '../Themes/Styles.dart';
class DeviceListItem extends StatefulWidget {
  const DeviceListItem({
    Key? key,
    required this.title,
    required this.imgUrl,
  }) : super(key: key);

  final String title;
  final String imgUrl;

  @override
  State<DeviceListItem> createState() => _DeviceListItemState();
}

//TODO: this is not very nicley codes, later we will use json isntead
class _DeviceListItemState extends State<DeviceListItem> {

  @override
  Widget build(BuildContext context) {
    return DropdownMenuItem(
      child: ListTile(
        leading: Image.network(widget.imgUrl),
        title: Text(widget.title, style: Styles.regularTextStyle,)
      ), value: widget.title
    );
    
  }
}




