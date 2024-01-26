import 'package:animain/bloc/anime_bloc.dart';
import 'package:animain/model/anime_model.dart';
import 'package:animain/util/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAnimeForm extends StatefulWidget {
  const AddAnimeForm({super.key});

  @override
  State<AddAnimeForm> createState() => _AddAnimeFormState();
}

class _AddAnimeFormState extends State<AddAnimeForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _epsController = TextEditingController();
  final formField = GlobalKey<FormState>();
  Anime animeUsed = Anime(title: '', description: '', episodes: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AnimeBloc, AnimeState>(
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(addedMsgString),
          showCloseIcon: true,
        ));
      },
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(24),
        contentPadding: EdgeInsets.zero,
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (formField.currentState!.validate()) {
                var anime = Anime(
                    title: _titleController.value.text,
                    description: _descController.value.text,
                    episodes: int.parse(_epsController.value.text));
                print('ANIME ID: ${anime.id}');
                context.read<AnimeBloc>().add(AddAnime(
                    title: anime.title,
                    description: anime.description,
                    episodes: anime.episodes));
                Navigator.of(context).pop();
              }
            },
            child: const Text(
              "SAVE",
              style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
        title: Text(
          'Add New Anime',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                //The Content of the Dialog
                child: Form(
                  key: formField,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Title',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              gapPadding: 4,
                            ),
                          ),
                          validator: (value) => value != null && value.isEmpty
                              ? 'Title is required.'
                              : null,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          )),
                      const SizedBox(height: 12),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                          controller: _descController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              gapPadding: 4,
                            ),
                          ),
                          validator: (value) => value != null && value.isEmpty
                              ? 'Description is required.'
                              : null,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          )),
                      const SizedBox(height: 12),
                      const Text(
                        'Episodes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 12),
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
                              border: OutlineInputBorder(),
                              counterStyle: TextStyle(
                                height: double.minPositive,
                              ),
                              counterText: "",
                            ),
                            validator: (value) =>
                                value != null && value.isEmpty
                                    ? 'Number of episodes is required.'
                                    : null,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
