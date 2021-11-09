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
      title: 'Sort visualization',
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
    const space = SizedBox(
      height: 10,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GetBuilder<SortController>(
          init: Get.put(SortController()),
          builder: (controller) {
            // return Text(controller.size.toString());
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).dividerColor,
                          offset: const Offset(4, 4),
                          blurRadius: 5,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        SettingsElement(
                          title: "Elements amount: ${controller.size}",
                          child: Slider(
                            value: controller.size.toDouble(),
                            min: 10,
                            max: 99,
                            divisions: 90,
                            label: controller.size.toString(),
                            onChanged: (double value) {
                              controller.updateSize(size: value.toInt());
                            },
                          ),
                        ),
                        space,
                        Obx(
                          () => SettingsElement(
                            title: "Sort method",
                            child: DropdownButton(
                              items: SortController.sortTypes.map((String e) {
                                return DropdownMenuItem<String>(
                                    value: e, child: Text(e));
                              }).toList(),
                              onChanged: (dynamic value) {
                                controller.updateSelectedSort(
                                    type: value as String);
                              },
                              value: SortController
                                  .sortTypes[controller.selectedSortType.value],
                            ),
                          ),
                        ),
                        space,
                        SettingsElement(
                          title:
                              "Vizualization speed: ${controller.selectedSpeed}",
                          child: Slider(
                            value: controller.selectedSpeed.toDouble(),
                            min: 1,
                            max: 10,
                            divisions: 11,
                            label: controller.selectedSpeed.toString(),
                            onChanged: (double value) {
                              controller.updateSelectedSpeed(
                                  speed: value.toInt());
                            },
                          ),
                        ),
                        space,
                        Obx(
                          () => AbsorbPointer(
                            absorbing: controller.sortInProgress.value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Obx(
                                  () => ElevatedButton(
                                    onPressed: () =>
                                        controller.defaultSort(true),
                                    style: ButtonStyle(
                                      backgroundColor: controller
                                              .sortInProgress.value
                                          ? MaterialStateProperty.all(
                                              const Color(0xFFF0F0F0),
                                            )
                                          : MaterialStateProperty.all(
                                              Theme.of(context).primaryColor,
                                            ),
                                    ),
                                    child: const Text(
                                      "Worst case",
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => ElevatedButton(
                                    onPressed: () => controller.shuffleList(),
                                    style: ButtonStyle(
                                      backgroundColor: controller
                                              .sortInProgress.value
                                          ? MaterialStateProperty.all(
                                              const Color(0xFFF0F0F0),
                                            )
                                          : MaterialStateProperty.all(
                                              Theme.of(context).primaryColor,
                                            ),
                                    ),
                                    child: const Text(
                                      "Shuffle array",
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => ElevatedButton(
                                    onPressed: () =>
                                        controller.defaultSort(false),
                                    style: ButtonStyle(
                                      backgroundColor: controller
                                              .sortInProgress.value
                                          ? MaterialStateProperty.all(
                                              const Color(0xFFF0F0F0),
                                            )
                                          : MaterialStateProperty.all(
                                              Theme.of(context).primaryColor,
                                            ),
                                    ),
                                    child: const Text(
                                      "Best case",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Obx(
                          () => ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: controller.sortInProgress.value
                                    ? MaterialStateProperty.all(
                                        Theme.of(context).errorColor)
                                    : MaterialStateProperty.all(
                                        Theme.of(context).primaryColor)),
                            onPressed: () => controller.sortInProgress.value
                                ? controller.setNeedStop()
                                : controller.performSort(),
                            child: controller.sortInProgress.value
                                ? const Text(
                                    "Stop",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                : const Text(
                                    "Sort",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ],
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
                                      // child: Text(
                                      //   controller.lst.value[i].toString(),
                                      //   style: TextStyle(
                                      //       color: controller.size <= 20
                                      //           ? Theme.of(context)
                                      //               .textTheme
                                      //               .bodyText1
                                      //               ?.color
                                      //           : Colors.transparent),
                                      // ),
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
                ],
              ),
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
