package org.example.cicd.genremanagement.model;

import org.example.cicd.shared.Name;
import lombok.Getter;

import lombok.Setter;

public class Genre {

    private int id;

    @Getter
    @Setter
    private Name name;

    public Genre(Name name) {
        this.name = name;
    }

    public Genre(int id, Name name) {
        this.id = id;
        setName(name);
    }

    public Genre(int id, String name) {
        this.id = id;
        setName(new Name(name));
    }

}
