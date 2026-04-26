from flask import Flask, request, jsonify
from ultralytics import YOLO
import os
import cv2

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

import cv2 # Додай цей імпорт зверху

@app.route('/upload', methods=['POST'])
def upload_image():
    if 'image' not in request.files:
        return jsonify({"error": "No image"}), 400
    
    file = request.files['image']
    file_path = os.path.join(UPLOAD_FOLDER, file.filename)
    file.save(file_path)

    # 1. Запускаємо YOLO
    results = model.predict(source=file_path, save=False)
    
    # 2. МАЛЮЄМО РАМКИ
    # Метод plot() створює копію картинки з натягнутими рамками та назвами
    res_plotted = results[0].plot()
    
    # 3. ЗБЕРІГАЄМО ОБРОБЛЕНЕ ФОТО
    result_filename = "res_" + file.filename
    result_path = os.path.join(UPLOAD_FOLDER, result_filename)
    cv2.imwrite(result_path, res_plotted) 

    detected_objects = []
    for box in results[0].boxes:
        label = model.names[int(box.cls[0])]
        confidence = float(box.conf[0])
        detected_objects.append({"label": label, "confidence": round(confidence, 2)})

    # 4. ПОВЕРТАЄМО URL ОБРОБЛЕНОГО ФОТО
    return jsonify({
        "status": "success",
        "objects": detected_objects,
        "result_image_url": f"http://192.168.1.2:5000/download/{result_filename}"
    })

# Додай цей новий маршрут, щоб Flutter міг скачати оброблене фото
from flask import send_from_directory
@app.route('/download/<filename>')
def download_file(filename):
    return send_from_directory(UPLOAD_FOLDER, filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)