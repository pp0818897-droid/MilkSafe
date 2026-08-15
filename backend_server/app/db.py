from pymongo import MongoClient
import certifi
from app.config import Config

class DB:
    client = None
    db = None
    farmers = None
    animals = None
    vets = None
    treatment_requests = None
    treatments = None
    consumer_checks = None
    authority_verifications = None
    authorities = None

    @classmethod
    def initialize(cls):
        try:
            from mongoengine import connect
            connect(db=Config.MONGO_DB_NAME, host=Config.MONGO_URI, tlsCAFile=certifi.where())
            cls.client = MongoClient(Config.MONGO_URI, tlsCAFile=certifi.where())
            cls.db = cls.client[Config.MONGO_DB_NAME]
            cls.farmers = cls.db.farmers
            cls.animals = cls.db.animals
            cls.vets = cls.db.vets
            cls.treatment_requests = cls.db.treatment_requests
            cls.treatments = cls.db.treatments
            cls.consumer_checks = cls.db.consumer_checks
            cls.authority_verifications = cls.db.authority_verifications
            cls.authorities = cls.db.authorities
        except Exception as e:
            # MongoDB is optional for now – continue without a DB connection
            cls.client = None
            cls.db = None
            print(f"[WARN] MongoDB connection failed (ignored): {e}")

    @classmethod
    def close(cls):
        if cls.client:
            cls.client.close()