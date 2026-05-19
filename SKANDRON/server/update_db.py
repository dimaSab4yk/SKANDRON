from server import app, db  # Імпортуємо додаток та базу з твого головного файлу app.py
from sqlalchemy import text

print("Запуск оновлення бази даних...")

with app.app_context():
    try:
        # Виконуємо SQL-команду для додавання нової колонки в SQLite
        db.session.execute(text("ALTER TABLE scan ADD COLUMN scan_duration FLOAT;"))
        db.session.commit()
        print("Успіх: Колонка 'scan_duration' успішно додана до таблиці 'scan'!")
    except Exception as e:
        db.session.rollback()
        print(f"Помилка або колонка вже існує: {e}")