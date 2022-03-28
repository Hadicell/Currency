import 'package:arz/Model/Currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', ''), // راست چین کردن
      ],

// شروع نام و نوع استایل فونت
      theme: ThemeData(
          fontFamily: 'dana',
          textTheme: const TextTheme(
            headline1: TextStyle(
                fontFamily: 'dana',
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w700),
            bodyText1: TextStyle(
                fontFamily: 'dana',
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.w300),
            headline2: TextStyle(
                fontFamily: 'dana',
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w300),
            headline3: TextStyle(
                fontFamily: 'dana',
                fontSize: 14,
                color: Colors.red,
                fontWeight: FontWeight.w700),
            headline4: TextStyle(
                fontFamily: 'dana',
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w700),
          )), //پایان نام و نوع استایل فونت

      debugShowCheckedModeBanner: false, // حذف نوار کناری سمت راست بالا

      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Currency> currency = [];

  Future getResponse(BuildContext cntx) async {
    var url = "http://sasansafari.com/flutter/api.php?access_key=flutter123456";
    var value = await http.get(Uri.parse(url));

    if (currency.isEmpty) {
      if (value.statusCode == 200) {
        _showsnackBar(context, "بروزرسانی اطلاعات با موفقیت انجام شد.");
        List jsonList = convert.jsonDecode(value.body);

        if (jsonList.length > 0) {
          for (int i = 0; i < jsonList.length; i++) {
            setState(() {
              currency.add(Currency(
                  id: jsonList[i]["id"],
                  titel: jsonList[i]["title"],
                  price: jsonList[i]["price"],
                  changes: jsonList[i]["changes"],
                  status: jsonList[i]["status"]));
            });
          }
        }
      }
    }
    return value;
  }

  @override
  void initState() {
    super.initState();
    getResponse(context);
  }

  @override
  Widget build(BuildContext context) {
    getResponse(context);

    return Scaffold(
        backgroundColor:
            const Color.fromARGB(255, 243, 243, 243), //رنگ بگراند وسط صفحه

        appBar: AppBar(
          elevation: 0,

          backgroundColor: Colors.white, // بگراند قسمت  منوی آیکون ها
          actions: [
            Image.asset("assets/images/icon.png"),
            Align(
                alignment: Alignment.centerRight,
                child: Text("قیمت به روز ارز",
                    style: Theme.of(context)
                        .textTheme
                        .headline1) //<-- آدرس مکانی که فونت و ساز ها را مشخص کرده بودیم
                ),
            Expanded(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset("assets/images/menu.png"))),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/images/q.png"),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "نرخ ارز آزاد چیست؟",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                " نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.,",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              // درست کردن  کادر لسیت ویو
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: 35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(1000)),
                    color: Color.fromARGB(255, 130, 130, 130),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "نام آزاد ارز",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Text(
                        "قیمت",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Text(
                        "تغییر",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ],
                  ),
                ),
              ),
              // List
              SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                  child: ListFutureBuilder(context)),

              //update button box
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 16,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 232, 232, 232),
                      borderRadius: BorderRadius.circular(1000)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //update btn
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 16,
                          child: TextButton.icon(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 202, 193, 255)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(1000)))),
                            onPressed: () {
                              currency.clear();
                              ListFutureBuilder(context);
                            },
                            icon: const Icon(CupertinoIcons.refresh_bold,
                                color: Colors.black),
                            label: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: Text(
                                "بروزرسانی",
                                style: Theme.of(context).textTheme.headline1,
                              ),
                            ),
                          )),
                      Text("آخرین بروز رسانی ${_getTime()}"),
                      const SizedBox(
                        width: 8,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  FutureBuilder<dynamic> ListFutureBuilder(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: currency.length,
                itemBuilder: (BuildContext context, int postion) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: MyItem_ARZE(postion, currency),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  if (index % 5 == 0) {
                    return const Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Add(),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
      future: getResponse(context),
    );
  }

  String _getTime() {
    DateTime now = DateTime.now();
    return DateFormat('kk:mm:ss').format(now);
  }
}

class MyItem_ARZE extends StatelessWidget {
  int postion;
  List<Currency> currency;

  MyItem_ARZE(this.postion, this.currency);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(boxShadow: const <BoxShadow>[
        BoxShadow(blurRadius: 1.0, color: Colors.green)
      ], color: Colors.white, borderRadius: BorderRadius.circular(1000)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Text(
              currency[postion].titel!.toString(),
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Text(
              getFarsiNumber(currency[postion].price!.toString()),
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ),
          Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Text(
                getFarsiNumber(currency[postion].changes!.toString()),
                style: currency[postion].status == "n"
                    ? Theme.of(context).textTheme.headline3
                    : Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ))
        ],
      ),
    );
  }
}

class Add extends StatelessWidget {
  const Add({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(boxShadow: const <BoxShadow>[
        BoxShadow(blurRadius: 1.0, color: Colors.green)
      ], color: Colors.red, borderRadius: BorderRadius.circular(1000)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("تبلیغات", style: Theme.of(context).textTheme.bodyText1),
        ],
      ),
    );
  }
}

// ایجاد اسنک بار برای نمایش پیامی به کاربر در هنگام بروز رسانی
void _showsnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: Theme.of(context).textTheme.headline1,
    ),
    backgroundColor: Colors.green,
  ));
}

//ساخت ساعت بروزرسانی
String getFarsiNumber(String number) {
  const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  en.forEach((element) {
    number = number.replaceAll(element, fa[en.indexOf(element)]);
  });
  return number;
}
