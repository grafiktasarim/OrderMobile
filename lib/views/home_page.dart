import 'dart:async';

import 'package:flutter/material.dart';
import 'package:order/models/finished_model.dart';
import 'package:order/models/order_model.dart';
import 'package:order/services/finished_database_helper.dart';
import 'package:order/services/order_database_helper.dart';
import 'package:order/settings/theme.dart';
import 'package:order/views/add_or_update_order.dart';
import 'package:order/views/see_all_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double fiyat = 0;
  double alacak = 0;
  double gelir = 0;
  double gider = 0;
  //---------------
  //bool odemeYapildi = false;

  @override
  void initState() {
    super.initState();
    updateTotalPrice();
  }

  Future<void> updateTotalPrice() async {
    double toplamFiyat = await OrderDatabaseHelper.instance.getTotalPrice();
    double toplamAlinan = await OrderDatabaseHelper.instance.getTotalPaid();
    double toplamGider = await OrderDatabaseHelper.instance.getTotalLoss();
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
    var isDark = Provider.of<ThemeProvider>(context).isDark;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              width: MediaQuery.of(context).size.width,
              height: 50,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AddOrUpdateOrder();
                          },
                        ),
                      );
                    },
                    icon: Icon(Icons.add, color: isDark ? Colors.white : Colors.black),
                  ),
                  TextButton(
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SeeAllPage(),
                            ),
                          ),
                      child: Text("> Bitmiş siparişleri gör <", style: TextStyle(color: isDark ? Colors.white : Colors.black))),
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
                upside(context, "Alacak", "${double.parse((alacak).toStringAsFixed(2))} ₺", Colors.amber, isDark),
                upside(context, "Gider", "${double.parse((gider).toStringAsFixed(2))} ₺", Colors.red, isDark),
              ],
            ),
            const SizedBox(height: 10),
            Text("Toplam Sipariş : $fiyat ₺", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
            FutureBuilder<List<OrderModel?>>(
              future: OrderDatabaseHelper.instance.getOrderList(),
              builder: (context, AsyncSnapshot<List<OrderModel?>> snapshot) {
                if (!snapshot.hasData) {
                  const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return snapshot.data!.isEmpty
                      ? Expanded(
                          child: Center(
                              child: Text(
                          "Henüz Sipariş Yok",
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                        )))
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                var order = snapshot.data![index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  child: Card(
                                    elevation: 5,
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            cardButton(Icons.edit, Colors.orange, true, () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return AddOrUpdateOrder(
                                                      order: order,
                                                    );
                                                  },
                                                ),
                                              );
                                            }),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "${order!.name}",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: order.price! != order.paid! ? Colors.amber : Colors.green,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Container(width: 200, height: 0.5, color: isDark ? Colors.white : Colors.black),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Adet : ${order.count}",
                                                        style: TextStyle(fontSize: 15, color: isDark ? Colors.white : Colors.black),
                                                      ),
                                                      Text(
                                                        order.type.toUpperCase(),
                                                        style: TextStyle(fontSize: 15, color: isDark ? Colors.blue : Colors.black),
                                                      ),
                                                      Text(
                                                        "Fiyat : ${order.price} ₺",
                                                        style: TextStyle(fontSize: 15, color: isDark ? Colors.white : Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                  ExpansionTile(
                                                    collapsedIconColor: order.price! != order.paid!
                                                        ? Colors.amber
                                                        : isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                    iconColor: order.price! != order.paid!
                                                        ? Colors.amber
                                                        : isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                    title: Text(
                                                      "Bakiye",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: order.price! != order.paid!
                                                              ? Colors.amber
                                                              : isDark
                                                                  ? Colors.white
                                                                  : Colors.black),
                                                    ),
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                          Text("Ödenen : ${order.paid} ₺",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: order.price! != order.paid!
                                                                      ? Colors.amber
                                                                      : isDark
                                                                          ? Colors.white
                                                                          : Colors.black)),
                                                          Text("Bakiye : ${double.parse((order.price! - order.paid!).toStringAsFixed(2))} ₺",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: order.price! != order.paid!
                                                                      ? Colors.amber
                                                                      : isDark
                                                                          ? Colors.white
                                                                          : Colors.black)),
                                                        ],
                                                      ),
                                                      ExpansionTile(
                                                        title: const Text("Detay"),
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("Gelir : ${double.parse((order.price! - order.loss!).toStringAsFixed(2))} ₺",
                                                                  style: const TextStyle(fontSize: 15, color: Colors.green)),
                                                              Text("Gider : ${double.parse((order.loss!).toStringAsFixed(2))}₺",
                                                                  style: const TextStyle(fontSize: 15, color: Colors.red)),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            cardButton(Icons.delete, Colors.red, false, () => sil(order)),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        GestureDetector(
                                          onTap: () {
                                            tamamlandi(order, order.price! == order.paid!);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                                            child: const Text(
                                              "Tamamlandı olarak işaretle",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
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

  void snackBar(String customText) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        content: Row(
          children: [
            const Icon(Icons.favorite, color: Colors.red),
            Text(customText, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void tamamlandi(OrderModel order, bool odemesiTamam) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              odemesiTamam
                  ? const Text("Tamamlandı olarak işaretle")
                  : const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Ödemesi tamamlanmadı"),
                        Text("Yine de işaretlensin mi?"),
                      ],
                    ),
              Icon(
                odemesiTamam ? Icons.done_all : Icons.warning,
                color: odemesiTamam ? Colors.blue : Colors.amber,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "İptal",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () async {
                //----------------------------------------------------------
                double fixedPrice = double.parse((order.price)!.toStringAsFixed(2));
                double fixedPaid = double.parse((order.paid)!.toStringAsFixed(2));
                double fixedLoss = double.parse((order.loss)!.toStringAsFixed(2));
                //----------------------------------------------------------
                FinishedModel finished = FinishedModel(
                  name: order.name,
                  count: order.count,
                  price: fixedPrice,
                  paid: fixedPaid,
                  loss: fixedLoss,
                  type: order.type,
                );
                FinishedDatabaseHelper.instance.insertOrder(finished);
                await OrderDatabaseHelper.instance.deleteOrder(order);
                snackBar("Allah bereket versin");
                setState(() {
                  Navigator.pop(context);
                });
                updateTotalPrice();
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

  void sil(OrderModel order) {
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
                OrderDatabaseHelper.instance.deleteOrder(order);
                updateTotalPrice();
                setState(() {
                  Navigator.pop(context);
                });
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

  GestureDetector cardButton(IconData icon, Color color, bool isRight, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: color,
          borderRadius: isRight
              ? const BorderRadius.only(bottomRight: Radius.circular(15))
              : const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                ),
        ),
        child: Icon(icon, color: Colors.white),
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
            Text(price == "0.0 ₺" ? "0 ₺" : price, style: TextStyle(fontSize: 19, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
