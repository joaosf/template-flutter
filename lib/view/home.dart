import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template_flutter/resource/global_label_message.dart';
import 'package:template_flutter/view/components/button.dart';
import 'package:template_flutter/view_model/movie.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late MovieViewModel viewModel;

  @override
  void initState() {
    super.initState();
  }

  revertString(String text) {
    return text.split(' ').map((e) => e.split('').reversed.join()).join(' ');
  }

  loadMovies() {
    viewModel.load();
    viewModel.addListener(() {
      if (viewModel.exception != null) {
        print(viewModel.exception!.message);
      }

      print(revertString(viewModel.movies.first.title));
    });
  }

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<MovieViewModel>(context);

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
              ...viewModel.movies.map(
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
    loadMovies();
  }
}
