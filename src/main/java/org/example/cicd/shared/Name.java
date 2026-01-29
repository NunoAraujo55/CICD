package org.example.cicd.shared;

import lombok.Getter;

public class Name {

    @Getter
    private String name;

    protected Name() {}

    public Name(String name) {
        setName(name);
    }

    public void setName(String name) {
        if(name == null){
            throw new NullPointerException();
        }else if(name.isEmpty()){
            throw new IllegalArgumentException();
        }else if(name.length() < 2){
            throw new IllegalArgumentException();
        }else {
            this.name = name;
        }
    }

}
