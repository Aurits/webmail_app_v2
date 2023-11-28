import 'package:flutter/material.dart';
import 'package:makerere_webmail_app/models/mail.dart';

class EmailAdapter {
  List? emails = <Mail>[];
  List itemsTile = <ItemTile>[];

  EmailAdapter(this.emails, onItemClick) {
    for (int i = 0; i < emails!.length; i++) {
      itemsTile
          .add(ItemTile(index: i, object: emails![i], onClick: onItemClick));
    }
  }

  Widget getView() {
    return ListView.builder(
      itemCount: itemsTile.length,
      itemBuilder: (BuildContext context, int index) {
        return itemsTile[index];
      },
      padding: const EdgeInsets.symmetric(vertical: 5),
    );
  }
}

class ItemTile extends StatefulWidget {
  final int index;
  final Mail object;
  final Function(int, Mail) onClick;

  const ItemTile({
    Key? key,
    required this.index,
    required this.object,
    required this.onClick,
  }) : super(key: key);

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onClick(widget.index, widget.object);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 20,
            ),
            const SizedBox(
              width: 50,
              height: 50,
              child: CircleAvatar(),
            ),
            Container(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.object.subject,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                  Container(
                    height: 5,
                  ),
                  Text(
                    widget.object.message,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    height: 5,
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
