package com.ssafy.padlock.classroom.controller.response;

import com.ssafy.padlock.classroom.domain.Suggestion;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class SuggestionResponse {
    private Long suggestionId;
    private String studentName;
    private String content;
    private String time;
    private boolean isRead;

    public static SuggestionResponse from(Suggestion suggestion) {
        return new SuggestionResponse(suggestion.getId(), suggestion.getStudent().getName(),
                suggestion.getContent(), formatDateTime(suggestion.getTime()), suggestion.isRead());
    }

    private static String formatDateTime(LocalDateTime dateTime) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy.MM.dd HH:mm");
        return dateTime.format(formatter);
    }
}
