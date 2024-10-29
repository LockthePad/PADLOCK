package com.ssafy.padlock.member.controller;

import com.ssafy.padlock.auth.supports.LoginMember;
import com.ssafy.padlock.member.controller.response.ChildResponse;
import com.ssafy.padlock.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class MemberController {
    private final MemberService memberService;

    @PostMapping("/admin/members")
    public void saveMember(@RequestBody String memberData) {
        memberService.saveMembers(memberData);
    }

    @PreAuthorize("hasRole('PARENTS')")
    @GetMapping("/children")
    public List<ChildResponse> getChildrenInfo(@LoginMember Long parentsId) {
        return memberService.getChildrenInfo(parentsId);
    }
}
