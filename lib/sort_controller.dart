import 'package:get/get.dart';

class SortController extends GetxController {
  late RxList<int> lst = <int>[].obs;
  int size = 40;
  RxInt selectedInd = (-1).obs;

  RxInt selectedSortType = 0.obs;

  RxBool needStop = false.obs;

  int baseTimeLimit = 50;

  RxInt selectedSpeed = 1.obs;

  RxBool sortInProgress = false.obs;

  static const List<String> sortTypes = [
    "Bubble sort",
    "Gnome sort",
    "Cocktail shaker sort",
    "Insertion sort",
    "Selection sort",
  ];

  @override
  void onInit() {
    super.onInit();
    generateList();
  }

  void updateSize({required int size}) {
    setNeedStop();
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

  void updateSelectedSpeed({required int speed}) {
    selectedSpeed.value = speed;
    update();
  }

  Future<void> performSort() async {
    sortInProgress.value = true;
    update();
    needStop.value = false;
    switch (selectedSortType.value) {
      case 0:
        await bubbleSort();
        break;
      case 1:
        await gnomeSort();
        break;
      case 2:
        await shakerSort();
        break;
      case 3:
        await insertionSort();
        break;
      case 4:
        await selectionSort();
        break;
      default:
        lst.sort();
    }
    sortInProgress.value = false;
    selectedInd.value = -1;
    update();
  }

  Future<void> setNeedStop() async {
    needStop.value = true;
    update();
    await Future.delayed(50.milliseconds);
    sortInProgress.value = false;
    update();
  }

  Future<void> selectionSort() async {
    for (int i = 0; i < size - 1; i++) {
      for (int j = i + 1; j < size; j++) {
        if (needStop.value) {
          updateSelectedInd(-1);
          return;
        }
        updateSelectedInd(j);
        if (lst[j] < lst[i]) {
          swapElements(i, j);
        }
        await Future.delayed(
            (baseTimeLimit / selectedSpeed.value).milliseconds);
      }
    }
  }

  Future<void> bubbleSort() async {
    for (int i = 0; i < size - 1; i++) {
      for (int j = 0; j < size - i - 1; j++) {
        if (needStop.value) {
          updateSelectedInd(-1);
          return;
        }
        updateSelectedInd(j);
        if (lst[j] > lst[j + 1]) {
          swapElements(j, j + 1);
        }
        await Future.delayed(
            (baseTimeLimit / selectedSpeed.value).milliseconds);
      }
    }
  }

  Future<void> shakerSort() async {
    bool swapped = false;
    do {
      swapped = false;
      for (int i = 0; i < size - 2; i++) {
        if (needStop.value) {
          updateSelectedInd(-1);
          return;
        }
        updateSelectedInd(i);
        if (lst[i] > lst[i + 1]) {
          swapElements(i, i + 1);
          swapped = true;
        }
        await Future.delayed(
            (baseTimeLimit / selectedSpeed.value).milliseconds);
      }
      if (!swapped) {
        break;
      }
      swapped = false;
      for (int i = size - 2; i >= 0; i--) {
        if (needStop.value) {
          updateSelectedInd(-1);
          return;
        }
        updateSelectedInd(i);

        if (lst[i] > lst[i + 1]) {
          swapElements(i, i + 1);
          swapped = true;
        }
        await Future.delayed(
            (baseTimeLimit / selectedSpeed.value).milliseconds);
      }
    } while (swapped);
  }

  Future<void> insertionSort() async {
    for (int i = 0; i < size; i++) {
      if (needStop.value) {
        updateSelectedInd(-1);
        return;
      }
      updateSelectedInd(i);
      int key = lst[i];
      int j = i - 1;
      updateSelectedInd(j);

      while (j >= 0 && key < lst[j]) {
        if (needStop.value) {
          updateSelectedInd(-1);
          return;
        }
        lst[j + 1] = lst[j];
        j -= 1;
        updateSelectedInd(j);
        await Future.delayed(
            (baseTimeLimit / selectedSpeed.value).milliseconds);
      }
      lst[j + 1] = key;
      await Future.delayed((baseTimeLimit / selectedSpeed.value).milliseconds);
    }
  }

  Future<void> gnomeSort() async {
    int i = 1;
    int j = 2;
    while (i < size) {
      if (needStop.value) {
        updateSelectedInd(-1);
        return;
      }
      if (lst[i - 1] < lst[i]) {
        i = j;
        updateSelectedInd(i);
        j += 1;
      } else {
        swapElements(i, i - 1);
        i -= 1;
        if (i == 0) {
          i = j;
          j += 1;
        }
        updateSelectedInd(i);
      }
      await Future.delayed((baseTimeLimit / selectedSpeed.value).milliseconds);
    }
  }

  void swapElements(i, j) {
    final int tmp = lst[i];
    lst[i] = lst[j];
    lst[j] = tmp;
    update();
  }

  void defaultSort(bool descending) {
    if (descending) {
      lst.sort((a, b) => b.compareTo(a));
    } else {
      lst.sort();
    }
    update();
  }

  void shuffleList() {
    lst.shuffle();
    update();
  }

  void updateSelectedInd(int ind) {
    selectedInd.value = ind;
    update();
  }
}
