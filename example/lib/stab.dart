/// tab 切换组件
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
// import 'package:flutter_swiper/flutter_swiper.dart';
// import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart'

class STab extends StatefulWidget {
  // tab 集合
  final List<Widget> tabs;

  // 页面集合
  final List<Widget> pages;

  STab({required this.tabs, required this.pages});

  @override
  _STabState createState() => _STabState();
}

class _STabState extends State<STab> {
  int selectedIndex = 0;
  SwiperController swipeControl = new SwiperController();

  // tab 索引变化回调
  void onTabChange(index) {
    setState(() {
      selectedIndex = index;
    });
    swipeControl.move(index);
  }

  void onCancelClick() {
    print('cancel');
  }

  void onPageChange(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        TabLayout(widget.tabs, selectedIndex, onTabChange, onCancelClick),
        ContentLayout(widget.pages, swipeControl, onPageChange)
      ],
    ));
  }
}

/// 上面 Tab 的布局
Widget TabLayout(tabs, selectedIndex, onTabChange, onRightButtonClick) {
  List<Widget> getItem() {
    List<Widget> children = [];
    for (var i = 0; i < tabs.length; i++) {
      children.add(
        GestureDetector(
            onTap: () {
              onTabChange(i);
            },
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: selectedIndex == i
                              ? Color(0xff595959)
                              : Colors.transparent,
                          width: 3))),
              child: tabs[i],
            )),
      );
    }
    return children;
  }

  return Stack(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: getItem(),
      ),
      Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            child: Container(
              height: 40,
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),

            ),
            onTap: () {
              onRightButtonClick();
            },
          ))
    ],
  );
}

/// 下面页面内容布局
Widget ContentLayout(pages, swipeControl, onIndexChanged) {
  return Expanded(
    child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Swiper(
          itemCount: pages.length,
          itemBuilder: (BuildContext context, int index) {
            return pages[index];
          },
          loop: false,
          onIndexChanged: (index) {
            onIndexChanged(index);
          },
          controller: swipeControl,
        )),
  );
}
