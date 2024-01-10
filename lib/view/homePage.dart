import 'package:animain/view/cards/animeListCard.dart';
import 'package:animain/model/animeModel.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

  
class _HomePageState extends State<HomePage> {
  // AnimeModel dn = AnimeModel(
  //   title: 'Death Note', 
  //   description: 'Brutal murders, petty thefts, and senseless violence pollute the human world. In contrast, the realm of death gods is a humdrum, unchanging gambling den. The ingenious 17-year-old Japanese student Light Yagami and sadistic god of death Ryuk share one belief: their worlds are rotten.', 
  //   episodes: 37);
  List<AnimeModel> animeList = [];
  List<AnimeModel> viewableList = [];
  final formField = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _epsController = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    //animeList.add(dn);
    super.initState();
    viewableList = animeList;
  }
  
  Future onSearchTextChanged(String text) async {
    setState(() {
      viewableList = [];
      if (text.isNotEmpty) {
        for(int i = 0; i < animeList.length; i++){
          if(animeList[i].title.toLowerCase().contains(text.toLowerCase())){
            viewableList.add(animeList[i]);
          }
        }
      }
      else{
        viewableList = animeList;
      }
    });
  }

  void addAnime(String title, String description, int episodes){
    setState(() {
      AnimeModel newAnime = AnimeModel(title: title, description: description, episodes: episodes);
      animeList.add(newAnime);
      _titleController.clear();
      _descController.clear();
      _epsController.clear();
    });
  }

  void deleteAnime(AnimeModel anime){
    setState(() {
      animeList.remove(anime);
    });
  }

  void showRemovePrompt(BuildContext context){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          //No Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Text("Cancel",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            
            )
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                animeList.clear();
                Navigator.of(context).pop();
              });
            } ,
            child: const Text("DELETE",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            )
          ),
        ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: EdgeInsets.only(
              top: 10.0,
            ),
            title: Center(
              child: Text(
                "Delete all records?",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          );
    });
}

  void showAddDialog() {
    setState(() {

    });
    showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        insetPadding: EdgeInsets.all(24),
        contentPadding: EdgeInsets.zero,
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Text("Cancel",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            
            )
          ),
          GestureDetector(
            onTap: () {
              addAnime(_titleController.text, _descController.text, int.parse(_epsController.text));
              Navigator.of(context).pop();
            } ,
            child: const Text("SAVE",
              style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            )
          ),
        ],
        title: Text("Add New Anime",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        content: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              //The Content of the Dialog
              child: Form(
                key: formField,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          gapPadding: 4,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      )
                    ),
                    SizedBox(height: 12),
                    Text('Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _descController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          gapPadding: 4,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      )
                    ),
                    SizedBox(height: 12),
                    Text('Episodes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
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
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        )
                      ),
                    ),
                  ],
                ),
              ),
              
            ),
          ),
        ),
      );      
    } 
  );
  }



  @override
  Widget build(BuildContext context) {
    void refresh(){
      showDialog(
          barrierDismissible: false,
          context: context, 
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        );
      Timer(const Duration(milliseconds: 200), (){
        setState((){
          print("Page Updated");
        });
      });
      Navigator.of(context).pop();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            Text(widget.title),
            SizedBox(width: 20,),
            Container(
              width: 200,
              height: 40,
              
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => onSearchTextChanged(_searchController.text),
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          /* Clear the search field */
                          _searchController.clear();
                        },
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none),
                ),
              ),
            ),
          ],
        ),
        actions: [
          
          IconButton(icon: Icon(Icons.delete_forever_rounded, color: Colors.red, size: 24,),
            onPressed: () {
              showRemovePrompt(context);
            },
          ),
          
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                
                itemCount: viewableList.length,
                itemBuilder: (context, index) {
                  AnimeModel anime = viewableList[index];
                  //check if the list is empty
                  if(viewableList.isEmpty){
                    return const Text('No Records',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    );
                  }else{
                    return Dismissible(
                      key: Key(anime.title),
                      onDismissed: (direction) {
                        setState(() {
                          animeList.remove(anime);
                        });
                      },
                      background: Container(
                        color: Colors.redAccent,
                      ),
                      child: Container(
                        padding: EdgeInsets.only(bottom: 8.0),
                        decoration: BoxDecoration(
                          border: BorderDirectional(
                            bottom: BorderSide()
                          )
                        ),
                        child: AnimeListCard(anime: anime, callback: refresh),
                      ),
                    );
                    }
                },
              
              ),
              
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        tooltip: 'Add New',
        child: const Icon(Icons.add),
      ),
      resizeToAvoidBottomInset: true,
    );
    
  }
}
