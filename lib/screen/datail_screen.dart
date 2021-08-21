import 'package:flutter/material.dart';
import 'package:movie_app/bloc/get_movie_videos_bloc.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/model/video.dart';
import 'package:movie_app/model/video_response.dart';
import 'package:movie_app/style/theme.dart' as Style;
import 'package:sliver_fab/sliver_fab.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  MovieDetailScreen({ Key key, this.movie }) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState(movie);
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final Movie movie;
  _MovieDetailScreenState(this.movie);
  @override
  void initState() {
    super.initState();
    movieVideosBloc..getMovieVideos(movie.id);
  }
  @override
  void dispose() {
    super.dispose();
    movieVideosBloc..drainStream();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      body: Builder(
        builder: (context) {
          return new SliverFab(
            floatingPosition: FloatingPosition(right: 20),
            floatingWidget: StreamBuilder<VideoResponse>(
              stream: movieVideosBloc.subject.stream,
              builder: (context, AsyncSnapshot<VideoResponse> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0
                  ) {
                    return _buildErrorWidget(snapshot.data.error);  
                  }
                  return _buildVideoWidget(snapshot.data);
                } else if (snapshot.hasError) {
                  return _buildErrorWidget(snapshot.error);
                }else {
                  return _buildLoadingWidget();
                }
              },
          ),
          expandedHeight: 200,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Style.Colors.mainColor,
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                movie.title.length > 40
                ? movie.title.substring(0, 37) + "..."
                : movie.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold
                ),
                ),
                background: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(image: NetworkImage(
                          "https://image.tmdb.org/t/p/original" + movie.backPoster
                        )) 
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5)
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black.withOpacity(0.9),
                                   Colors.black.withOpacity(0.0)
                          ]
                        )
                      ),
                    )
                ],),
              ),
            )
          ],
          );
        },
      ),
    );
  }
  Widget _buildLoadingWidget() {
    return Container();
  }
  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        children: <Widget>[
          Text("$error")
      ],
      ),
    );
  }
  Widget _buildVideoWidget(VideoResponse data) {
    List<Video> videos = data.videos;
    return FloatingActionButton(
      backgroundColor: Style.Colors.secondColor,
      child: Icon(Icons.play_arrow),
      onPressed: null
    );
  }
}