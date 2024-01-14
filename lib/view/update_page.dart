import 'package:animain/model/anime_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key, required this.anime});
  final Anime anime;

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  int value = 0;
  final formField = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _epsController = TextEditingController();

  @override
  void initState() {
    _titleController.text = widget.anime.title;
    _descController.text = widget.anime.description;
    _epsController.text = widget.anime.episodes.toString();
    super.initState();
  }
  
  showUpdatePage(Anime anime){
    
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Update'),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                
                Navigator.of(context).pop();
              });
            } ,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text("SAVE",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formField,
            child: Column(
              children: <Widget>[
                Center(
                  // child: Text(widget.anime.title,
                  //   style: TextStyle(
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                  child: TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            gapPadding: 4,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        )
                      ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: _epsController,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                    
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                          ),
                          counterStyle: TextStyle(height: double.minPositive,),
                          counterText: "",
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        )
                      ),
                    ),
                    const Text(" episodes",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16,),
                TextFormField(
                      controller: _descController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          gapPadding: 4,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      )
                    ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}