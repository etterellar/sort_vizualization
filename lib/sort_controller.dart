import 'dart:io';

import 'package:get/get.dart';

class SortController extends GetxController {
  late RxList<int> lst = <int>[].obs;
  int size = 40;
  RxInt selectedInd = (-1).obs;

  RxInt selectedSortType = 0.obs;

  static const List<String> sortTypes = [
    "Bubble Sort",
    "Gnome sort",
    "Quick Sort",
    "Shaker Sort"
  ];

  @override
  void onInit() {
    super.onInit();
    generateList();
  }

  void updateSize({required int size}) {
    this.size = size;
    generateList();
    update();
  }

  void generateList() {
    final tmplst = Iterable<int>.generate(100).toList()..remove(0);
    tmplst.shuffle();
    lst.value = tmplst.sublist(0, size);
    update();
  }

  void updateSelectedSort({required String type}) {
    selectedSortType.value = sortTypes.indexOf(type);
    update();
  }

  void performSort() {
    switch (selectedSortType.value) {
      case 0:
        bubbleSort();
        break;
      default:
        lst.sort();
    }
    update();
  }

  Future<void> bubbleSort() async {
    for (int i = 0; i < size - 1; i++) {
      bool flag = false;
      for (int j = 0; j < size - i - 1; j++) {
        selectedInd.value = j;
        update();
        if (lst[j] > lst[j + 1]) {
          final int tmp = lst[j];
          lst[j] = lst[j + 1];
          lst[j + 1] = tmp;
          update();
          // flag = true;
        }
        await Future.delayed(20.milliseconds);
      }
      // if (!flag) {
      //   break;
      // }
    }
  }
}
