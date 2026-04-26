from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from ultralytics import YOLO
from datetime import datetime
import os
import cv2

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///scans.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Scan(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    original_image = db.Column(db.String(100), nullable=False)
    processed_image = db.Column(db.String(100), nullable=False)
    result_text = db.Column(db.String(200))
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)

    def __repr__(self):
        return f'<Scan {self.image_name}>'

with app.app_context():
    db.create_all()

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
        return jsonify({"error": "No image"}), 400
    
    file = request.files['image']
    
    scan_count = Scan.query.count() + 1
    base_name = f"Drone_to_scan{scan_count}"
    
    ext = os.path.splitext(file.filename)[1]
    
    orig_filename = f"{base_name}_orig{ext}" 
    res_filename = f"{base_name}_res{ext}"   

    orig_path = os.path.join(UPLOAD_FOLDER, orig_filename)
    file.save(orig_path)

    results = model.predict(source=orig_path, save=False)
    res_plotted = results[0].plot()
    
    res_path = os.path.join(UPLOAD_FOLDER, res_filename)
    cv2.imwrite(res_path, res_plotted) 

    detected_objects = []
    for box in results[0].boxes:
        label = model.names[int(box.cls[0])]
        confidence = float(box.conf[0])
        detected_objects.append({"label": label, "confidence": round(confidence, 2)})

    try:
        new_scan = Scan(
            original_image=orig_filename,
            processed_image=res_filename,
            result_text=str(detected_objects)
        )
        db.session.add(new_scan)
        db.session.commit()
        print(f"Успішно збережено: {orig_filename} та {res_filename}")
    except Exception as e:
        print(f"Помилка БД: {e}")

    return jsonify({
        "status": "success",
        "objects": detected_objects,
        "original_image_url": f"http://192.168.1.2:5000/download/{orig_filename}",
        "result_image_url": f"http://192.168.1.2:5000/download/{res_filename}"
    })

from flask import send_from_directory
@app.route('/download/<filename>')
def download_file(filename):
    return send_from_directory(UPLOAD_FOLDER, filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)