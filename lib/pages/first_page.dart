import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_02/components/color_tag.dart';
import 'package:flutter_demo_02/db/db.dart';
import 'package:flutter_demo_02/model/schemas.dart';
import 'package:realm/realm.dart';

const double gap = 20;

const List<Color> colorList = [
  Colors.lightGreen,
  Colors.lightBlue,
  Colors.black,
  Colors.pinkAccent,
  Colors.yellow,
  Colors.blueGrey,
];

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final FocusNode focusNode = FocusNode();

  Color currentColor = colorList.first;

  List<Tag> tagList = [];

  final _tagNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getTags();
  }

  @override
  void dispose() {
    _tagNameController.dispose();
    super.dispose();
  }

  void addData() {
    var name = _tagNameController.value.text;

    if (name.isEmpty) return;

    final tag = Tag(
      ObjectId(),
      name,
      currentColor.value.toString(),
      DateTime.now().toUtc(),
      DateTime.now().toUtc(),
    );

    DB.add<Tag>(tag);

    // setState(() {
    //   tagList.add(tag);
    // });

    _tagNameController.clear();
  }

  void getTags() async {
    print('path: ${DB.path}');

    final RealmResults<Tag> list = DB.queryAll<Tag>();

    setState(() {
      tagList = list.toList();
    });

    print('tagList: $tagList');

    addListListen(list);
  }

  void addListListen(RealmResults<Tag> result) {
    var subscription =
        result.changes.listen((RealmResultsChanges<Tag> changed) {
      print('inserted: ${changed.inserted}');
      print('deleted: ${changed.deleted}');
      print('modified: ${changed.modified}');
    });
  }

  void deleteTag(Tag tag) {
    DB.delete(tag);

    setState(() {
      tagList.remove(tag);
    });
  }

  void clearTag() {
    DB.clear<Tag>();

    setState(() {
      tagList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
        middle: const Text('标签管理'),
        trailing: GestureDetector(
          onTap: () {
            getTags();
          },
          child: const Icon(Icons.refresh),
        ),
        leading: GestureDetector(
          onTap: () {
            clearTag();
          },
          child: const Icon(Icons.delete),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: gap,
          ),
          child: Column(
            children: [
              Column(
                children: [
                  const SizedBox(height: gap),
                  SizedBox(
                    height: 40,
                    child: CupertinoTextField(
                      focusNode: focusNode,
                      controller: _tagNameController,
                      clearButtonMode: OverlayVisibilityMode.editing,
                      maxLength: 5,
                      onTapOutside: (event) {
                        focusNode.unfocus();
                      },
                    ),
                  ),
                  const SizedBox(height: gap),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: colorList.map((color) {
                      return ColorTag(
                          color: color,
                          isChecked: color == currentColor,
                          onPress: () {
                            if (currentColor != color) {
                              setState(() {
                                currentColor = color;
                              });
                            }
                          });
                    }).toList(),
                  ),
                  const SizedBox(height: gap),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      child: const Text('add'),
                      onPressed: () {
                        addData();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: gap),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: ColoredBox(
                    color: Colors.grey.withOpacity(0),
                    child: Scrollbar(
                      child: ListView(
                        children: tagList.map(
                          (tag) {
                            return SizedBox(
                              width: double.infinity,
                              // height: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Text(tag.id.toString()),
                                          Text(
                                            tag.name,
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).hintColor,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: Color(
                                                  int.parse(tag.background)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80,
                                      height: 40,
                                      child: CupertinoButton.filled(
                                        padding: const EdgeInsets.all(0),
                                        child: const Text('删除'),
                                        onPressed: () {
                                          deleteTag(tag);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
