from flask import Flask, request, jsonify
from ultralytics import YOLO
import os

app = Flask(__name__)

model = YOLO('yolov8n.pt') 

UPLOAD_FOLDER = 'uploads'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

@app.route('/click/last_result', methods=['POST'])
def LastResult_click():
    print("Повідомлення: Користувач натиснув кнопку LastResult!")
    return {"status": "ok", "message": "Сервер побачив твоє натискання!"}

@app.route('/click/history', methods=['POST'])
def History_click():
    print("Повідомлення: Користувач натиснув кнопку History!")
    return {"status": "ok", "message": "Сервер побачив твоє натискання!"}

@app.route('/click/scan_init', methods=['POST'])
def scan_init_click():
    print("Запит: Користувач хоче відкрити меню сканування")
    return {"status": "authorized", "message": "Меню дозволено"}

@app.route('/click/GalleryBotton', methods=['POST'])
def galleryBotton_click():
    print("Запит: Користувач хоче відкрити галерею")
    return {"status": "ok", "action": "open_gallery"}

@app.route('/click/CameraButton', methods=['POST'])
def cameraBotton_click():
    print("Запит: Користувач хоче відкрити камеру")
    return {"status": "ok", "action": "open_camera"}

@app.route('/upload', methods=['POST'])
def upload_image():
    if 'image' not in request.files:
        print("Помилка: Файл не знайдено у запиті")
        return jsonify({"error": "No image part"}), 400
    
    file = request.files['image']
    
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    file_path = os.path.join(UPLOAD_FOLDER, file.filename)
    file.save(file_path)
    print(f"Файл збережено: {file_path}")

    results = model.predict(source=file_path, save=False)
    
    detected_objects = []
    
    for result in results:
        for box in result.boxes:
            class_id = int(box.cls[0])
            label = model.names[class_id]
            confidence = float(box.conf[0])
            
            detected_objects.append({
                "label": label,
                "confidence": round(confidence, 2)
            })
    
    print(f"Знайдені об'єкти: {detected_objects}")

    return jsonify({
        "status": "success",
        "objects": detected_objects,
        "image_name": file.filename
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)