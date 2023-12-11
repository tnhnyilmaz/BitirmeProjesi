import 'package:egitim/compenents/generalAppbar.dart';
import 'package:egitim/const/textStyle.dart';
import 'package:flutter/material.dart';

class SorunListeleme extends StatefulWidget {
  const SorunListeleme({super.key});

  @override
  State<SorunListeleme> createState() => _SorunListelemeState();
}

class _SorunListelemeState extends State<SorunListeleme> {
  late List<bool> _isExpandedList;
  // ALT CONTAINERLARIN ÇIKIP ÇIKMAMAMSINI KONTROL EDEN DEĞİŞKENİMİZ

  @override
  void initState() {
    super.initState();
    _isExpandedList = List.generate(10, (index) => false);
    //LİSTEMİZİ BURADA İLK DEFA BAŞLATIYORUZ. LİSTE BOYUTUNA GÖRE BOYUTLANIYOR VE
    //FALSE ATANIYOR.
  }

  @override
  Widget build(BuildContext context) {
    StyleTextProject styleTextProject = StyleTextProject();

    return Scaffold(
        appBar: GeneralAppBar(
            styleTextProject: styleTextProject, title: "Tüm Sorunları"),
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            int sayac = index + 1;
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Card(
                    child: Column(
                      children: [
                        Container(
                          width: Sizing().width,
                          height: Sizing().height * 0.1,
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: _isExpandedList[index]
                                  ? const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15))
                                  : BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "$sayac-",
                                    style: styleTextProject.ListelemeSayac,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Sorunlar",
                                    style: styleTextProject.ListeSorun,
                                  ),
                                ),
                                Expanded(
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isExpandedList[index] =
                                                !_isExpandedList[index];
                                          });
                                        },
                                        icon: Icon(_isExpandedList[index]
                                            ? Icons.expand_less
                                            : Icons.expand_more)))
                              ],
                            ),
                          ),
                        ),
                        if (_isExpandedList[index])
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(15))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/SorunCozum');
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.amber,
                                    ),
                                    child:
                                        const Center(child: Text("Sorun Öner")),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, "/CozumListeleme");
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.amber,
                                    ),
                                    child: const Center(
                                        child: Text("Tüm çözümler")),
                                  ),
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ));
          },
        ));
  }
}
