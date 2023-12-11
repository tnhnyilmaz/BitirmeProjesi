import 'package:egitim/compenents/generalAppbar.dart';
import 'package:egitim/const/textStyle.dart';
import 'package:flutter/material.dart';

class CozumListeleme extends StatelessWidget {
  const CozumListeleme({super.key});

  @override
  Widget build(BuildContext context) {
    StyleTextProject styleTextProject = StyleTextProject();
    return Scaffold(
        appBar: GeneralAppBar(
            styleTextProject: styleTextProject, title: "Çözümler"),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: Sizing().width,
                  height: Sizing().height * 0.2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.amber),
                  child: Center(
                      child: Text(
                    "SORUN",
                    style: styleTextProject.ListeSorun,
                  )),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: ListView.builder(
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
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            "$sayac-",
                                            style:
                                                styleTextProject.ListelemeSayac,
                                          )),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Çözüm",
                                          style: styleTextProject.ListeSorun,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
                },
              ),
            ),
          ],
        ));
  }
}
