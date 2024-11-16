from fastapi import FastAPI, File, UploadFile, HTTPException, Query, Request
from fastapi.responses import JSONResponse, PlainTextResponse  
from simple_lama_inpainting import SimpleLama
from ultralytics import YOLO
from PIL import Image
import cv2
import numpy as np
import requests
import uuid
import time
import json
import torch
from PIL import Image
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from bs4 import BeautifulSoup
from pydantic import BaseModel
from typing import Optional
import os
from dotenv import load_dotenv

load_dotenv()
app = FastAPI()

API_KEY = os.environ.get('API_KEY')
SECRET_KEY = os.environ.get('SECRET_KEY')
SERVER = os.environ.get('CRAWLING_URL')

# 모델 로드
person_model = YOLO("/path/person_model")
custom_model = YOLO("/path/custom_model")
simple_lama = SimpleLama()
 
options = webdriver.ChromeOptions()
options.add_argument('--headless')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')
driver = webdriver.Chrome(options=options)

class AppRequest(BaseModel):
    appName: str

@app.post("/process-image")
async def process_image(image: UploadFile = File(...)):
    contents = await image.read()
    np_arr = np.frombuffer(contents, np.uint8)
    img = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)

    if img is None:
        raise HTTPException(status_code=400, detail="이미지 파일을 읽을 수 없습니다.")
        
    # 사람 탐지
    person_results = person_model(img)
    mask = np.zeros(img.shape[:2], dtype=np.uint8)
    person_detected = False

    for detection in person_results[0].boxes:
        if detection.cls == 0:
            x1, y1, x2, y2 = map(int, detection.xyxy[0])
            mask[y1:y2, x1:x2] = 255
            person_detected = True

    # 사람 탐지된 경우에만 인페인팅
    if person_detected:
        img_pil = Image.fromarray(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
        mask_pil = Image.fromarray(mask)
        inpainted_img_pil = simple_lama(img_pil, mask_pil)
        inpainted_img = cv2.cvtColor(np.array(inpainted_img_pil), cv2.COLOR_RGB2BGR)
    else:
        inpainted_img = img

    # 칠판 탐지
    custom_results = custom_model(inpainted_img)
    blackboard_resized = None

    for detection in custom_results[0].boxes:
        if detection.cls in [0, 1]:
            x1, y1, x2, y2 = map(int, detection.xyxy[0])
            blackboard_img = inpainted_img[y1:y2, x1:x2]
            
            scale_factor = 2
            blackboard_resized = cv2.resize(blackboard_img, (0, 0), fx=scale_factor, fy=scale_factor)
            break
    
    if blackboard_resized is not None:
        _, img_encoded = cv2.imencode('.jpg', blackboard_resized)
        img_bytes = img_encoded.tobytes()

        request_json = {
            'images': [
                {
                    'format': 'jpg',
                    'name': 'demo'
                }
            ],
            'requestId': str(uuid.uuid4()),
            'version': "V2",
            'timestamp': int(round(time.time() * 1000))
        }
        payload = {'message': json.dumps(request_json).encode('UTF-8')}
        files = [
            ('file', ('temp_blackboard.jpg', img_bytes, 'image/jpeg'))
        ]
        headers = {
          'X-OCR-SECRET': SECRET_KEY
        }

        # OCR
        response = requests.post(API_URL, headers=headers, data=payload, files=files)

        try:
            response_json = response.json()
            infer_texts = [field['inferText'] for field in response_json['images'][0]['fields']]
            return JSONResponse(content={"text": infer_texts})
        except json.JSONDecodeError:
            raise HTTPException(status_code=500, detail="OCR 응답을 JSON으로 변환할 수 없습니다.")
        except KeyError:
            raise HTTPException(status_code=500, detail="OCR 응답에 'images' 또는 'fields' 키가 없습니다.")
    else:
        return {"message": "칠판 영역이 탐지되지 않았습니다."}

@app.post("/get-app-image", response_class=JSONResponse)
async def get_app_image(request: AppRequest):
    app_name = request.appName
    try:
        image_url = get_image_url(app_name)
        if image_url:
            return {"imageUrl": image_url}
        else:
            return {"imageUrl": "https://img.freepik.com/premium-vector/white-technology-app-icon-blank-template_109181-44.jpg"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

def get_image_url(app_name: str) -> Optional[str]:
    driver.get(CRAWLING_URL)
    search_box = driver.find_element(By.CSS_SELECTOR, "#integrateQuery")
    search_box.send_keys(app_name)
    search_box.send_keys(Keys.RETURN)
    
    time.sleep(3) 
    
    soup = BeautifulSoup(driver.page_source, 'html.parser')
    
    image_element = soup.select_one("#productListDiv > div:nth-child(1) > div > div.searchcard-item > a > span > span.searchcard-cell.searchcard-cell-thumbnail > span")
    
    if image_element:
        style_attribute = image_element.get("style")
        if style_attribute:
            image_url = style_attribute.split("url('")[1].split("')")[0]
            return image_url
    return None

@app.on_event("shutdown")
async def shutdown_event():
    driver.quit()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8001)