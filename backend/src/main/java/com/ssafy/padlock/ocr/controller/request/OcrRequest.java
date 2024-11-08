package com.ssafy.padlock.ocr.controller.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OcrRequest {
    private Long memberId;
    private List<String> content;
    private String createDate;
}
