package com.ssafy.padlock.ocr.controller;

import com.ssafy.padlock.ocr.controller.request.OcrRequest;
import com.ssafy.padlock.ocr.controller.response.OcrResponse;
import com.ssafy.padlock.ocr.service.OcrService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequiredArgsConstructor
public class OcrController {
    private final OcrService ocrService;

    @PostMapping("/ocr")
    public OcrResponse ocrFastApi(@RequestParam("image") MultipartFile image) {
        return ocrService.ocrFastApi(image);
    }

    @PostMapping("/ocr/save")
    public void saveOcr(@RequestBody OcrRequest ocrRequest) {
        ocrService.saveOcr(ocrRequest);
    }
}
