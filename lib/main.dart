import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sort_vizualization/sort_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Sort algorithms'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GetBuilder<SortController>(
          init: Get.put(SortController()),
          builder: (controller) {
            // return Text(controller.size.toString());
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 5,
                ),
                SettingsElement(
                  title: "Elements amount",
                  child: Slider(
                    value: controller.size.toDouble(),
                    min: 1,
                    max: 101,
                    divisions: 100,
                    label: controller.size.toString(),
                    onChanged: (double value) {
                      controller.updateSize(size: value.toInt());
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => SettingsElement(
                    title: "Sort method",
                    child: DropdownButton(
                      items: SortController.sortTypes.map((String e) {
                        return DropdownMenuItem<String>(
                            value: e, child: Text(e));
                      }).toList(),
                      onChanged: (dynamic value) {
                        controller.updateSelectedSort(type: value as String);
                      },
                      value: SortController
                          .sortTypes[controller.selectedSortType.value],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: LayoutBuilder(builder: (context, constraints) {
                    final height = constraints.maxHeight;
                    final maxElement = controller.lst.value.reduce(max);
                    return Obx(() => Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...[
                              for (int i = 0; i < controller.size; i++)
                                Flexible(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    padding: controller.size <= 20
                                        ? const EdgeInsets.all(2)
                                        : null,
                                    height: height *
                                        controller.lst.value[i] /
                                        maxElement,
                                    color: i == controller.selectedInd.value
                                        ? Theme.of(context).errorColor
                                        : Theme.of(context).primaryColor,
                                    child: Text(
                                      // controller.size <= 20
                                      // ?
                                      controller.lst.value[i].toString(),
                                      // : ' ',
                                      style: TextStyle(
                                          color: controller.size <= 20
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.color
                                              : Colors.transparent),
                                    ),
                                  ),
                                ),
                            ]
                          ],
                        ));
                  }),
                ),
                const SizedBox(
                  height: 20,
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () => controller.performSort(),
                    child: Text("Sort"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SettingsElement extends StatelessWidget {
  const SettingsElement({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        child,
      ],
    );
  }
}
