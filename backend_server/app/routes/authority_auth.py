from flask import Blueprint, request
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from datetime import timedelta
from app.utils.responses import success_response, error_response
from app.models.authorities import Authority
import hashlib # Basic hashing for demonstration; bcrypt in prod

authority_auth_bp = Blueprint('authority_auth', __name__)

def hash_password(password: str) -> str:
    return hashlib.sha256(password.encode()).hexdigest()

@authority_auth_bp.route('/login', methods=['POST'])
def authority_login():
    data = request.get_json() or {}
    username = data.get("username")
    password = data.get("password")

    if not username or not password:
        return error_response("Username and password are required", 400)

    authority = Authority.objects(username=username).first()
    
    if not authority or authority.password_hash != hash_password(password):
        return error_response("Invalid credentials", 401)

    access_token = create_access_token(identity=str(authority.id), expires_delta=timedelta(hours=24))

    return success_response({
        "message": "Login successful",
        "access_token": access_token,
        "role": authority.role
    }, 200)

@authority_auth_bp.route('/me', methods=['GET'])
@jwt_required()
def authority_me():
    authority_id = get_jwt_identity()
    authority = Authority.objects(id=authority_id).first()

    if not authority:
        return error_response("Authority not found", 404)

    return success_response({
        "id": str(authority.id),
        "name": authority.name,
        "username": authority.username,
        "role": authority.role
    }, 200)
