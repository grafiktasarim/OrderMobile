import 'package:flutter/material.dart';
import 'package:order/models/finished_model.dart';
import 'package:order/services/finished_database_helper.dart';
import 'package:order/settings/theme.dart';
import 'package:provider/provider.dart';

class SeeAllPage extends StatefulWidget {
  const SeeAllPage({super.key});

  @override
  State<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  double fiyat = 0;
  double alacak = 0;
  double gelir = 0;
  double gider = 0;
  //---------------
  // bool odemeYapildi = false;

  @override
  void initState() {
    super.initState();

    updateTotalPrice();
  }

  Future<void> updateTotalPrice() async {
    double toplamFiyat = await FinishedDatabaseHelper.instance.getTotalPrice();
    double toplamAlinan = await FinishedDatabaseHelper.instance.getTotalPaid();
    double toplamGider = await FinishedDatabaseHelper.instance.getTotalLoss();
    //----------------------------------------------------------
    double fixedPrice = double.parse((toplamFiyat).toStringAsFixed(2));
    double fixedLoss = double.parse((toplamGider).toStringAsFixed(2));
    //----------------------------------------------------------
    setState(() {
      fiyat = fixedPrice;
      alacak = fixedPrice - toplamAlinan;
      gelir = fixedPrice - fixedLoss;
      gider = fixedLoss;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDark;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                      });
                    },
                    icon: Icon(Icons.brightness_6, color: isDark ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                upside(context, "Gelir", "${double.parse((gelir).toStringAsFixed(2))} ₺", Colors.green, isDark),
                // upside(context, "Alacak", "${double.parse((alacak).toStringAsFixed(2))} ₺", Colors.amber, isDark),
                upside(context, "Gider", "${double.parse((gider).toStringAsFixed(2))} ₺", Colors.red, isDark),
              ],
            ),
            const SizedBox(height: 10),
            Text("Toplam Sipariş : $fiyat ₺", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: 10),
            FutureBuilder(
              future: FinishedDatabaseHelper.instance.getOrderList(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return snapshot.data!.isEmpty
                      ? Expanded(child: Center(child: Text("Henüz kayıt yok", style: TextStyle(color: isDark ? Colors.white : Colors.black))))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var finished = snapshot.data![index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Card(
                                  elevation: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("${finished!.name}",
                                                style: TextStyle(
                                                    fontSize: 18, color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                                            IconButton(
                                              onPressed: () {
                                                sil(finished);
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: isDark ? Colors.white : Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Fiyat : ${finished.price} ₺",
                                                style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black)),
                                            Text("${finished.count} Adet \"${finished.type.toUpperCase()}\"",
                                                style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Gelir : ${double.parse((finished.price! - finished.loss!).toStringAsFixed(2))} ₺",
                                                style: const TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold)),
                                            Text("Gider : ${double.parse((finished.loss!).toStringAsFixed(2))} ₺",
                                                style: const TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        /* finished.price! != finished.paid!
                                            ? ExpansionTile(
                                                title: const Text("Bakiye Detayı",
                                                    style: TextStyle(fontSize: 14, color: Colors.amber, fontWeight: FontWeight.bold)),
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Ödenen : ${double.parse((finished.paid!).toStringAsFixed(2))} ₺",
                                                        style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
                                                      ),
                                                      Text(
                                                        "Bakiye : ${double.parse((finished.price! - finished.paid!).toStringAsFixed(2))} ₺",
                                                        style: const TextStyle(fontSize: 14, color: Colors.amber, fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          backgroundColor: Colors.white,
                                                          content: const Text("Emin misin?"),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                              child: const Text(
                                                                "İptal",
                                                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  finished.price = finished.paid!;
                                                                  FinishedModel model = FinishedModel(
                                                                    name: finished.name,
                                                                    count: finished.count,
                                                                    price: finished.price!,
                                                                    paid: finished.paid,
                                                                    loss: finished.loss,
                                                                    type: finished.type,
                                                                  );
                                                                  FinishedDatabaseHelper.instance.updateOrder(model);
                                                                  updateTotalPrice();
                                                                  Navigator.pop(context);
                                                                });
                                                              },
                                                              child: const Text(
                                                                "Evet",
                                                                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    child: const Text("Ödeme yapıldı"),
                                                  ),
                                                ],
                                              )
                                            : Container(),*/
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                }
                return const Center(child: Text("An Error"));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget upside(BuildContext context, String text, String price, Color color, bool isDark) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.transparent,
            border: Border.all(
              color: color,
              width: 2,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(text, style: TextStyle(fontSize: 15, color: isDark ? Colors.white : Colors.black)),
            Text(price, style: TextStyle(fontSize: 19, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void sil(FinishedModel order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Silmek istediğine emin misin?'),
            ],
          ),
          actions: [
            Icon(Icons.delete, color: Colors.grey.shade500),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "İptal",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () async {
                FinishedDatabaseHelper.instance.deleteOrder(order);
                updateTotalPrice();
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text(
                "Evet",
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
