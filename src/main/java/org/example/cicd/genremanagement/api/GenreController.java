package org.example.cicd.genremanagement.api;

import org.example.cicd.genremanagement.model.Genre;
import org.example.cicd.genremanagement.services.GenreService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GenreController {

    GenreService genreService;

    @PostMapping
    public Genre save(Genre genre) {
        return genreService.createGenre(genre);
    }

    @GetMapping
    public Genre getGenre(Genre genre) {
        return null;
    }
}
