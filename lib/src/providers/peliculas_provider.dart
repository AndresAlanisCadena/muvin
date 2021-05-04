import 'dart:async';
import 'dart:convert';

import 'package:muvin/src/models/actores_model.dart';
import 'package:muvin/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apikey = 'cea82cae0bcb636ed2bc9a700363143e';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPages = 0;

  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStream() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final respuesta = await http.get(url);
    final dataDecode = json.decode(respuesta.body);
    final peliculaspopu = new Peliculas.fromJsonList(dataDecode['results']);
    return peliculaspopu.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});
    final respuesta = await http.get(url);
    final dataDecode = json.decode(respuesta.body);

    final pelicula = new Peliculas.fromJsonList(dataDecode['results']);

    return pelicula.items;
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];
    _cargando = true;
    _popularesPages++;
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPages.toString()
    });

    final respuesta = await _procesarRespuesta(url);
    _populares.addAll(respuesta);
    popularesSink(_populares);
    _cargando = false;
    return respuesta;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/{$peliId}/credits',
        {'api_key': _apikey, 'language': _language});

    final respuesta = await http.get(url);
    final dataDecode = json.decode(respuesta.body);
    final cast = new Cast.fromJsonList(dataDecode['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apikey, 'language': _language, 'query': query});

    return await _procesarRespuesta(url);
  }
}
