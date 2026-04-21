from flask import Flask

app = Flask(__name__)

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

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)