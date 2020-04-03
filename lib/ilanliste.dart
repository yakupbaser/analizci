import 'dart:core';
import 'dart:core' as uri;

import 'package:analizci/adPanel.dart';
import 'package:analizci/ads.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class IlanListe extends StatefulWidget {
  String secilenSite, keyword, magaza;
  IlanListe(this.secilenSite, this.keyword, this.magaza) {
    // if (keyword == '') {
    //   keyword = 'lansman kılıf';
    // }
    // if (magaza == '') {
    //   magaza = 'SAĞLAMFIRSAT';
    // }
    if (secilenSite == 'n11' || secilenSite == '' || secilenSite == null) {
      secilenSite = Uri.parse('https://www.n11.com/arama?q=' + keyword + '&pg=')
          .toString();
    }

    debugPrint('$secilenSite $keyword $magaza');
  }
  @override
  _IlanListeState createState() => _IlanListeState();
}

class _IlanListeState extends State<IlanListe> {
  String _htmlVeri = '';
  int _ilanSira = 0;
  String _urunLinki = '';
  String _urunAdi = '';
  String _magazaLinki = '';
  String _magazaAdi = '';
  int _urunSayfaNo = 0;
  int _ilanSayisi = 0;
  String _ilanAramaLinki ='';
  int toplamSayfa = 0;
  int toplamIlan = 0;

  @override
  void initState() {
    debugPrint(5.toString());
     Ads.initInterStitialAd(); 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  Ads.showInterstitialAd();
    return FutureBuilder(
        future: tumIlanlariGetir(),
        builder: (contex, AsyncSnapshot<List<IlanModel>> gelenIlanModel) {
          if (gelenIlanModel.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (gelenIlanModel.connectionState == ConnectionState.done) {
            return 
                ListView.separated(
                  separatorBuilder: (contex, index) {
                    //sadece ilk satıra reklam ekle
                    if (index < 1) {
                      return Container(
                        height: 0.0,
                        child: AdPanel(),
                      );
                    } else {
                      return Container(); //reklam yok
                    }
                  },
                  itemCount: gelenIlanModel?.data?.length ?? 1,
                  itemBuilder: (contex, index) => InkWell(
                        child: 
                            cardOlustur(index, gelenIlanModel),
                          
                        
                        onTap: () {
                          _launchURL(gelenIlanModel?.data[index]?._ilanAramaLinki ??
                              'www.n11.com');
                        },
                      ),
               
               
            );
          }
        });
  }

  Card cardOlustur(int index, AsyncSnapshot<List<IlanModel>> gelenIlanModel) {
    if (gelenIlanModel.data == null) {
      return Card(
        elevation: 4,
        child: ListTile(
          leading: Icon(Icons.error)
          
        ,
          title: Text('Aradığınız metne ait ilan bulunamadı!' +
              '\n' +
              'Mağaza adınızı doğru yazdığınızdan emin olun.' +
              '\n' +
              'Büyük / küçük harf kullanımına dikkat edin.' +
              '\n' +
              '\n' +
              'Örn:' +
              '\n' +
              'SAĞLAMFIRSAT [DOĞRU]' +
              '\n' +
              'sağlamfırsat [YANLIŞ]' +
              '\n' +
              'SağlamFırsat [YANLIŞ]' +
              '\n' +
              'SAĞLAM FIRSAT [YANLIŞ]' +
              '\n'),
        ),
      );
    }

    _ilanSayisi =
        gelenIlanModel.data[gelenIlanModel.data.length - 1 ?? 0]._ilanSayisi ??
            0;

    if (_ilanSayisi == 1) {
      _ilanSayisi = 0;
    }

//debugPrint(_ilanSayisi.toString());

    return index == 0
        ? Card(
            elevation: 10,
            child: ListTile(
               leading: CircleAvatar(
            backgroundImage: widget.secilenSite.contains('n11') == true ? AssetImage(
                                              'assets/images/logo-n11.png',
                                              
                                            ): AssetImage(
                                              'assets/images/gittigidiyor-logo.png',
                                              
                                            ),
                                            ),
                                            
          
              title: Text(
                    'Arama metni  = ' +
                    widget.keyword +
                    '\n' +
                    'Tüm ilanlar = ' +
                    toplamIlan.toString() +
                    '\n' +
                    'Toplam sayfa = ' +
                    toplamSayfa.toString() +
                    '\n' +
                    'Mağaza adı = ' +
                    widget.magaza +
                    '\n' +
                    'Mağazaya ait ilan sayısı = ' +
                    _ilanSayisi.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        : Card(
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.data_usage),
              trailing: Icon(Icons.open_in_browser),
              title: Text('İlan sırası = ' +
                  gelenIlanModel.data[index]._ilanSirasi.toString() +
                  '\n' +
                  'Sayfa no = ' +
                  gelenIlanModel.data[index]._urunSayfaNo.toString()),
              subtitle:
                  Text('İlan linki = ' + gelenIlanModel.data[index]._urunLinki),
            ),
          );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      debugPrint('ilan açılamadı');
    }
  }

  Future<List<IlanModel>> tumIlanlariGetir() async {
    var onValue = await _sayfaSayisi();
    int ilanSayisi = 0;
    List<IlanModel> tumIlanlar = [];
    tumIlanlar.add(IlanModel(1, 1, '', 1, '', 1, '',
        1,'')); // buraya başlık bilgileri geleceği için ilk satır boş
    toplamSayfa = onValue[0] > 20 ? 20 : onValue[0];

    toplamIlan = onValue[1];

    for (int i = 1; i <= toplamSayfa; i++) {
      var response = await http.get(widget.secilenSite + i.toString());
      _urunSayfaNo = 0;

      _htmlVeri = response.body
          .replaceAll("\n", "")
          .replaceAll("\t", "")
          .replaceAll("  ", "");

      RegExp desen_ilanlar = RegExp(
          r'class="(.*?)"\s*?data-position="([0-9]+?)"\s*?data-searchcount="([0-9]+?)"\s*?data-ctgid="([0-9]+?)"><div class="(.*?)"><a href="(.*?)" title([^]*?)<a class="sallerInfo" href="(.*?)" title="(.*?)">');
      Iterable<Match> match_ilanlar = desen_ilanlar.allMatches(_htmlVeri);

      for (Match eslesen_ilan in match_ilanlar) {
        _magazaAdi = '';
        _magazaAdi = eslesen_ilan.group(9).trimRight();

        if (_magazaAdi == widget.magaza) {
          _ilanSira = int.parse(eslesen_ilan.group(2));
          _urunLinki = eslesen_ilan.group(6);
          _urunAdi = eslesen_ilan.group(7);
          _magazaLinki = eslesen_ilan.group(8);
          _urunSayfaNo = i;
          ilanSayisi++;
          _ilanAramaLinki = widget.secilenSite + i.toString();
          tumIlanlar.add(IlanModel(toplamSayfa, toplamIlan, _magazaAdi,
              _ilanSira, _urunLinki, _urunSayfaNo, _magazaLinki, ilanSayisi, _ilanAramaLinki));
        }
      }
    } //for
    return tumIlanlar;
  }

  Future<List<int>> _sayfaSayisi() {
    String _htmlVeri = '';
    int _searchcount = 0;
    int _sayfaSayi = 0;
    List<int> sonucList = List();
    //debugPrint('1');

    Future<List<int>> sayfaVeDataSayi =
        http.get(widget.secilenSite + "1").then((gelenVeri) {
      _htmlVeri = gelenVeri.body
          .replaceAll("\n", "")
          .replaceAll("\t", "")
          .replaceAll("  ", "");
      //debugPrint(gelenVeri.body);

      RegExp desen_sayfa_sayisi =
          RegExp('id="pageCount" name="pageCount" value="([0-9]+?)"');
      Match match_sayfa_sayisi = desen_sayfa_sayisi.firstMatch(_htmlVeri);

      RegExp desen_searchcount = RegExp('data-searchcount="([0-9]+?)"');
      Match match_searchcount = desen_searchcount.firstMatch(_htmlVeri);
      _searchcount = int.parse(match_searchcount.group(1));
      _sayfaSayi = int.parse(match_sayfa_sayisi.group(1));
      sonucList.add(_sayfaSayi);
      sonucList.add(_searchcount);
      return sonucList;
    });

    return sayfaVeDataSayi;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class IlanModel {
  int _toplamSayfaSayisi;
  int _toplamIlanSayisi;
  String _magazaAdi;
  int _ilanSirasi;
  String _urunLinki;
  int _urunSayfaNo;
  String _magazaLinki;
  int _ilanSayisi;
  String _ilanAramaLinki;

  IlanModel(
      this._toplamSayfaSayisi,
      this._toplamIlanSayisi,
      this._magazaAdi,
      this._ilanSirasi,
      this._urunLinki,
      this._urunSayfaNo,
      this._magazaLinki,
      this._ilanSayisi,
      this._ilanAramaLinki);
}
