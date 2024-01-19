import 'package:animain/bloc/anime_bloc.dart';
import 'package:animain/model/anime_model.dart';
import 'package:animain/util/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnimeForm extends StatefulWidget {
  const AnimeForm(
      {super.key, this.anime, required this.onSubmit, required this.callback});

  final Anime? anime;
  final ValueChanged<List<String>> onSubmit;
  final VoidCallback callback;

  @override
  State<AnimeForm> createState() => _AnimeFormState();
}

class _AnimeFormState extends State<AnimeForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _epsController = TextEditingController();
  final formField = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.anime?.title ?? '';
    _descController.text = widget.anime?.description ?? '';
    _epsController.text = widget.anime?.episodes.toString() ?? '';
  }

  void cleanForm() {
    _titleController.clear();
    _descController.clear();
    _epsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.anime != null;
    return BlocListener<AnimeBloc, AnimeState>(
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: 
            Text(successMsgString),
            showCloseIcon: true,
          )
        );
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
                  episodes: int.parse(_epsController.value.text)
                );
                isEditing ? context.read<AnimeBloc>().add(UpdateAnime(anime: anime))
                : context.read<AnimeBloc>().add(AddAnime(anime: anime));
                widget.onSubmit([
                  _titleController.text,
                  _descController.text,
                  _epsController.text,
                ]);
                widget.callback();
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
          isEditing ? 'Edit ${widget.anime?.title}' : 'Add New Anime',
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
                            validator: (value) => value != null && value.isEmpty
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
