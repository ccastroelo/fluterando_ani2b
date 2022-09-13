import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  String imageLink =
      'https://docs.flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png';
  String text =
      'liusdnclksan kjlscljljknc liuscnkjlsnc kljsanckjsncj clkjnsckjns ckjnclkjsn cskjncskj nckdsn clkjdcsnkjcn dsclkjkjdsnc ksnclknpjfd fjejfoeq fqoijfoij f foifqoi fnwjfoi jfi ncnn n ewnc oincin coin coin icçlikn coi';
  ScrollController scrollController = ScrollController();

  late List<Map<String, dynamic>> data;
  int lastOpen = -1;

  @override
  void initState() {
    super.initState();
    data = List.generate(
        50,
        (index) => {
              "title": "My expansion tile $index",
              "image": imageLink,
              "text": text,
              "open": false
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Animação 2")),
        body: ListView.builder(
            controller: scrollController,
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      data[index]["open"] = !data[index]["open"];
                      if (lastOpen != index && lastOpen > -1) {
                        data[lastOpen]["open"] = false;
                      }
                      if (data[index]["open"]) {
                        lastOpen = index;
                        scrollController.animateTo(32.0 * index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn);
                      } else {
                        lastOpen = -1;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                    child: MyExpansiontile(data: data[index]),
                  ));
            }));
  }
}

class MyExpansiontile extends StatefulWidget {
  const MyExpansiontile({
    super.key,
    required this.data,
  });

  final Map<String, dynamic> data;

  @override
  State<MyExpansiontile> createState() => _MyExpansiontileState();
}

class _MyExpansiontileState extends State<MyExpansiontile>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation rotateTween;
  late Animation expandeTween;
  late Animation colorTween;

  @override
  void didUpdateWidget(MyExpansiontile oldWidget) {
    if (widget.data["open"]) {
      open();
    } else {
      close();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    rotateTween = Tween(begin: 0.0, end: 3.14).animate(animationController);
    expandeTween = Tween(begin: 0.0, end: 1.0).animate(animationController);
    colorTween = ColorTween(begin: Colors.grey, end: Colors.blue)
        .animate(animationController);
  }

  open() {
    animationController.forward();
  }

  close() {
    animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text(widget.data["title"])),
                  Transform.rotate(
                    angle: rotateTween.value,
                    child: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: colorTween.value,
                    ),
                  )
                ],
              ),
              ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  heightFactor: expandeTween.value,
                  child: Column(
                    children: [
                      SizedBox(
                          height: 30,
                          child: Image.network(widget.data["image"])),
                      Text(widget.data["text"]),
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }
}
