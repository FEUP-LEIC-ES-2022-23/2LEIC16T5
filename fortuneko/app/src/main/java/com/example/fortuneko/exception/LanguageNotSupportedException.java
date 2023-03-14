package com.example.fortuneko.exception;

public class LanguageNotSupportedException extends Exception{

    public LanguageNotSupportedException(String language){
        super(String.format("Language [%s] is not supported\n", language));
    }

}
