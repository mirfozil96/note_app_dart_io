import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'client_service.dart';
import 'model.dart';

class MockApiNote extends StatefulWidget {
  const MockApiNote({super.key});
  @override
  State<MockApiNote> createState() => _MockApiNoteState();
}

class _MockApiNoteState extends State<MockApiNote> {
  List<Note> notes = [];
  bool isLoading = false;
  bool isError = false;
  String api = '/asd';
  TextEditingController textEditingController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  Future<void> refresh(String? result,
      [String msg = "Successfully done"]) async {
    if (result != null) {
      Utils.fireSnackBar(msg, context);
    }
    await read();
    setState(() {});
  }

  Future<void> read() async {
    setState(() {
      isLoading = true;
    });
    String? result = await ClientService.get(api: api);
    if (result != null) {
      notes = listNotesFromJson(result);
    }
    setState(() {});
  }

  Future<void> create() async {
    String title = titleController.text.trim().toString();
    String body = bodyController.text.trim().toString();
    Note newNote = Note(
        title: title,
        body: body,
        createTime: DateTime.now().toString().substring(0, 22),
        editTime: 'not edit');
    String? result = await ClientService.post(api: api, data: newNote.toJson());
    await refresh(result, "Successfully created");
  }

  Future<void> update(Note note) async {
    note.editTime = DateTime.now().toString().substring(0, 19);
    String? result = await ClientService.put(
      api: '$api/${note.id}',
      data: note.toJson(),
    );
    await refresh(result, "Successfully updated");
  }

  Future<void> delete(Note note) async {
    String? result = await ClientService.delete(
      api: '$api/${note.id}',
    );

    await refresh(result, "Deleted");
  }

  void clear() {
    titleController.clear();
    bodyController.clear();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
      ),
      body: isError
          ? Column(
              children: [
                const SizedBox(height: 100),
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Lottie.asset("assets/lotties/error.json"),
                ),
                const Spacer(),
                MaterialButton(
                  color: Colors.red,
                  shape: const StadiumBorder(),
                  minWidth: 250,
                  height: 55,
                  onPressed: () async {
                    setState(() {
                      isError = false;
                    });
                    await read();
                  },
                  child: const Text("Retry"),
                ),
                const SizedBox(height: 100),
              ],
            )
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextField(
                    onChanged: (text) async {
                      setState(() {});
                    },
                    controller: textEditingController,
                    decoration: InputDecoration(
                      labelText: "Search",
                      prefixIcon: SizedBox(
                          width: 80,
                          height: 80,
                          child: Lottie.asset("assets/lotties/search.json")),
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (_, index) {
                            Note product = notes[index];
                            bool shouldShow = product.title!
                                .toLowerCase()
                                .contains(
                                    textEditingController.text.toLowerCase());
                            return shouldShow
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: Slidable(
                                      endActionPane: ActionPane(
                                        extentRatio: 0.7,
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (_) {
                                              _editProduct(_, product);
                                            },
                                            autoClose: true,
                                            backgroundColor:
                                                const Color(0xFF21B7CA),
                                            foregroundColor: Colors.white,
                                            icon: Icons.edit,
                                            label: 'Edit',
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          SlidableAction(
                                            onPressed: (_) {
                                              delete(product);
                                            },
                                            backgroundColor:
                                                const Color(0xFFFE4A49),
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            autoClose: true,
                                            label: 'Delete',
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ],
                                      ),
                                      child: Card(
                                        margin: EdgeInsets.zero,
                                        color: Colors.blueGrey.withOpacity(0.3),
                                        elevation: 0,
                                        child: ListTile(
                                          title: Text.rich(
                                            TextSpan(
                                              text: 'Title:',
                                              style: const TextStyle(
                                                  color: Colors
                                                      .green), // Boshqa rang
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: '${product.title}',
                                                  style: const TextStyle(
                                                      color: Colors
                                                          .black), // Boshqa rang
                                                ),
                                              ],
                                            ),
                                          ),
                                          subtitle: Text.rich(
                                            TextSpan(
                                              text: 'Body:',
                                              style: const TextStyle(
                                                  color: Colors
                                                      .red), // Boshqa rang
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: '${product.body}',
                                                  style: const TextStyle(
                                                      color: Colors
                                                          .black), // Boshqa rang
                                                ),
                                              ],
                                            ),
                                          ),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  text: 'Create time:',
                                                  style: const TextStyle(
                                                      color: Colors
                                                          .blue), // Boshqa rang
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '${product.createTime}',
                                                      style: const TextStyle(
                                                          color: Colors
                                                              .black), // Boshqa rang
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  text: 'edit time:',
                                                  style: const TextStyle(
                                                      color: Colors
                                                          .deepPurpleAccent), // Boshqa rang
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '${product.editTime}',
                                                      style: const TextStyle(
                                                          color: Colors
                                                              .black), // Boshqa rang
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: "Title",
                      ),
                    ),
                    TextField(
                      controller: bodyController,
                      decoration: const InputDecoration(
                        hintText: "Body",
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      if (titleController.text.isEmpty ||
                          bodyController.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: const Text(
                                "Barcha maydonlarni to'ldiring"), // Xabar
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("OK"), // OK tugmasi
                              ),
                            ],
                          ),
                        );
                      } else {
                        await create();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Create"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                ],
              );
            },
          );
          clear();
        },
        child: const Text("+"),
      ),
    );
  }

  void _editProduct(BuildContext context, Note product) {
    titleController.text = product.title!;
    bodyController.text = product.body!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Title",
                ),
              ),
              TextField(
                controller: bodyController,
                decoration: const InputDecoration(
                  hintText: "Body",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                product.title = titleController.text;
                product.body = bodyController.text;
                if (titleController.text.isEmpty ||
                    bodyController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content:
                          const Text("Barcha maydonlarni to'ldiring"), // Xabar
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                } else {
                  await update(product);
                  Navigator.pop(context);
                }
              },
              child: const Text("Edit"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}

class Utils {
  // FireSnackBar
  static void fireSnackBar(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey.shade400.withOpacity(0.975),
        content: Text(
          msg,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        //  duration: const Duration(milliseconds: 2500),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        shape: const StadiumBorder(),
      ),
    );
  }
}
