import 'package:ditonton/domain/repositories/tv_show_repository.dart';

class GetWatchListTvShowStatus {
  final TvShowRepository repository;

  GetWatchListTvShowStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
