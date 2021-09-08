import 'package:blood_app/base_main.dart';
import 'package:blood_app/ui/home/archive_request_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ArchiveRequest extends Base {
  @override
  _ArchiveRequestState createState() => _ArchiveRequestState();
}

class _ArchiveRequestState extends State<ArchiveRequest> {
  double width, height;
  ArchiveRequestViewModel model;


  @override
  Widget build(BuildContext context) {
    model = Provider.of<ArchiveRequestViewModel>(context, listen: false);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    model.fetchNotification();

    return Scaffold(
      appBar: AppBar(
        title: Text("Archive requests"),
      ),
      body: Container(
        width: width,
        height: height,
        child: Consumer<ArchiveRequestViewModel>(builder: (_, model, child) {
          return ListView.builder(
              itemCount: model.list.length,
              itemBuilder: (_, i) {
                return model.list[i].user == null ?
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [CircularProgressIndicator()],
                  ),
                ):
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: Container(
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 30.0,
                                child: ClipOval(
                                  child: Text(
                                    model.list[i].user.bloodGroup,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                            title: Text(model.list[i].user.firstName),
                            subtitle: Text(model.retreiveTime(model
                                .list[i].chatNotification.createdTimestamp
                            )),
                            trailing: returnChip(i),
                          ),
                        ),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {

                              model.deleteNotification(model.list[i], context, widget);
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 0.2,)
                  ],
                );
              });
        }),
      ),
    );
  }
  returnChip(int i) {
    if(model.retrieveTimeInInt(model.list[i].chatNotification.createdTimestamp) > 0){
      return Chip(
        backgroundColor: Colors.redAccent,
        label: Text("Expired"),
      );
    }
  }
}
