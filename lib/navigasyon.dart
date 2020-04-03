import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ilanliste.dart';

class NavigasyonIslemleri extends StatefulWidget {
  @override
  _NavigasyonIslemleriState createState() => _NavigasyonIslemleriState();
}

class _NavigasyonIslemleriState extends State<NavigasyonIslemleri> {
  String input = 'input String';
  String secilenSite, keyword, magaza;
  String _magaza = '';

  final _formKey = GlobalKey<FormState>();

  Future<void> varsayilanMagazaKaydet() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('varsayilanmagaza', magaza);
  }

  Future<void> varsayilanMagazaGetir() async {
    String varsayilanmagaza = '';
    final prefs = await SharedPreferences.getInstance();
    varsayilanmagaza = prefs.getString('varsayilanmagaza');
    if (varsayilanmagaza == null) {
      _magaza = '';
    } else {
      _magaza = varsayilanmagaza;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          girisVerileriniOnayla();
        },
        child: Icon(Icons.search),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 210,
            floating: false,
            pinned: true,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(10.0),
              child: FlexibleSpaceBar(
                background: Image.asset(
                  'assets/images/banner.png',
                  fit: BoxFit.cover,
                ),
                title: Text(
                  'Analizci',
                  style: TextStyle(fontFamily: 'Audiowide', fontSize: 24),
                ),
                centerTitle: false,
              ),
            ),
          ),
          SliverFillRemaining(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 30.0),
                    child: DropdownButton<String>(
                      items: [
                        DropdownMenuItem<String>(
                          child: Container(
                            margin: EdgeInsets.all(9),
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/logo-n11.png',
                                  fit: BoxFit.cover,
                                ),
                                Text('   n11.com')
                              ],
                            ),
                          ),
                          value: 'n11',
                        ),
                        DropdownMenuItem<String>(
                          child: Container(
                            margin: EdgeInsets.all(9),
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/gittigidiyor-logo.png',
                                  fit: BoxFit.cover,
                                ),
                                Text('   (çok yakında..)')
                              ],
                            ),
                          ),
                          value: 'gittigidiyor',
                        ),
                      ],
                      onChanged: (String secilen) {
                        setState(() {
                          secilenSite = secilen;
                        });
                      },
                      hint: Text('pazaryeri seçin'),
                      disabledHint: Text('pazaryeri seçin'),
                      value: secilenSite,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 30.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      //autofocus: true,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                        labelStyle: TextStyle(fontSize: 20),
                        labelText: 'İlan arama metni girin',
                        hintText: 'örn: lansman kılıf',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: Icon(Icons.edit),
                        filled: true,
                        fillColor: Colors.black26,
                      ),
                      onSaved: (value) => keyword = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 30.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: TextEditingController()..text = _magaza,
                      //autofocus: true,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                        labelStyle: TextStyle(fontSize: 20),
                        hintText: 'örn: SAĞLAMFIRSAT',
                        labelText: 'Mağaza adını girin',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: Icon(Icons.edit),
                        filled: true,
                        fillColor: Colors.black26,
                      ),
                      onSaved: (value) => magaza = value,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void girisVerileriniOnayla() async {
    await varsayilanMagazaKaydet();

    //debugPrint(secilenSite+'\n'+keyword+'\n'+magaza); //hata veriyor gesture
_formKey.currentState.save();
    // if (keyword != '' && magaza != '') {
    //   debugPrint('Arama metni ya da mağaza adını boş bırakmayın!');
    // } else {
      
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InputView(secilenSite, keyword, magaza)));
    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class InputView extends StatefulWidget {
  String secilenSite, keyword, magaza;
  InputView(this.secilenSite, this.keyword, this.magaza);
  @override
  _InputViewState createState() => _InputViewState();
}

class _InputViewState extends State<InputView> {
  TextEditingController textController1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //color: Colors.grey.shade400,
        margin: EdgeInsets.all(10),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: IlanListe(widget.secilenSite, widget.keyword, widget.magaza),
      ),
    );
  }
}
