import 'package:flutter/material.dart';
import 'db_helper.dart';

class ShowT extends StatefulWidget {
  const ShowT({Key? key}) : super(key: key);

  @override
  _ShowTState createState() => _ShowTState();
}

class _ShowTState extends State<ShowT> {
  final db = Dbh.inst;
  @override
  void initState() {
    //db.initData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async{
          db.getData("");
          setState(() {
            
          });
        },
        child: FutureBuilder(
            future: db.getData(""),
            builder: (context, AsyncSnapshot<List> sna) {
              if (sna.connectionState == ConnectionState.done) {
                return ListView(
                  children: sna.data!.map((e) {
                    return InkWell(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Update(
                                obj: e,
                                update: db.updateData,
                              );
                            });
                      },
                      child: Dismissible(
                        onDismissed: (_) {
                          db.deleteData(e["id"]);
                        },
                        key: ValueKey(e["id"]),
                        background: Container(
                          color: Colors.red,
                          child: const Icon(Icons.delete),
                        ),
                        child: Card(
                          elevation: 2,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(e["name"]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}

class Update extends StatefulWidget {
  final Map obj;
  final Function update;
  const Update({Key? key, required this.obj, required this.update})
      : super(key: key);

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  // final Map obj;
  // Function update;
  // _UpdateState(this.obj, this.update);
  TextEditingController? txt;
  @override
  void initState() {
    print(widget.obj["name"]);
    txt = TextEditingController(text: widget.obj["name"]);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        content: Column(
          children: [
            TextField(
                controller: txt,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), focusColor: Colors.green))
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: () async {
              await widget.update(txt!.text, widget.obj["id"]);
              print("${widget.obj["name"]} updated");
              Navigator.pop(context);
            },
            child: Text("update"),
          ),
          MaterialButton(
            onPressed: () {},
            child: Text("add"),
          )
        ],
      ),
    );
  }
}
