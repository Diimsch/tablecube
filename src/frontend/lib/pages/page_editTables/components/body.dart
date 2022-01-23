import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/api.dart';
import 'package:frontend/common_components/rounded_table_item.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/common_components/background.dart';
import 'package:frontend/pages/page_editTables/restaurant_table_edit_screen.dart';
import 'package:frontend/utils.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getTablesQuery = r"""
query Query($restaurantId: ID!) {
  restaurant(restaurantId: $restaurantId) {
    tables {
      name
      id
    }
  }
}

""";

const String createTableMutation = r"""
mutation CreateTable($data: CreateTableInput!) {
  createTable(data: $data) {
    id
    name
  }
}
""";

const String delTableMutation = r"""
mutation DeleteTable($deleteTableId: ID!) {
  deleteTable(id: $deleteTableId) {
    id
    name
  }
}
""";

const String updateTableMutation = r"""
mutation CreateTable($data: EditTableInput!) {
  editTable(data: $data) {
    id
    name
  }
}
""";

class Body extends State<RestaurantTableEditScreen> {
  Body();

  @override
  Widget build(BuildContext context) {
    var args = getOverviewArguments(context);

    return Query(
        options: QueryOptions(
          document: gql(getTablesQuery),
          variables: {
            'restaurantId': args.restaurantId,
          },
          pollInterval: const Duration(seconds: 60),
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const SpinKitRotatingCircle(color: Colors.white, size: 50.0);
          }

          // it can be either Map or List
          List tables = result.data!['restaurant']['tables'];

          debugPrint('tables: $tables');

          return Scaffold(
              appBar: getAppBar("Edit Restaurant Tables"),
              body: Background(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 5,
                      child: ListView.builder(
                        itemCount: tables.length,
                        itemBuilder: (context, index) {
                          final table = tables[index];
                          // Display the list item
                          return Dismissible(
                              key: Key(table['id']),
                              direction: DismissDirection.none,
                              onDismissed: (_) {
                                setState(() {
                                  widget.editable.remove(table["id"]);
                                });
                              },

                              // Display item's title, price...
                              child: TextFieldContainer(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: RoundedTableItem(
                                    table: table,
                                    editable: widget.editable
                                        .containsKey(table["id"]),
                                    onChanged: (value) {
                                      table['name'] = value;
                                    },
                                  )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Mutation(
                                              options: MutationOptions(
                                                document:
                                                    gql(updateTableMutation),
                                                onCompleted: (data) => {
                                                  if (refetch != null)
                                                    {refetch()}
                                                },
                                              ),
                                              builder: (RunMutation runMutation,
                                                  QueryResult? result) {
                                                return IconButton(
                                                    onPressed: () {
                                                      runMutation({
                                                        "data": {
                                                          "tableId":
                                                              table['id'],
                                                          "name": table['name']
                                                        }
                                                      });
                                                      setState(() {
                                                        if (widget.editable
                                                            .containsKey(
                                                                table["id"])) {
                                                          widget.editable
                                                              .remove(
                                                                  table["id"]);
                                                        } else {
                                                          widget.editable[
                                                                  table["id"]] =
                                                              true;
                                                        }
                                                      });
                                                    },
                                                    icon: Icon(
                                                      widget.editable
                                                              .containsKey(
                                                                  table["id"])
                                                          ? Icons.check_outlined
                                                          : Icons.edit_rounded,
                                                      color: widget.editable
                                                              .containsKey(
                                                                  table["id"])
                                                          ? Colors.green[800]
                                                          : Colors.black87,
                                                    ));
                                              }),
                                          Mutation(
                                              options: MutationOptions(
                                                document: gql(delTableMutation),
                                                onCompleted: (data) => {
                                                  showFeedback(
                                                      "Table deleted."),
                                                  if (refetch != null)
                                                    {refetch()}
                                                },
                                                onError: (error) => handleError(
                                                    error
                                                        as OperationException),
                                              ),
                                              builder: (RunMutation runMutation,
                                                  QueryResult? result) {
                                                return IconButton(
                                                    onPressed: () {
                                                      runMutation({
                                                        'deleteTableId':
                                                            table['id']
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons
                                                          .delete_outline_rounded,
                                                      color: Color.fromARGB(
                                                          255, 255, 0, 0),
                                                    ));
                                              }),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              )));
                        },
                      )),
                  if (widget.table.isNotEmpty)
                    Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.none,
                        onDismissed: (_) {},

                        // Display item's title, price...
                        child: TextFieldContainer(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RoundedTableItem(
                                table: widget.table,
                                editable: true,
                                onChanged: (value) {
                                  widget.table['name'] = value;
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Mutation(
                                        options: MutationOptions(
                                          document: gql(createTableMutation),
                                          onCompleted: (data) {
                                            showFeedback("Table created.");
                                            if (refetch != null) {
                                              refetch();
                                            }
                                            setState(() {
                                              widget.table = {};
                                            });
                                          },
                                          onError: (error) => handleError(
                                              error as OperationException),
                                        ),
                                        builder: (RunMutation runMutation,
                                            QueryResult? result) {
                                          return IconButton(
                                              onPressed: () {
                                                runMutation({
                                                  "data": {
                                                    'restaurantId':
                                                        args.restaurantId,
                                                    "name": widget.table['name']
                                                  }
                                                });
                                              },
                                              icon: Icon(Icons.check_outlined,
                                                  color: Colors.green[800]));
                                        }),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.table = {};
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          color: Color.fromARGB(255, 255, 0, 0),
                                        ))
                                  ],
                                ),
                              ],
                            )
                          ],
                        ))),
                  TextFieldContainer(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        onPressed: () {
                          setState(() {
                            widget.table = {
                              "name": "",
                            };
                          });
                        },
                      ),
                    ],
                  ))
                ],
              )));
        });
  }

  bool isValid(Map<String, dynamic> item) {
    return item["name"] != null && item["name"] != "";
  }
}
