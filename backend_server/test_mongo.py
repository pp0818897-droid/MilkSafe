from mongoengine import connect
from pymongo import MongoClient
import os
from dotenv import load_dotenv

load_dotenv()

MONGO_URI = os.getenv("MONGO_URI", "mongodb://localhost:27017/")
MONGO_DB_NAME = os.getenv("MONGO_DB_NAME", "digital_farm")

print(f"Connecting to MongoDB at: {MONGO_URI} (DB: {MONGO_DB_NAME})")

try:
    client = MongoClient(MONGO_URI, serverSelectionTimeoutMS=2000)
    client.server_info() # Forces a call
    print("✅ MongoDB connection SUCCESSFUL.")
except Exception as e:
    print(f"❌ MongoDB connection FAILED: {e}")
