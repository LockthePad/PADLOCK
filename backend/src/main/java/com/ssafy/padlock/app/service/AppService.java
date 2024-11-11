package com.ssafy.padlock.app.service;

import com.ssafy.padlock.app.controller.request.AppRequest;
import com.ssafy.padlock.app.domain.App;
import com.ssafy.padlock.app.repository.AppRepository;
import lombok.RequiredArgsConstructor;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AppService {

    @Value("${app.chromedriver.path}")
    private String chromeDriverPath;

    private final AppRepository appRepository;

    @Transactional
    public void addApp(AppRequest appRequest) {
        Long classroomId = appRequest.getClassroomId();
        String appName = appRequest.getAppName();

        //db에 존재하는지 확인
        Optional<App> existingApp = appRepository.findByClassroomIdAndAppName(classroomId, appName);

        if (existingApp.isPresent()) {
            App app = existingApp.get();
            app.activate();
        }
        // 기존 DB에 존재 하지 않을 때
        else {
            String appImgUrl = crawlAppImg(appName);
            App newApp = App.createApp(classroomId, appName, appImgUrl);
            appRepository.save(newApp);
        }
    }

    public String crawlAppImg(String appName) {
        System.setProperty("webdriver.chrome.driver", chromeDriverPath);

        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless");
        options.addArguments("--no-sandbox");
        options.addArguments("--disable-dev-shm-usage");

        WebDriver driver = new ChromeDriver(options);

        try {
            String url = "https://m.onestore.co.kr/mobilepoc/search/integrateSearch.omp";
            driver.get(url);

            WebElement searchField = driver.findElement(By.cssSelector("#integrateQuery"));
            searchField.sendKeys(appName);
            searchField.sendKeys(Keys.RETURN);

            WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
            WebElement imgElement = wait.until(ExpectedConditions.visibilityOfElementLocated(
                    By.cssSelector("#productListDiv > div:nth-child(1) > div > div.searchcard-item > a > span > span.searchcard-cell.searchcard-cell-thumbnail > span")));

            // JavaScript 실행을 통해 background-image 속성 가져오기
            String backgroundImageUrl = (String) ((JavascriptExecutor) driver).executeScript(
                    "return window.getComputedStyle(arguments[0]).backgroundImage;", imgElement);

            // URL만 추출
            backgroundImageUrl = backgroundImageUrl.replace("url(\"", "").replace("\")", "");
            System.out.println("이미지 URL: " + backgroundImageUrl);
            return backgroundImageUrl;

        } catch (Exception e) {
            System.out.println("이미지 URL을 크롤링하는 중 오류 발생: " + e.getMessage());
            return null;
        } finally {
            driver.quit();
        }
    }
}
