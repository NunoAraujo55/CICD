package org.example.cicd.genremanagement.services;

import org.example.cicd.genremanagement.model.Genre;

public interface GenreService {
    Genre getGenreById(int id);
    Genre getGenreByName(String name);
    Genre createGenre(Genre genre);
    Genre updateGenre(Genre genre);
    void deleteGenreById(int id);
}
