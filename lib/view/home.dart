import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template_flutter/models/movie.dart';
import 'package:template_flutter/resource/global_label_message.dart';
import 'package:template_flutter/view/components/button.dart';
import 'package:template_flutter/view_model/movie.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<MovieModel> movies = [];

  @override
  void initState() {
    super.initState();
  }

  loadMovies() {
    MovieViewModel viewModel = Provider.of<MovieViewModel>(context);

    viewModel.load();
    viewModel.addListener(() {
      if (viewModel.exception != null) {
        print(viewModel.exception!.message);
      }

      setState(() {
        movies = viewModel.getAll();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    loadMovies();

    return Scaffold(
        body: Stack(
      children: [
        Center(
          child: Wrap(
            direction: Axis.vertical,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            children: [
              Text(GlobalLabel.homeMessage.message),
              CustomButton(
                text: GlobalLabel.homeButton.message,
                onPressed: onPressed,
              ),
              ...movies.map(
                (e) => Text('${e.title} / ${e.director}'),
              ),
            ],
          ),
        )
      ],
    ));
  }

  onPressed() {
    print('Button pressed');
  }
}
