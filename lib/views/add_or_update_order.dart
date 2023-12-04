// ignore_for_file: use_build_context_synchronously, must_be_immutable, avoid_print, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:order/models/order_model.dart';
import 'package:order/services/order_database_helper.dart';
import 'package:order/settings/theme.dart';
import 'package:order/views/home_page.dart';
import 'package:provider/provider.dart';

class AddOrUpdateOrder extends StatefulWidget {
  OrderModel? order;
  AddOrUpdateOrder({
    super.key,
    this.order,
  });

  @override
  State<AddOrUpdateOrder> createState() => _AddOrUpdateOrderState();
}

class _AddOrUpdateOrderState extends State<AddOrUpdateOrder> {
  //-------------------------------------------------------------------------------------------
  TextEditingController nameController = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController paidController = TextEditingController();
  TextEditingController lossController = TextEditingController();
  //-------------------------------------------------------------------------------------------
  String name = "";
  int count = 1;
  double price = 0;
  double paid = 0;
  double loss = 0;
  bool terlikMi = true;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.order != null ? widget.order!.name.toString() : "";
    countController.text = widget.order != null ? widget.order!.count.toString() : "";
    priceController.text = widget.order != null ? widget.order!.price.toString() : "";
    paidController.text = widget.order != null ? widget.order!.paid.toString() : "";
    lossController.text = widget.order != null ? widget.order!.loss.toString() : "";
    if (widget.order == null) {
      terlikMi = true;
    } else {
      terlikMi = widget.order!.type == ProductType.terlik.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<ThemeProvider>(context).isDark;
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Form(
                key: formKey,
                child: Column(children: [
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      color: Colors.transparent,
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black),
                        ),
                        Text(widget.order == null ? "Yeni Sipariş" : "Güncelle",
                            style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                              });
                            },
                            icon: Icon(Icons.brightness_6, color: isDark ? Colors.white : Colors.black))
                      ])),
                  const SizedBox(height: 10),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: textFormField(
                        name: "Müşteri Adı",
                        keyboardType: TextInputType.text,
                        onSaved: (newValue) => setState(() => name = newValue!),
                        controller: nameController,
                        isDark: isDark,
                        key: formKey,
                      )),
                  const SizedBox(height: 20),
                  Row(children: [
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: textFormField(
                              name: "Adet",
                              keyboardType: TextInputType.number,
                              onSaved: (newValue) => setState(() => count = int.parse(newValue!).round()),
                              controller: countController,
                              isDark: isDark,
                              key: formKey,
                            ))),
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: textFormField(
                              name: "Fiyat",
                              keyboardType: TextInputType.number,
                              onSaved: (newValue) => setState(() => price = double.parse(newValue!)),
                              controller: priceController,
                              isDark: isDark,
                              key: formKey,
                            )))
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: textFormField(
                              name: "Ödenen",
                              keyboardType: TextInputType.number,
                              onSaved: (newValue) => setState(() => paid = double.parse(newValue!)),
                              controller: paidController,
                              isDark: isDark,
                              key: formKey,
                            ))),
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: textFormField(
                              name: "Gider",
                              keyboardType: TextInputType.number,
                              onSaved: (newValue) => setState(() => loss = double.parse(newValue!)),
                              controller: lossController,
                              isDark: isDark,
                              key: formKey,
                            )))
                  ]),
                  widget.order == null
                      ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Expanded(
                              flex: 2,
                              child: GestureDetector(
                                  onTap: () => setState(() => terlikMi = true),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: terlikMi
                                            ? isDark
                                                ? Colors.green
                                                : Colors.black
                                            : isDark
                                                ? Colors.white.withOpacity(0.1)
                                                : Colors.black.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 2,
                                          color: terlikMi
                                              ? Colors.white
                                              : isDark
                                                  ? Colors.black
                                                  : Colors.white,
                                        ),
                                      ),
                                      child: Text("Terlik",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: terlikMi
                                                  ? isDark
                                                      ? Colors.black
                                                      : Colors.white
                                                  : isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold))))),
                          Expanded(
                              flex: 2,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      terlikMi = false;
                                    });
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: terlikMi
                                            ? isDark
                                                ? Colors.white.withOpacity(0.1)
                                                : Colors.black.withOpacity(0.2)
                                            : isDark
                                                ? Colors.green
                                                : Colors.black,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 2,
                                          color: terlikMi
                                              ? isDark
                                                  ? Colors.black
                                                  : Colors.white
                                              : Colors.white,
                                        ),
                                      ),
                                      child: Text("Panduf",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: terlikMi
                                                  ? isDark
                                                      ? Colors.white
                                                      : Colors.black
                                                  : isDark
                                                      ? Colors.black
                                                      : Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold))))),
                          Expanded(
                              flex: 4,
                              child: GestureDetector(
                                  onTap: () {
                                    String priceString = priceController.text.replaceAll(",", ".");
                                    int priceDotCount = priceString.replaceAll(RegExp(r'[^.]'), '').length;
                                    int pricecCommaCount = priceString.replaceAll(RegExp(r'[^,]'), '').length;
                                    String? newPrice;
                                    //------------------------------------------
                                    String paidString = paidController.text.replaceAll(",", ".");
                                    int paidDotCount = paidString.replaceAll(RegExp(r'[^.]'), '').length;
                                    int paidCommaCount = paidString.replaceAll(RegExp(r'[^,]'), '').length;
                                    String? newPaid;
                                    //------------------------------------------
                                    String lossString = lossController.text.replaceAll(",", ".");
                                    int lossDotCount = lossString.replaceAll(RegExp(r'[^.]'), '').length;
                                    int lossCommaCount = lossString.replaceAll(RegExp(r'[^,]'), '').length;
                                    String? newLoss;

                                    if (priceDotCount > 1 || pricecCommaCount > 1) {
                                      snackBar(context, "Geçersiz fiyat girildi");
                                    } else if (paidDotCount > 1 || paidCommaCount > 1) {
                                      snackBar(context, "Geçersiz ödeme girildi");
                                    } else if (lossDotCount > 1 || lossCommaCount > 1) {
                                      snackBar(context, "Geçersiz gider girildi");
                                    } else {
                                      if (formKey.currentState!.validate()) {
                                        price = newPrice == null ? double.parse(priceController.text) : double.parse(newPrice.replaceAll(",", "."));
                                        paid = newPaid == null ? double.parse(paidController.text) : double.parse(newPaid.replaceAll(",", "."));
                                        loss = newLoss == null ? double.parse(lossController.text) : double.parse(newLoss.replaceAll(",", "."));
                                        setState(() {
                                          if (price < loss) {
                                            snackBar(context, "Gider fiyattan yüksek olamaz");
                                          } else if (price < paid) {
                                            snackBar(context, "Ödenen fiyattan yüksek olamaz");
                                          } else {
                                            //-----------------------------------------Count
                                            String newCount = countController.text;
                                            final regexp = RegExp(r'^[0-9a-fA-F]+');
                                            final match = regexp.firstMatch(newCount);
                                            final matchedText = match?.group(0);
                                            //----------------------------------------------------------
                                            double fixedPrice = double.parse((price).toStringAsFixed(2));
                                            double fixedPaid = double.parse((paid).toStringAsFixed(2));
                                            double fixedLoss = double.parse((loss).toStringAsFixed(2));
                                            //----------------------------------------------------------

                                            OrderDatabaseHelper.instance.insertOrder(OrderModel(
                                              name: nameController.text.toUpperCase().trim(),
                                              count: int.parse(matchedText!.replaceAll(",", ".")).floor(),
                                              price: fixedPrice,
                                              paid: fixedPaid,
                                              loss: fixedLoss,
                                              type: terlikMi ? ProductType.terlik.name : ProductType.panduf.name,
                                            ));
                                            nameController.clear();
                                            nameController.clear();
                                            priceController.clear();
                                            paidController.clear();
                                            lossController.clear();
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                                          }
                                        });
                                      }
                                    }
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isDark ? Colors.white : Colors.black,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text("Yeni Sipariş Ekle",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: isDark ? Colors.black : Colors.white, fontSize: 15, fontWeight: FontWeight.bold)))))
                        ])
                      : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Expanded(
                              flex: 2,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      terlikMi = true;
                                    });
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: terlikMi
                                              ? isDark
                                                  ? Colors.green
                                                  : Colors.black
                                              : isDark
                                                  ? Colors.white.withOpacity(0.1)
                                                  : Colors.black.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 2,
                                              color: terlikMi
                                                  ? Colors.white
                                                  : isDark
                                                      ? Colors.black
                                                      : Colors.white)),
                                      child: Text("Terlik",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: terlikMi
                                                  ? isDark
                                                      ? Colors.black
                                                      : Colors.white
                                                  : isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold))))),
                          Expanded(
                              flex: 2,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      terlikMi = false;
                                    });
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: terlikMi
                                              ? isDark
                                                  ? Colors.white.withOpacity(0.1)
                                                  : Colors.black.withOpacity(0.2)
                                              : isDark
                                                  ? Colors.green
                                                  : Colors.black,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 2,
                                              color: terlikMi
                                                  ? isDark
                                                      ? Colors.black
                                                      : Colors.white
                                                  : Colors.white)),
                                      child: Text("Panduf",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: terlikMi
                                                  ? isDark
                                                      ? Colors.white
                                                      : Colors.black
                                                  : isDark
                                                      ? Colors.black
                                                      : Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold))))),
                          Expanded(
                              flex: 4,
                              child: GestureDetector(
                                  onTap: () {
                                    String priceString = priceController.text.replaceAll(",", ".");
                                    int priceDotCount = priceString.replaceAll(RegExp(r'[^.]'), '').length;
                                    int pricecCommaCount = priceString.replaceAll(RegExp(r'[^,]'), '').length;
                                    String? newPrice;
                                    //------------------------------------------
                                    String paidString = paidController.text.replaceAll(",", ".");
                                    int paidDotCount = paidString.replaceAll(RegExp(r'[^.]'), '').length;
                                    int paidCommaCount = paidString.replaceAll(RegExp(r'[^,]'), '').length;
                                    String? newPaid;
                                    //------------------------------------------
                                    String lossString = lossController.text.replaceAll(",", ".");
                                    int lossDotCount = lossString.replaceAll(RegExp(r'[^.]'), '').length;
                                    int lossCommaCount = lossString.replaceAll(RegExp(r'[^,]'), '').length;
                                    String? newLoss;

                                    if (priceDotCount > 1 || pricecCommaCount > 1) {
                                      snackBar(context, "Geçersiz fiyat girildi");
                                    } else if (paidDotCount > 1 || paidCommaCount > 1) {
                                      snackBar(context, "Geçersiz ödeme girildi");
                                    } else if (lossDotCount > 1 || lossCommaCount > 1) {
                                      snackBar(context, "Geçersiz gider girildi");
                                    } else {
                                      if (formKey.currentState!.validate()) {
                                        price = newPrice == null ? double.parse(priceController.text) : double.parse(newPrice.replaceAll(",", "."));
                                        paid = newPaid == null ? double.parse(paidController.text) : double.parse(newPaid.replaceAll(",", "."));
                                        loss = newLoss == null ? double.parse(lossController.text) : double.parse(newLoss.replaceAll(",", "."));
                                        setState(() {
                                          if (price < loss) {
                                            snackBar(context, "Gider fiyattan yüksek olamaz");
                                          } else if (price < paid) {
                                            snackBar(context, "Ödenen fiyattan yüksek olamaz");
                                          } else {
                                            //-----------------------------------------Count
                                            String newCount = countController.text;
                                            final regexp = RegExp(r'^[0-9a-fA-F]+');
                                            final match = regexp.firstMatch(newCount);
                                            final matchedText = match?.group(0);
                                            //----------------------------------------------------------
                                            double fixedPrice = double.parse((price).toStringAsFixed(2));
                                            double fixedPaid = double.parse((paid).toStringAsFixed(2));
                                            double fixedLoss = double.parse((loss).toStringAsFixed(2));
                                            //----------------------------------------------------------
                                            OrderDatabaseHelper.instance.updateOrder(OrderModel(
                                              id: widget.order!.id,
                                              name: nameController.text.toUpperCase().trim(),
                                              count: int.parse(matchedText!.replaceAll(",", ".")).floor(),
                                              price: fixedPrice,
                                              paid: fixedPaid,
                                              loss: fixedLoss,
                                              completed: widget.order!.completed,
                                              type: terlikMi ? ProductType.terlik.name : ProductType.panduf.name, // ------------------> DEĞİŞECEK
                                            ));
                                            nameController.clear();
                                            nameController.clear();
                                            priceController.clear();
                                            paidController.clear();
                                            lossController.clear();
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                                          }
                                        });
                                      }
                                    }
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(color: isDark ? Colors.white : Colors.black, borderRadius: BorderRadius.circular(15)),
                                      child: Text("Siparişi Güncelle",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: isDark ? Colors.black : Colors.white, fontSize: 18, fontWeight: FontWeight.bold)))))
                        ])
                ]))));
  }

  void snackBar(BuildContext context, String message) {
    FocusScope.of(context).requestFocus(FocusNode());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        backgroundColor: Colors.red,
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.amber),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        )));
  }

  Widget textFormField(
      {required String name,
      required TextInputType keyboardType,
      required Function(String?)? onSaved,
      required TextEditingController controller,
      required bool isDark,
      required GlobalKey<FormState> key}) {
    return TextFormField(
      maxLength: keyboardType == TextInputType.text ? 18 : null,
      keyboardType: keyboardType,
      controller: controller,
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$name boş bırakılamaz';
        }
        return null;
      },
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        label: Text(name.toString()),
        labelStyle: TextStyle(color: isDark ? Colors.white : Colors.black),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
