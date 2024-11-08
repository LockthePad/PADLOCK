package com.ssafy.padlock.ocr.controller;

import com.ssafy.padlock.auth.supports.LoginMember;
import com.ssafy.padlock.ocr.controller.request.OcrRequest;
import com.ssafy.padlock.ocr.controller.response.OcrResponse;
import com.ssafy.padlock.ocr.controller.response.OcrTotalResponse;
import com.ssafy.padlock.ocr.repository.OcrRepository;
import com.ssafy.padlock.ocr.service.OcrService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class OcrController {
    private final OcrService ocrService;
    private final OcrRepository ocrRepository;

    @PostMapping("/ocr")
    public OcrResponse ocrFastApi(@RequestParam("image") MultipartFile image) {
        return ocrService.ocrFastApi(image);
    }

    @PostMapping("/ocr/save")
    public void saveOcr(@LoginMember Long memberId, @RequestBody OcrRequest ocrRequest) {
        ocrService.saveOcr(memberId, ocrRequest);
    }

    @GetMapping("/ocr")
    public List<OcrTotalResponse> getOcrList(@LoginMember Long memberId) {
        return ocrService.getOcrList(memberId);
    }
}
