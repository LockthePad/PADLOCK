package com.ssafy.padlock.member.controller.request;

import com.ssafy.padlock.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class MemberController {
    private final MemberService memberService;

    @PostMapping("/admin/members")
    public void saveMember(@RequestBody String memberData) {
        memberService.saveMembers(memberData);
    }
}
